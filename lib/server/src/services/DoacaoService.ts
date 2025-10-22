import { PrismaClient } from "@prisma/client";
import { RegistrarDoacaoDTO } from "../schemas/doacao.schema";

export default class DoacaoService {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  /**
   * Registra uma nova doação de múltiplos alimentos para uma campanha.
   */
  public async registrarDoacao(dados: RegistrarDoacaoDTO) {
    const { infos_doacao, alimentos_doacao } = dados;

    const dadosParaInserir = alimentos_doacao.map((alimento) => ({
      usuario_id: infos_doacao.usuario_doacao,
      campanha_id: infos_doacao.cd_campanha_doacao,
      alimento_id: alimento.alimento_id,
      qt_alimento_doado: alimento.qt_alimento_doacao,
    }));

    const resultado = await this.prisma.alimento_doacao.createMany({
      data: dadosParaInserir,
    });

    return resultado;
  }
}
