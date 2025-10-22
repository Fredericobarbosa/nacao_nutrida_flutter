import { PrismaClient } from "@prisma/client";
import DoacaoService from "../services/DoacaoService";
import DoacaoController from "../controllers/DoacaoController";
import { Router } from "express";
import authMiddleware from "../middlewares/authMiddleware";

const prisma = new PrismaClient();
const doacaoService = new DoacaoService(prisma);
const doacaoController = new DoacaoController(doacaoService);

const doacaoRouter = Router();

doacaoRouter.post("/doacoes", authMiddleware, doacaoController.create);

export default doacaoRouter;
