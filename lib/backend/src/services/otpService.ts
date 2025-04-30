// services/otpService.ts
import { ENV } from "../config/env";
import { redisClient } from "../utils/redisClient";
import nodemailer from "nodemailer";


const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: ENV.EMAIL_USER,
    pass: ENV.EMAIL_PASS,
  },
});
export const generateAndSendOtp = async (email: string): Promise<string> => {
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  await redisClient.set(`otp:${email}`, otp, { EX: 180 }); // Lưu 3 phút

  await transporter.sendMail({
    from: `"APP CHAT CUA THANH"`,
    to: email,
    subject: "Xác thực OTP",
    text: `Mã OTP của bạn là: ${otp}`,
  });

  return otp;
};

export const verifyOtp = async (email: string, inputOtp: string): Promise<boolean> => {
  const storedOtp = await redisClient.get(`otp:${email}`);
  return storedOtp === inputOtp;
};
