import { Router, Request, Response } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { checkOrCreateConversation, fetchConversationByUserId } from "../controllers/conversationController";



const router = Router();

router.get('/',verifyToken, fetchConversationByUserId);
router.post('/check-create',verifyToken, checkOrCreateConversation);


export default router;