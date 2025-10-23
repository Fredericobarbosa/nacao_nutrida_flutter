import { Router } from "express";
import { PrismaClient } from "@prisma/client";
import UsuarioService from "../services/UsuarioService";
import UsuarioController from "../controllers/UsuarioController";
import validateRequest from "../middlewares/validateRequest";
import {
  atualizarUsuarioSchema,
  criarUsuarioSchema,
  loginUsuarioSchema,
} from "../schemas/usuario.schema";
import authMiddleware from "../middlewares/authMiddleware";

const prisma = new PrismaClient();
const usuarioService = new UsuarioService(prisma);
const usuarioController = new UsuarioController(usuarioService);

const usuarioRouter = Router();

usuarioRouter.get(
  "/usuario/nome/:id",
  authMiddleware,
  usuarioController.getUserNameById
);

usuarioRouter.patch(
  "/usuario/:id",
  authMiddleware,
  validateRequest(atualizarUsuarioSchema),
  usuarioController.updateUser
);

usuarioRouter.post(
  "/usuarioCadastro",
  validateRequest(criarUsuarioSchema),
  usuarioController.create
);

usuarioRouter.post(
  "/usuarioLogin",
  validateRequest(loginUsuarioSchema),
  usuarioController.login
);

usuarioRouter.get("/usuarios", authMiddleware, usuarioController.getUsers);

usuarioRouter.get("/perfil", authMiddleware, usuarioController.getProfile);

export default usuarioRouter;
