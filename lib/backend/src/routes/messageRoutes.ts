import { Router } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { fetchMessageByConversationId, uploadMediaMessage } from "../controllers/messageController";
import { upload } from "../middleware/upload";


const router = Router();

router.get("/:conversationId", verifyToken, fetchMessageByConversationId);

router.post("/upload", upload.single("file"), uploadMediaMessage); // file là key upload
export default router;
