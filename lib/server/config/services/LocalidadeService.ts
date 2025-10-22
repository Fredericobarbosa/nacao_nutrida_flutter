import axios from "axios";

// Interfaces para tipar a resposta da API do IBGE
interface IIBGEEstado {
  id: number;
  sigla: string;
  nome: string;
}

interface IIBGECidade {
  id: number;
  nome: string;
}

// Interface para o formato final da nossa resposta
interface IEstadoCidades {
  sg_estado: string;
  cidades: string[];
}

export default class LocalidadeService {
  private ibgeApi = axios.create({
    baseURL: "https://servicodados.ibge.gov.br/api/v1/localidades",
  });

  /**
   * Busca todos os estados e suas respectivas cidades da API do IBGE.
   * Otimizado para fazer as chamadas de cidades em paralelo.
   */
  public async buscarEstadosECidades(): Promise<IEstadoCidades[]> {
    try {
      const estadosResponse = await this.ibgeApi.get<IIBGEEstado[]>(
        "/estados?orderBy=nome"
      );
      const estados = estadosResponse.data;

      const promessasCidades = estados.map((estado) =>
        this.ibgeApi.get<IIBGECidade[]>(`/estados/${estado.sigla}/municipios`)
      );

      const respostasCidades = await Promise.all(promessasCidades);

      const estadosCidades = estados.map((estado, index) => {
        const cidades = respostasCidades[index].data.map(
          (cidade) => cidade.nome
        );
        return {
          sg_estado: estado.sigla,
          cidades: cidades,
        };
      });

      return estadosCidades;
    } catch (error) {
      console.error("Erro ao buscar dados do IBGE:", error);
      throw new Error("Não foi possível buscar os dados de estados e cidades.");
    }
  }
}
