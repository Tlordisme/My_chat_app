// src/utils/redisClient.ts
import { createClient } from "redis";
import { ENV } from "../config/env";

export const redisClient = createClient({
   url: ENV.REDIS_URL,
});

redisClient.on("connect", () => console.log("✅ Redis connected"));
redisClient.on("error", (err) => console.error("❌ Redis Error:", err));

(async () => {
  try {
    await redisClient.connect();
  } catch (err) {
    console.error("❌ Redis connect failed:", err);
  }
})();