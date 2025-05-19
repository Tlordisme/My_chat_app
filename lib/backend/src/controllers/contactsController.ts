import { Request, Response } from "express";
import pool from "../models/db";

export const fetchContacts = async (req: Request, res: Response): Promise<any> => {
    let userId = null;
    if(req.user) {
        userId = req.user.id;
    }

    try {
        const result = await pool.query(
            `
            SELECT u.id AS contact_id, u.username, u.email
            FROM contacts c 
            JOIN users u ON u.id = c.contact_id
            WHERE c.user_id = $1
            ORDER BY u.username ASC;
            `, 
            [userId]
        );
        return res.json(result.rows);
    }
    catch(error) {
        console.error("Error fetching: ", error);
        return res.status(500).json({error: "Failed Fetch"});
    }
}


export const addContact = async (req: Request, res: Response): Promise<any> => {
    let userId = null;
    if (req.user) {
        userId = req.user.id;
    }

    const { contactEmail } = req.body;

    if (!contactEmail || !userId) {
        return res.status(400).json({ error: "User ID and Contact ID are required" });
    }

    try {
        // Kiểm tra xem contactId có tồn tại trong bảng users không
        const contactExist = await pool.query(
            `SELECT id FROM users WHERE email = $1`, 
            [contactEmail]
        );

        if (contactExist.rowCount === 0) {
            return res.status(404).json({ error: "Contact not found" });
        }

        const contactId = contactExist.rows[0].id;

        // Thực hiện thêm contact vào bảng contacts
        const result = await pool.query(
            `INSERT INTO contacts (user_id, contact_id) 
             VALUES ($1, $2)
             ON CONFLICT DO NOTHING;`,
            [userId, contactId]
        );

        // Kiểm tra xem có thêm thành công không
        if (result.rowCount === 0) {
            return res.status(400).json({ error: "Contact already exists" });
        }

        return res.status(201).json({ message: "Contact added successfully" });

    } catch (error) {
        console.error("Error adding contact: ", error);
        return res.status(500).json({ error: "Failed to add contact" });
    }
};