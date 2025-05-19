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



export const checkOrCreateConversation = async (req: Request, res: Response): Promise<any> => {
    let userId = null;
    if (req.user) {
        userId = req.user.id;
    }

    const { contactId } = req.body;

    if (!contactId || !userId) {
        return res.status(400).json({ error: "Missing contactId or unauthenticated user" });
    }

    try {
        // Kiểm tra xem cuộc trò chuyện đã tồn tại chưa
        const existing = await pool.query(
            `
            SELECT c.id
            FROM conversations c
            JOIN conversation_members cm ON cm.conversation_id = c.id
            WHERE c.is_group = false
            GROUP BY c.id
            HAVING 
                COUNT(*) = 2 AND 
                BOOL_AND(cm.user_id = $1 OR cm.user_id = $2)
            LIMIT 1;
            `,
            [userId, contactId]
        );

        if (existing.rowCount != 0) { 
            if(existing.rowCount != null) {
                return res.json({ conversationId: existing.rows[0].id });
            }
        }
        else {
            const newConversation = await pool.query(
                `
                INSERT INTO conversations (is_group)
                VALUES (false)
                RETURNING id;
                `
            );
            const conversationId = newConversation.rows[0].id;

            // Thêm thành viên vào cuộc trò chuyện
            await pool.query(
                `
                INSERT INTO conversation_members (conversation_id, user_id)
                VALUES ($1, $2), ($1, $3);
                `,
                [conversationId, userId, contactId]
            );
    
            return res.json({ conversationId });
        }

        // Tạo cuộc trò chuyện mới  


    } catch (e) {
        console.error("Error adding new conversation: ", e);
        return res.status(500).json({ error: 'Failed to create new conversation' });
    }
};



// export const checkOrCreateConversation = async (req: Request, res: Response) : Promise<any> => {
//     let userId = null;
//     if (req.user ) {
//         userId = req.user.id;
//     }

//     const {contactId} = req.body
//     try {
//         const existingConversation = await pool.query(
//             `
//             SELECT c.id 
//             FROM conversations c
//             JOIN conversation_members cm1 ON cm1.conversation_id = c.id AND cm1.user_id = $1
//             JOIN conversation_members cm2 ON cm2.conversation_id = c.id AND cm2.user_id = $2                OR (participant_one = $2 AND participant_two = $1)
//             WHERE c.is_group = false
//             GROUP BY c.id
//             HAVING COUNT(*) = 2
//             LIMIT 1;
//             `,
//             [userId, contactId]
//         );
//         if (existingConversation.rowCount! > 0 && existingConversation.rowCount != null) {
//             res.json({conversationId : existingConversation.rows[0].id})
//         }
//         const newConversation = await pool.query(
//             `
//             INSERT INTO conversations (is_group)
//             VALUES (false)
//             RETURNING id;
//             `
//         );
//         const conversationId = newConversation.rows[0].id;
//         await pool.query(`
//             INSERT INTO conversation_members (conversation_id, user_id)
//             VALUES ($1, $2), ($1, $3);
//         `, [conversationId, userId, contactId]);
//         res.json({conversaionId: newConversation.rows[0].id});
//     } catch (e) {
//         console.log("Error adding new conversation: ", error);
//         res.status(500).json({error: 'Failed to create new conversation'});
//     }
// }



//FETCH cũ
         
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