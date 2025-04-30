import { Router } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { fetchMessageByConversationId } from "../controllers/messageController";

const router = Router();

router.get("/:conversationId", verifyToken, fetchMessageByConversationId);

export default router;
