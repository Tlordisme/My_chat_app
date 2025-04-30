import pool from "../models/db";
import { Request, Response } from "express";


export const fetchConversationByUserId = async (req: Request, res: Response) => {
    let userId = null;
    if(req.user) {
        userId = req.user.id;
    }
    console.log("userid "+ userId );

    try {
        const result = await pool.query(
         
            // `
            // SELECT 
            //     c.id AS conversation_id,
            //     CASE 
            //         WHEN u1.id = $1 THEN u2.username 
            //         ELSE u1.username
            //     END AS participant_name,
            //     m.content AS last_message,
            //     m.created_at AS last_message_time
            // FROM conversations c
            // JOIN users u1 ON u1.id = c.participant_one
            // JOIN users u2 ON u2.id = c.participant_two
            // LEFT JOIN LATERAL (
            //     SELECT content, created_at 
            //     FROM messages
            //     WHERE conversation_id = c.id
            //     ORDER BY created_at DESC
            //     LIMIT 1
            // ) m ON true
            // WHERE c.participant_one = $1 or c.participant_two = $1
            // ORDER BY m.created_at DESC;
            // `,
            // [userId]


            // Group Chat + 1-1 Chat
            `
            SELECT 
                c.id AS conversation_id,
                c.name AS group_name,
                c.is_group,
                (
                    SELECT json_agg(u2.username ORDER BY u2.username)
                    FROM conversation_members cm2
                    JOIN users u2 ON u2.id = cm2.user_id
                    WHERE cm2.conversation_id = c.id
                ) AS participants,
                m.last_message,
                m.last_message_time
            FROM conversations c
            JOIN conversation_members cm ON cm.conversation_id = c.id
            LEFT JOIN (
                SELECT DISTINCT ON (conversation_id)
                    conversation_id,
                    content AS last_message,
                    created_at AS last_message_time
                FROM messages
                ORDER BY conversation_id, created_at DESC
            ) m ON m.conversation_id = c.id
            WHERE cm.user_id = $1
            GROUP BY c.id, c.name, c.is_group, m.last_message, m.last_message_time
            ORDER BY m.last_message_time DESC NULLS LAST;
            `,
            [userId]
        );
        console.log("user: "+ userId)
        console.log(result);
        res.json(result.rows);
    } catch(e) {
        res.status(500).json({error: 'Failed fetch conversation'});
    }
}