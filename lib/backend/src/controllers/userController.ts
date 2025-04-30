import { Request, Response } from "express";
import pool from "../models/db";

export const searchUsers = async (req: Request, res: Response) => {
    const { username } = req.query;

    try {
        const result = await pool.query(
            `SELECT id, username FROM users WHERE username ILIKE $1 LIMIT 10`,
            [`%${username}%`]
        );
        res.json(result.rows);
    } catch (e) {
        res.status(500).json({ error: "Failed to search users" });
    }
};
