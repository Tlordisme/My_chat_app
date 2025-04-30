import { Router, Request, Response } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { fetchConversationByUserId } from "../controllers/conversationController";



const router = Router();

router.get('/',verifyToken, fetchConversationByUserId);


export default router;