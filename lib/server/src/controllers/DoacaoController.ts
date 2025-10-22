import { Request, Response } from "express";
import DoacaoService from "../services/DoacaoService";

export default class DoacaoController {
  private doacaoService: DoacaoService;

  constructor(doacaoService: DoacaoService) {
    this.doacaoService = doacaoService;
    this.create = this.create.bind(this);
  }

  public async create(req: Request, res: Response): Promise<Response> {
    try {
      const resultado = await this.doacaoService.registrarDoacao(req.body);
      return res.status(201).json({ insertedCount: resultado.count });
    } catch (error: any) {
      console.error("Erro ao processar doação:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao processar doação." });
    }
  }
}
