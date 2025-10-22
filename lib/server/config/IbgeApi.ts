import axios from 'axios';

const sslRootCAs = require('ssl-root-cas')

const https = require('https')


sslRootCAs.inject()

interface ICidade {
    "municipio-id": number,
    "municipio-nome": string,
    "microrregiao-id": number,
    "microrregiao-nome": string,
    "mesorregiao-id": number,
    "mesorregiao-nome": string,
    "regiao-imediata-id": number,
    "regiao-imediata-nome": string,
    "regiao-intermediaria-id": number,
    "regiao-intermediaria-nome": string,
    "UF-id": number,
    "UF-sigla": string,
    "UF-nome": string,
    "regiao-id": number,
    "regiao-sigla": string,
    "regiao-nome": string,
}

interface IEstado {
    "UF-id": number,
    "UF-sigla": string,
    "UF-nome": string,
    "regiao-id": number,
    "regiao-sigla": string,
    "regiao-nome": string,
}

interface EstadoCidades {
    sg_estado: string;
    cidades: string[];
}

export async function fetchEstadosCidades(): Promise<EstadoCidades[] | null> {
    try {
        const estadosResponse = await axios.get<IEstado[]>('https://servicodados.ibge.gov.br/api/v1/localidades/estados?view=nivelado&orderBy=nome', {
            httpsAgent: new https.Agent({
              rejectUnauthorized: false
            })
          });

        const estados = estadosResponse.data;

        const estadosCidades: EstadoCidades[] = [];

        for (const state of estados) {
            const stateAbbreviation = state['UF-sigla'];
            const citiesResponse = await axios.get<ICidade[]>(`https://servicodados.ibge.gov.br/api/v1/localidades/estados/${stateAbbreviation}/municipios?view=nivelado&orderBy=nome`, {
                httpsAgent: new https.Agent({
                  rejectUnauthorized: false
                })
              });
            const cities = citiesResponse.data;

            estadosCidades.push({
                sg_estado: state['UF-sigla'],
                cidades: cities.map(city => city['municipio-nome'])
            });
        }

        return estadosCidades;
    } catch (error) {
        console.error('Erro ao buscar estados e cidades:', error);
        return null;
    }
}
