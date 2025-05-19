import express, { Request, Response } from "express";
import { json } from "body-parser";
import conversationRoutes from "./routes/conversationRoutes";
import authRoutes from "./routes/authRoutes";
import { ENV } from "./config/env";
import messageRoutes from "./routes/messageRoutes";
import http from "http";
import { Server } from "socket.io";
import { saveMessage } from "./controllers/messageController";
import contactsRoutes from "./routes/contactsRoutes";

const app = express();
const cors = require("cors");
app.use(cors());

const server = http.createServer(app);
app.use(json());

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

app.use("/auth", authRoutes);
app.use("/conversations", conversationRoutes);
app.use("/messages", messageRoutes);
app.use("/contacts", contactsRoutes );

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  //user1
  //user2

  socket.on("joinConversation", (conversationId) => {
    socket.join(conversationId);
    console.log("User joined conversation: " + conversationId);
  });
  socket.on("sendMessage", async (message) => {
    const { conversationId, senderId, content , mediaUrl, mediaType} = message;

    try {
      const savedMessage = await saveMessage(conversationId, senderId, content, mediaUrl, mediaType);
      console.log("SendMessage: ");
      console.log(savedMessage);
      io.to(conversationId).emit("newMessage", savedMessage);
    } catch (err) {
      console.error("Failed to send message");
      socket.emit("messageError", "Failed to send message");
    }
  });
  socket.on("disconnect", () => {
    console.log("User disconnected", socket.id);
  });
});
server.listen(ENV.PORT, () => {
  console.log(`Server is running on port ${ENV.PORT}`);
});