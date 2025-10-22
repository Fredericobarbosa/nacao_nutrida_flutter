import { PrismaClient } from "@prisma/client";

export default class AlimentoService {
  prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  async buscarTodosAlimentosDoados() {
    const alimentosDoados = await this.prisma.alimento_doacao.findMany();
    return alimentosDoados;
  }

  // Função para buscar todos os alimentos agrupados por tipo
  async buscarAlimentosPorTipo() {
    const query = await this.prisma.alimento.findMany({
      select: {
        cd_tipo_alimento: true,
        nm_tipo_alimento: true,
        nm_alimento: true,
        sg_medida_alimento: true,
        id: true,
      },
      orderBy: {
        cd_tipo_alimento: "asc", // Ordena pelo tipo de alimento
      },
    });

    // Agrupa os alimentos pelo tipo
    const groupedResult = query.reduce((acc: any, item: any) => {
      const tipoAlimentoKey = item.cd_tipo_alimento;
      const tipoAlimentoNome = item.nm_tipo_alimento;

      if (!acc[tipoAlimentoKey]) {
        acc[tipoAlimentoKey] = {
          cd_tipo_alimento: tipoAlimentoKey,
          nm_tipo_alimento: tipoAlimentoNome,
          alimentos: [],
        };
      }

      acc[tipoAlimentoKey].alimentos.push({
        nm_alimento: item.nm_alimento,
        sg_medida_alimento: item.sg_medida_alimento,
        id: item.id,
      });

      return acc;
    }, {});

    // Converte o resultado em um array
    const result = Object.values(groupedResult);

    return result;
  }
}
