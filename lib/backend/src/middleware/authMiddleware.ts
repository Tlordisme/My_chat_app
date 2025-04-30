import { Request, Response, NextFunction } from "express";
import { ENV } from "../config/env";
import jwt from "jsonwebtoken";

export const verifyToken = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {

  
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    res.status(403).json({ error: "No token " });
    return;
  }
  console.log("Decoded without verify:", token);
  try {
    const decoded = jwt.verify(token, ENV.JWT_SECRET);
    req.user = decoded as {id: string};
    console.log("Decoded without verify:", decoded);

    next();
  } catch (e) {
    res.status(401).json({ error: "Invalid" });
  }
};
