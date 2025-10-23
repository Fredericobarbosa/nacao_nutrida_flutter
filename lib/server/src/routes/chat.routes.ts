import { PrismaClient } from "@prisma/client";
import ChatController from "../controllers/ChatController";
import ChatService from "../services/ChatService";
import { Router } from "express";
import authMiddleware from "../middlewares/authMiddleware";

const prisma = new PrismaClient();
const chatService = new ChatService(prisma);
const chatController = new ChatController(chatService);

const chatRouter = Router();

chatRouter.get(
  "/chat/conversations",
  authMiddleware,
  chatController.listarConversas
);
chatRouter.post(
  "/chat/conversations",
  authMiddleware,
  chatController.criarConversa
);
chatRouter.get(
  "/chat/messages",
  authMiddleware,
  chatController.listarMensagens
);
chatRouter.post(
  "/chat/messages",
  authMiddleware,
  chatController.enviarMensagem
);
chatRouter.delete(
  "/chat/conversations/:id",
  authMiddleware,
  chatController.excluirConversa
);

export default chatRouter;
