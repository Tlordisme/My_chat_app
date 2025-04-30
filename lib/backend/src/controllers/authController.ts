import { Request, Response } from "express";
import pool from "../models/db";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";
import { ENV } from "../config/env";
import { redisClient } from "../utils/redisClient";
import { generateAndSendOtp } from "../services/otpService";
// import { error } from "console";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: ENV.EMAIL_USER,
    pass: ENV.EMAIL_PASS,
  },
});

//REGISTER
export const register = async (req: Request, res: Response) => {
  const { username, email, password } = req.body;
  try {
    const userExists = await pool.query(
      "SELECT * FROM users WHERE email = $1",
      [email]
    );

    if (userExists.rows.length > 0) {
      const user = userExists.rows[0];
      if (user.is_verified) {
        res.status(400).json({ message: "Email tồn tại" });
        return;
      } else {
        await generateAndSendOtp(email);
        res.status(201).json({
          message: "Đăng ký thành công! Vui lòng kiểm tra email để nhập OTP.",user
        });
      }
    }

    //Test

    const hashedPassword = await bcrypt.hash(password, ENV.ENCRYPT_SALT);

    const result = await pool.query(
      "INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *",
      [username, email, hashedPassword]
    );

    await generateAndSendOtp(email);
    const user =  result.rows[0];
    res.status(201).json({
      message: "Đăng ký thành công! Vui lòng kiểm tra email để nhập OTP.",user
    });
  } catch (error) {
    console.error("Loõi khi đăng kí:", error);
    res.status(500).json({ error: "Đăng kí thất bại", details: error });
  }
};



//LOGIN
export const login = async (req: Request, res: Response): Promise<any> => {
  const { email, password } = req.body;
  try {
    const result = await pool.query("SELECT * FROM users WHERE email = $1 AND is_verified = true", [
      email,
    ]);
    const user = result.rows[0];
    if (!user) return res.status(201).json({ message: "No user" });

    const isRight = await bcrypt.compare(password, user.password);
    if (!isRight) return res.status(201).json({ message: "Wrong" });

    const token = jwt.sign({ id: user.id }, ENV.JWT_SECRET, {
      expiresIn: "1h",
    });

    let finalResult = { ...user, token };
    res.json({ user: finalResult });
  } catch (error) {
    console.error("Error during Log in :", error); // Log lỗi chi tiết
    res.status(500).json({ error: "Failed to log in", details: error });
  }
};

//Verify

export const verifyOtp = async (req: Request, res: Response) => {
  const { email, otp } = req.body;

  try {
    const storedOTP = await redisClient.get(`otp:${email}`);
    if (!storedOTP) {
      res.status(400).json({ message: "OTP hết hạn hoặc ko tồn tại" });
      return;
    }

    if (storedOTP !== otp) {
      res.status(400).json({ message: "OTP ko chính xác." });
      return;
    }

    await pool.query("UPDATE users SET is_verified = true WHERE email = $1", [
      email,
    ]);
    await redisClient.del(`otp:${email}`);

    res
      .status(200)
      .json({ message: "Xác thực thành công, tài khoản đã được kích hoạt!" });
  } catch (error) {
    console.error("lỖI XÁC THỰC otp:", error);
    res.status(500).json({ error: "Lỗi xác thực OTP", details: error });
  }
};

