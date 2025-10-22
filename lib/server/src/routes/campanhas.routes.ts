import { Router } from "express";
import { PrismaClient } from "@prisma/client";
import validateRequest from "../middlewares/validateRequest";
import { criarCampanhaSchema } from "../schemas/campanha.schema";
import CampanhaService from "../services/CampanhaService";
import CampanhaController from "../controllers/CampanhaController";
import authMiddleware from "../middlewares/authMiddleware";

const prisma = new PrismaClient();
const campanhaService = new CampanhaService(prisma);
const campanhaController = new CampanhaController(campanhaService);

const campanhaRouter = Router();

campanhaRouter.post(
  "/campanhas",
  authMiddleware,
  validateRequest(criarCampanhaSchema),
  campanhaController.create
);

campanhaRouter.get("/campanhas", campanhaController.getAll);

campanhaRouter.get("/campanhas/buscar", campanhaController.findByLocation);

campanhaRouter.get("/campanhas/:id", campanhaController.getById);

export default campanhaRouter;
