import { PrismaClient, campanha as CampanhaModel } from "@prisma/client";
import { CriarCampanhaDTO } from "../schemas/campanha.schema";

export default class CampanhaService {
  private prisma: PrismaClient;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  /**
   * Cria uma nova campanha e seus itens de alimento associados.
   */
  public async criar(dados: CriarCampanhaDTO) {
    const { infos_campanha, alimentos_campanha } = dados;

    return this.prisma.$transaction(async (prisma) => {
      const novaCampanha = await prisma.campanha.create({
        data: infos_campanha,
      });

      const alimentosParaCriar = alimentos_campanha.map((alimento) => ({
        campanha_id: novaCampanha.id,
        alimento_id: alimento.id,
        qt_alimento_meta: alimento.qt_alimento_meta,
      }));

      await prisma.alimento_campanha.createMany({
        data: alimentosParaCriar,
      });

      return novaCampanha;
    });
  }

  /**
   * Busca todas as campanhas ativas e agrega dados relacionados.
   */
  public async listarAtivas() {
    const campanhas = await this.prisma.campanha.findMany({
      where: {
        dt_encerramento_campanha: { gt: new Date() },
        fg_campanha_ativa: true,
      },
      orderBy: {
        dt_encerramento_campanha: "desc",
      },
    });

    return Promise.all(
      campanhas.map((campanha) => this.agregarDados(campanha))
    );
  }

  /**
   * Busca uma campanha ativa específica pelo ID e agrega dados relacionados.
   */
  public async buscarPorId(id: string) {
    const campanha = await this.prisma.campanha.findFirst({
      where: {
        id,
        dt_encerramento_campanha: { gt: new Date() },
        fg_campanha_ativa: true,
      },
    });

    if (!campanha) {
      throw new Error("Campanha não encontrada ou inativa.");
    }

    return this.agregarDados(campanha);
  }

  /**
   * Busca todas as campanhas ativas do usuário logado e agrega dados relacionados.
   */
  public async buscarPorUserId(userId: string) {
    const campanhas = await this.prisma.campanha.findMany({
      where: {
        usuario_id: userId,
        dt_encerramento_campanha: { gt: new Date() },
        fg_campanha_ativa: true,
      },
      orderBy: {
        dt_encerramento_campanha: "desc",
      },
    });

    if (campanhas.length === 0) return [];

    return Promise.all(
      campanhas.map((campanha) => this.agregarDados(campanha))
    );
  }

  /**
   * Permite ao usuario desativar uma campanha que ele criou, dessa forma não aparece mais nas listagens.
   */
  public async desativarCampanha(id: string, userId: string) {
    const updateResult = await this.prisma.campanha.updateMany({
      where: {
        id: id,
        usuario_id: userId,
      },
      data: { fg_campanha_ativa: false },
    });

    if (updateResult.count === 0) {
      throw new Error("Campanha nao encontrada.");
    }
  }

  /**
   * Busca todas as doações de uma campanha especifica.
   */
  public async buscarDoacoesPorCampanhaId(campanhaId: string) {
    const doacoes = await this.prisma.alimento_doacao.findMany({
      where: {
        campanha_id: campanhaId,
      },
    });

    if (doacoes.length === 0) {
      return [];
    }

    const usuarioIds = [...new Set(doacoes.map((d) => d.usuario_id))];
    const alimentoIds = [...new Set(doacoes.map((d) => d.alimento_id))];
    const [usuarios, alimentos] = await Promise.all([
      this.prisma.usuario.findMany({
        where: {
          id: { in: usuarioIds },
        },
        select: {
          id: true,
          nm_usuario: true,
          cd_foto_usuario: true,
          nm_cidade_usuario: true,
          sg_estado_usuario: true,
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
    const usuarioMap = new Map(usuarios.map((u) => [u.id, u]));
    const alimentoMap = new Map(alimentos.map((a) => [a.id, a]));
    const resultadoFinal = doacoes
      .map((doacao) => {
        const usuario = usuarioMap.get(doacao.usuario_id);
        const alimento = alimentoMap.get(doacao.alimento_id);

        if (!usuario || !alimento) {
          return null;
        }

        return {
          id_doacao: doacao.id,
          quantidade_doada: doacao.qt_alimento_doado,
          doador: {
            nome: usuario.nm_usuario,
            foto: usuario.cd_foto_usuario,
            cidade: usuario.nm_cidade_usuario,
            estado: usuario.sg_estado_usuario,
          },
          alimento: {
            nome: alimento.nm_alimento,
          },
        };
      })
      .filter(Boolean); // Remove quaisquer entradas nulas (dados órfãos)
    return resultadoFinal;
  }

  /**
   * Busca todas as campanhas ativas de um local (estado e cidade) e agrega dados relacionados.
   */
  public async buscarPorLocal(
    sg_estado_campanha: string,
    nm_cidade_campanha: string
  ) {
    const campanhas = await this.prisma.campanha.findMany({
      where: {
        sg_estado_campanha,
        nm_cidade_campanha,
        dt_encerramento_campanha: { gt: new Date() },
        fg_campanha_ativa: true,
      },
      orderBy: {
        dt_encerramento_campanha: "desc",
      },
    });

    return Promise.all(
      campanhas.map((campanha) => this.agregarDados(campanha))
    );
  }

  /**
   * Método privado para agregar informações detalhadas a uma campanha.
   * Isso evita repetição de código entre `listarAtivas` e `buscarPorId`.
   */
  private async agregarDados(campanha: CampanhaModel) {
    const now = new Date();

    // 1. Busca dados relacionados em paralelo
    const [usuario, alimentosCampanha, doacoes] = await Promise.all([
      this.prisma.usuario.findUnique({
        where: { id: campanha.usuario_id },
        select: { nm_usuario: true, cd_foto_usuario: true },
      }),
      // Busca os itens da campanha
      this.prisma.alimento_campanha.findMany({
        where: { campanha_id: campanha.id },
      }),
      // Agrupa as doações para somar as quantidades por alimento
      this.prisma.alimento_doacao.groupBy({
        by: ["alimento_id"],
        where: { campanha_id: campanha.id },
        _sum: { qt_alimento_doado: true },
      }),
    ]);

    const diasRestantes = Math.ceil(
      (new Date(campanha.dt_encerramento_campanha).getTime() - now.getTime()) /
        (1000 * 60 * 60 * 24)
    );

    if (alimentosCampanha.length === 0) {
      return {
        ...campanha,
        nm_usuario: usuario?.nm_usuario || "Usuário não encontrado",
        cd_foto_usuario: usuario?.cd_foto_usuario || "default.png",
        dias_restantes: diasRestantes > 0 ? diasRestantes : 0,
      };
    }

    // 2. Busca os detalhes dos alimentos baseados nos IDs encontrados
    const alimentosIds = alimentosCampanha.map((ac) => ac.alimento_id);
    const detalhesAlimentos = await this.prisma.alimento.findMany({
      where: { id: { in: alimentosIds } },
    });

    // 3. Organiza os dados para fácil acesso
    const mapaDetalhesAlimentos = new Map(
      detalhesAlimentos.map((al) => [al.id, al])
    );
    const mapaDoacoes: { [key: string]: number } = {};
    doacoes.forEach((d) => {
      if (d._sum.qt_alimento_doado) {
        mapaDoacoes[d.alimento_id] = d._sum.qt_alimento_doado;
      }
    });

    // 4. Combina todas as informações
    const alimentosComDetalhes = alimentosCampanha.map((ac) => {
      const detalhe = mapaDetalhesAlimentos.get(ac.alimento_id);
      return {
        alimento_id: ac.alimento_id,
        nm_alimento: detalhe?.nm_alimento || "Alimento não encontrado",
        sg_medida_alimento: detalhe?.sg_medida_alimento || "N/A",
        qt_alimento_meta: ac.qt_alimento_meta,
        qt_alimento_doado: mapaDoacoes[ac.alimento_id] || 0,
      };
    });

    const qt_total_campanha = alimentosComDetalhes.reduce(
      (sum, al) => sum + al.qt_alimento_meta,
      0
    );
    const qt_doacoes_campanha = alimentosComDetalhes.reduce(
      (sum, al) => sum + al.qt_alimento_doado,
      0
    );

    return {
      ...campanha,
      nm_usuario: usuario?.nm_usuario || "Usuário não encontrado",
      cd_foto_usuario: usuario?.cd_foto_usuario || "default.png",
      dias_restantes: diasRestantes > 0 ? diasRestantes : 0,
      qt_total_campanha,
      qt_doacoes_campanha,
      alimentos: alimentosComDetalhes,
    };
  }
}
