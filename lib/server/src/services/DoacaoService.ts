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

  /**
   * Busca todas as doações do usuário logado, agregando dados relacionados e soma os alimentos doados por ele para X campanha.
   */
  public async buscarPorUserId(userId: string) {
    const doacoes = await this.prisma.alimento_doacao.findMany({
      where: {
        usuario_id: userId,
      },
    });

    if (doacoes.length === 0) {
      return [];
    }

    const campanhaIds = [...new Set(doacoes.map((d) => d.campanha_id))];
    const alimentoIds = [...new Set(doacoes.map((d) => d.alimento_id))];

    const [campanhas, alimentos] = await Promise.all([
      this.prisma.campanha.findMany({
        where: {
          id: { in: campanhaIds },
        },
        select: {
          id: true,
          nm_titulo_campanha: true,
          nm_cidade_campanha: true,
          sg_estado_campanha: true,
        },
      }),
      this.prisma.alimento.findMany({
        where: {
          id: { in: alimentoIds },
        },
        select: {
          id: true,
          nm_alimento: true,
        },
      }),
    ]);

    const campanhaMap = new Map(campanhas.map((c) => [c.id, c]));
    const alimentoMap = new Map(alimentos.map((a) => [a.id, a]));

    const aggregatedByCampanha = new Map();

    for (const doacao of doacoes) {
      const campanha = campanhaMap.get(doacao.campanha_id);
      const alimento = alimentoMap.get(doacao.alimento_id);

      if (!campanha || !alimento) {
        continue;
      }

      if (!aggregatedByCampanha.has(campanha.id)) {
        aggregatedByCampanha.set(campanha.id, {
          campanha: {
            id: campanha.id,
            nome: campanha.nm_titulo_campanha,
            cidade: campanha.nm_cidade_campanha,
            estado: campanha.sg_estado_campanha,
          },
          alimentos_map: new Map(),
        });
      }

      const campanhaAgregada = aggregatedByCampanha.get(campanha.id);

      if (!campanhaAgregada.alimentos_map.has(alimento.id)) {
        campanhaAgregada.alimentos_map.set(alimento.id, {
          alimento: {
            id: alimento.id,
            nome: alimento.nm_alimento,
          },
          quantidade: 0,
        });
      }

      const alimentoAgregado = campanhaAgregada.alimentos_map.get(alimento.id);
      alimentoAgregado.quantidade += doacao.qt_alimento_doado;
    }

    const resultadoFinal = [];

    for (const campanhaAgregada of aggregatedByCampanha.values()) {
      resultadoFinal.push({
        campanha: campanhaAgregada.campanha,
        alimentos_doados: Array.from(campanhaAgregada.alimentos_map.values()),
      });
    }

    return resultadoFinal;
  }
}
