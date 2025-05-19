import dotenv from "dotenv";

dotenv.config();

export const ENV = {
  DB_USER: process.env.DB_USER || "postgres",
  DB_PASSWORD: process.env.DB_PASSWORD || "Thanh2182003?",
  DB_HOST: process.env.DB_HOST || "localhost",
  DB_PORT: Number(process.env.DB_PORT) || 5432,
  DB_NAME: process.env.DB_NAME || "ChatAppDemo",
  JWT_SECRET: process.env.JWT_SECRET || "chatappsecret",
  ENCRYPT_SALT: 10,
  EMAIL_USER: process.env.EMAIL_USER || "yenchi831977@gmail.com",
  EMAIL_PASS: process.env.EMAIL_PASS || "grnk hrmm ukmw wgom",
  PORT: Number(process.env.PORT) || 8000,
  REDIS_URL: `redis://default:1Blaa8t3Co9pz4Hi0Mra4oTlCmJT8lns@redis-17148.c258.us-east-1-4.ec2.redns.redis-cloud.com:17148`,
  CLOUDINARY_NAME: 'defodsokf',
  CLOUDINARY_API_KEY: "398415277993922",
  CLOUDINARY_API_SECRET: "J69SZeJLwMDRTm-6tZ8aub5YSPE",
};
