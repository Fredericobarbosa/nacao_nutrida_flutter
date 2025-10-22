import { PrismaClient } from "@prisma/client";
import AlimentoService from "../services/AlimentoService";
import { Router } from "express";
import AlimentoController from "../controllers/AlimentoController";
import authMiddleware from "../middlewares/authMiddleware";

const prisma = new PrismaClient();
const alimentoService = new AlimentoService(prisma);
const alimentoController = new AlimentoController(alimentoService);

const alimentoRouter = Router();

alimentoRouter.get(
  "/alimentos",
  authMiddleware,
  alimentoController.buscarAlimentosPorTipo
);

alimentoRouter.get(
  "/alimentosDoados",
  authMiddleware,
  alimentoController.buscarTodosAlimentosDoados
);

export default alimentoRouter;
