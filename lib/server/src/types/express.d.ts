import { usuario } from "@prisma/client";

declare global {
  namespace Express {
    export interface Request {
      user?: Omit<usuario, "cd_senha_usuario">;
    }
  }
}
