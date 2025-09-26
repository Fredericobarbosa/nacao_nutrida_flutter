import 'package:flutter/material.dart';
import '../models/campaign.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({super.key});

  List<Campaign> _getCampanhasExemplo() {
    return [
      Campaign(
        id: 'camp-001',
        title: 'Almoço na Creche Arco-Íris',
        description:
            'Campanha para arrecadar alimentos básicos para as crianças da creche Arco-Íris, localizada no bairro Vila Nova.',
        status: 'ativa',
        metaAlimentos: {
          'Arroz': 50,
          'Feijão': 30,
          'Óleo': 10,
          'Açúcar': 20,
          'Macarrão': 25,
        },
        alimentosArrecadados: {
          'Arroz': 35,
          'Feijão': 20,
          'Óleo': 8,
          'Açúcar': 15,
          'Macarrão': 15,
        },
        tiposAlimento: ['Arroz', 'Feijão', 'Óleo', 'Açúcar', 'Macarrão'],
        responsavel: 'Maria Silva',
        dataInicio: DateTime(2024, 1, 15),
        dataFim: DateTime(2024, 3, 15),
        endereco: 'Rua das Flores, 123 - Vila Nova',
      ),
      Campaign(
        id: 'camp-002',
        title: 'Cesta Básica Família Esperança',
        description:
            'Ajude famílias carentes da comunidade Esperança com cestas básicas completas.',
        status: 'ativa',
        metaAlimentos: {
          'Arroz': 40,
          'Feijão': 25,
          'Farinha': 15,
          'Leite': 20,
          'Biscoito': 10,
        },
        alimentosArrecadados: {
          'Arroz': 28,
          'Feijão': 18,
          'Farinha': 12,
          'Leite': 15,
          'Biscoito': 8,
        },
        tiposAlimento: ['Arroz', 'Feijão', 'Farinha', 'Leite', 'Biscoito'],
        responsavel: 'João Santos',
        dataInicio: DateTime(2024, 1, 20),
        dataFim: DateTime(2024, 2, 20),
        endereco: 'Comunidade Esperança - Setor Norte',
      ),
      Campaign(
        id: 'camp-003',
        title: 'Sopão Solidário',
        description:
            'Ingredientes para preparo de sopas nutritivas distribuídas às quintas-feiras na praça central.',
        status: 'ativa',
        metaAlimentos: {
          'Legumes': 30,
          'Verduras': 20,
          'Carne': 25,
          'Temperos': 5,
        },
        alimentosArrecadados: {
          'Legumes': 30,
          'Verduras': 20,
          'Carne': 25,
          'Temperos': 5,
        },
        tiposAlimento: ['Legumes', 'Verduras', 'Carne', 'Temperos'],
        responsavel: 'Ana Costa',
        dataInicio: DateTime(2024, 1, 10),
        dataFim: DateTime(2024, 4, 10),
        endereco: 'Praça Central - Centro',
      ),
      Campaign(
        id: 'camp-004',
        title: 'Merenda Escola Municipal',
        description:
            'Complemento alimentar para a merenda escolar da Escola Municipal Dom Pedro.',
        status: 'pausada',
        metaAlimentos: {'Frutas': 35, 'Iogurte': 20, 'Pão': 15, 'Suco': 10},
        alimentosArrecadados: {'Frutas': 12, 'Iogurte': 8, 'Pão': 5, 'Suco': 3},
        tiposAlimento: ['Frutas', 'Iogurte', 'Pão', 'Suco'],
        responsavel: 'Carlos Oliveira',
        dataInicio: DateTime(2024, 1, 5),
        dataFim: DateTime(2024, 5, 5),
        endereco: 'Escola Municipal Dom Pedro - Bairro Jardim',
      ),
      Campaign(
        id: 'camp-005',
        title: 'Natal Solidário 2024',
        description:
            'Campanha especial de Natal para distribuição de cestas básicas e brinquedos.',
        status: 'concluida',
        metaAlimentos: {
          'Panetone': 50,
          'Frutas': 30,
          'Arroz': 40,
          'Feijão': 25,
          'Doces': 15,
        },
        alimentosArrecadados: {
          'Panetone': 60,
          'Frutas': 35,
          'Arroz': 45,
          'Feijão': 30,
          'Doces': 20,
        },
        tiposAlimento: ['Panetone', 'Frutas', 'Arroz', 'Feijão', 'Doces'],
        responsavel: 'Associação Beneficente',
        dataInicio: DateTime(2023, 11, 1),
        dataFim: DateTime(2023, 12, 25),
        endereco: 'Centro Comunitário - Bairro Central',
      ),
      Campaign(
        id: 'camp-006',
        title: 'Café da Manhã Casa de Apoio',
        description:
            'Alimentos para o café da manhã dos moradores da Casa de Apoio São Francisco.',
        status: 'ativa',
        metaAlimentos: {
          'Pão': 20,
          'Leite': 15,
          'Café': 8,
          'Açúcar': 10,
          'Margarina': 5,
        },
        alimentosArrecadados: {
          'Pão': 10,
          'Leite': 8,
          'Café': 4,
          'Açúcar': 5,
          'Margarina': 2,
        },
        tiposAlimento: ['Pão', 'Leite', 'Café', 'Açúcar', 'Margarina'],
        responsavel: 'Padre Francisco',
        dataInicio: DateTime(2024, 1, 25),
        dataFim: DateTime(2024, 6, 25),
        endereco: 'Casa de Apoio São Francisco - Vila Operária',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final campanhas = _getCampanhasExemplo();
    return Column(
      children: [
        // Hero Banner
        Card(
          color: const Color(0xFF769fcd),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inspire o estado e a cidade',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encontre organizações que precisam de sua ajuda',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/descobrir');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFffc436),
                    foregroundColor: const Color(0xFF191929),
                  ),
                  child: const Text('Começar agora'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Recent Requests
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campanhas Existentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191929),
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: campanhas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final campanha = campanhas[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width < 400
                                ? 60
                                : 100,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _getCorStatus(
                                campanha.status,
                              ).withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              Icons.campaign,
                              size: 32,
                              color: _getCorStatus(campanha.status),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campanha.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF191929),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Alimentos • ${campanha.tiposAlimento.take(3).join(' • ')}${campanha.tiposAlimento.length > 3 ? ' • ...' : ''}',
                                style: const TextStyle(
                                  color: Color(0xFF8d8d8d),
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    size: 12,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${campanha.percentualArrecadado.toStringAsFixed(1)}% arrecadado',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCorStatus(
                                        campanha.status,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      campanha.statusFormatado,
                                      style: TextStyle(
                                        color: _getCorStatus(campanha.status),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/detalhes-campanha',
                                    arguments: campanha,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF027ba1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Ver detalhes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPaginationButton('1'),
                const SizedBox(width: 8),
                _buildPaginationButton('2'),
                const SizedBox(width: 8),
                _buildPaginationButton('3'),
                const SizedBox(width: 8),
                const Text('...', style: TextStyle(color: Color(0xFF8d8d8d))),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/descobrir');
                  },
                  child: const Text('Seguinte →'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
      ),
      child: Text(text),
    );
  }

  Color _getCorStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ativa':
        return Colors.green;
      case 'concluida':
        return Colors.blue;
      case 'pausada':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
