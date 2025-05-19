import { v2 as cloudinary } from "cloudinary";
import { Readable } from "stream";
import pool from "../models/db";
import { Request, Response } from "express";
import { ENV } from "../config/env";

cloudinary.config({
  cloud_name: ENV.CLOUDINARY_NAME!,
  api_key: ENV.CLOUDINARY_API_KEY!,
  api_secret: ENV.CLOUDINARY_API_SECRET!,
});

export const fetchMessageByConversationId = async (
  req: Request,
  res: Response
) => {
  const { conversationId } = req.params;
  try {
    const result = await pool.query(
      `
            SELECT m.id, m.content, m.sender_id, m.conversation_id, m.created_at, m.media_url, m.media_type
            FROM messages m
            WHERE m.conversation_id = $1
            ORDER BY m.created_at ASC;
            `,
      [conversationId]
    );
    res.json(result.rows);
  } catch (e) {
    res.status(500).json({ error: " Failed to fetch messages" });
  }
};

export const saveMessage = async (
  conversationId: string,
  sender_id: string,
  content: string,
  media_url: string | null,
  media_type: string | null
) => {
  try {
    const result = await pool.query(
      `
            INSERT INTO messages (conversation_id, sender_id, content, media_url, media_type) VALUES ($1, $2, $3, $4, $5) Returning *;
            `,
      [conversationId, sender_id, content, media_url, media_type]
    );
    return result.rows[0];
  } catch (e) {
    console.error("Failed to save message:", e); // Log chi tiết lỗi
    throw new Error("Failed to save message");
  }
};

export const uploadMediaMessage = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { conversationId, senderId, content } = req.body;
  const file = req.file;

  if (!file) {
    res.status(400).json({ error: "No file uploaded" });
    return;
  }

  try {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        resource_type: "auto",
        folder: `chat_app/${senderId}/${conversationId}`,
      },
      async (error, result) => {
        if (error || !result) {
          console.error("Cloudinary Error:", error);
          res.status(500).json({ error: "Upload failed" });
          return;
        }

        const savedMessage = await saveMessage(
          conversationId,
          senderId,
          content || "",
          result.secure_url,
          result.resource_type
        );

        res.status(200).json(savedMessage);
      }
    );

    Readable.from(file.buffer).pipe(uploadStream);
  } catch (err) {
    console.error("Upload failed:", err);
    res.status(500).json({ error: "Upload failed" });
  }
};
