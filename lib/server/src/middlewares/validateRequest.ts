// src/middlewares/validateRequest.ts
import { Request, Response, NextFunction } from "express";
import { z } from "zod/v3";

const validateRequest =
  (schema: z.Schema) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Usamos parse em vez de parseAsync se não houver transformações assíncronas
      req.body = schema.parse(req.body);
      return next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({
          message: "Erro de validação",
          errors: error.flatten().fieldErrors,
        });
      }
      return res.status(500).json({ message: "Erro interno do servidor" });
    }
  };

export default validateRequest;
