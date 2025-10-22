import { Request, Response } from "express";
import AlimentoService from "../services/AlimentoService";

export default class AlimentoController {
  private alimentoService: AlimentoService;

  constructor(alimentoService: AlimentoService) {
    this.alimentoService = alimentoService;
    this.buscarAlimentosPorTipo = this.buscarAlimentosPorTipo.bind(this);
    this.buscarTodosAlimentosDoados =
      this.buscarTodosAlimentosDoados.bind(this);
  }

  async buscarTodosAlimentosDoados(
    req: Request,
    res: Response
  ): Promise<Response> {
    try {
      const alimentosDoados =
        await this.alimentoService.buscarTodosAlimentosDoados();
      return res.status(200).json(alimentosDoados);
    } catch (error: any) {
      console.error("Erro ao buscar alimentos doados:", error);
      return res
        .status(500)
        .json({ message: "Erro ao buscar alimentos doados" });
    }
  }

  async buscarAlimentosPorTipo(req: Request, res: Response): Promise<Response> {
    try {
      const alimentosPorTipo =
        await this.alimentoService.buscarAlimentosPorTipo();
      return res.status(200).json(alimentosPorTipo);
    } catch (error: any) {
      console.error("Erro ao buscar alimentos por tipo:", error);
      return res
        .status(500)
        .json({ message: "Erro ao buscar alimentos por tipo" });
    }
  }
}
