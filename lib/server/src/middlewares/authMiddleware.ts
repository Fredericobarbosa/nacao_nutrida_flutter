import { PrismaClient } from "@prisma/client";
import { Request, Response, NextFunction } from "express";
import * as jwt from "jsonwebtoken";

const prisma = new PrismaClient();

interface TokenPayload {
  id: string;
  email: string;
  is_admin: number;
  iat: number;
  exp: number;
}

const authMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ message: "Token de autenticação ausente" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const JWT_SECRET = process.env.JWT_SECRET as string;
    const decoded = jwt.verify(token, JWT_SECRET) as TokenPayload;

    const user = await prisma.usuario.findUnique({
      where: { id: decoded.id },
    });

    if (!user) {
      return res.status(401).json({ message: "Usuário não encontrado" });
    }

    const { cd_senha_usuario, ...usuarioSemSenha } = user;

    req.user = usuarioSemSenha;

    next();
  } catch (error) {
    console.error("Erro ao verificar token:", error);
    return res.status(401).json({ message: "Token Inválido" });
  }
};

export default authMiddleware;
