import { Request, Response } from "express";
import LocalidadeService from "../services/LocalidadeService";

export default class LocalidadeController {
  private localidadeService: LocalidadeService;

  constructor(localidadeService: LocalidadeService) {
    this.localidadeService = localidadeService;
    this.getEstadosECidades = this.getEstadosECidades.bind(this);
  }

  public async getEstadosECidades(
    req: Request,
    res: Response
  ): Promise<Response> {
    try {
      const dados = await this.localidadeService.buscarEstadosECidades();
      return res.status(200).json(dados);
    } catch (error: any) {
      return res.status(503).json({ message: error.message }); // 503 Service Unavailable
    }
  }
}
