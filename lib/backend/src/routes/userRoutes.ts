import { Router } from "express";
import { verifyToken } from "../middleware/authMiddleware";
import { searchUsers } from "../controllers/userController";

const router = Router();

router.get('/search-users', verifyToken, searchUsers);

export default router;
