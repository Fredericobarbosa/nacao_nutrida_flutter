import { Router } from "express";
import LocalidadeService from "../services/LocalidadeService";
import LocalidadeController from "../controllers/LocalidadeController";

// Injeção de Dependências (aqui não precisamos do Prisma)
const localidadeService = new LocalidadeService();
const localidadeController = new LocalidadeController(localidadeService);

const localidadeRouter = Router();

// Endpoint para buscar estados e cidades
localidadeRouter.get(
  "/estadosCidades",
  localidadeController.getEstadosECidades
);

export default localidadeRouter;
