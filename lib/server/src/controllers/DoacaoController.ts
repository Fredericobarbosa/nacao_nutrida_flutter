import { Request, Response } from "express";
import DoacaoService from "../services/DoacaoService";

export default class DoacaoController {
  private doacaoService: DoacaoService;

  constructor(doacaoService: DoacaoService) {
    this.doacaoService = doacaoService;
    this.create = this.create.bind(this);
    this.findByUserId = this.findByUserId.bind(this);
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

  public async findByUserId(req: Request, res: Response): Promise<Response> {
    const usuarioLogado = req.user;

    if (!usuarioLogado) {
      return res.status(401).json({ message: "Usuário não autenticado" });
    }

    try {
      const doacoes = await this.doacaoService.buscarPorUserId(
        usuarioLogado.id
      );
      return res.status(200).json(doacoes);
    } catch (error: any) {
      console.error("Erro ao buscar doações por usuário:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao buscar doações." });
    }
  }
}
