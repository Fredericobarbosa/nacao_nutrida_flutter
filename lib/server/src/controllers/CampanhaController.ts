import { Request, Response } from "express";
import CampanhaService from "../services/CampanhaService";

export default class CampanhaController {
  private campanhaService: CampanhaService;

  constructor(campanhaService: CampanhaService) {
    this.campanhaService = campanhaService;
    this.create = this.create.bind(this);
    this.getAll = this.getAll.bind(this);
    this.getById = this.getById.bind(this);
    this.findByLocation = this.findByLocation.bind(this);
  }

  public async create(req: Request, res: Response): Promise<Response> {
    try {
      const novaCampanha = await this.campanhaService.criar(req.body);
      return res.status(201).json(novaCampanha);
    } catch (error: any) {
      console.error("Erro ao criar campanha:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao criar campanha." });
    }
  }

  public async getAll(req: Request, res: Response): Promise<Response> {
    try {
      const campanhas = await this.campanhaService.listarAtivas();
      return res.status(200).json(campanhas);
    } catch (error: any) {
      console.error("Erro ao listar campanhas:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao listar campanhas." });
    }
  }

  public async getById(req: Request, res: Response): Promise<Response> {
    try {
      const { id } = req.params;
      const campanha = await this.campanhaService.buscarPorId(id);
      return res.status(200).json(campanha);
    } catch (error: any) {
      if (error.message.includes("Campanha não encontrada")) {
        return res.status(404).json({ message: error.message });
      }
      console.error("Erro ao buscar campanha por ID:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao buscar campanha." });
    }
  }

  public async findByLocation(req: Request, res: Response): Promise<Response> {
    try {
      const { sg_estado_campanha, nm_cidade_campanha } = req.query;

      if (!sg_estado_campanha || !nm_cidade_campanha) {
        return res.status(400).json({
          message: "Estado e cidade são obrigatórios para buscar campanhas",
        });
      }

      const campanhas = await this.campanhaService.buscarPorLocal(
        sg_estado_campanha as string,
        nm_cidade_campanha as string
      );
      return res.status(200).json(campanhas);
    } catch (error: any) {
      if (error.message.includes("Campanha não encontrada")) {
        return res.status(404).json({ message: error.message });
      }
      console.error("Erro ao buscar campanha por local:", error);
      return res
        .status(500)
        .json({ message: "Erro interno ao buscar campanha." });
    }
  }
}
