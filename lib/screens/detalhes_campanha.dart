import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/api.dart';
import '../models/campaign.dart';
import '../services/api_service.dart';

class DetalhesCampanhaPage extends StatefulWidget {
  final String campanhaId;

  const DetalhesCampanhaPage({super.key, required this.campanhaId});

  @override
  State<DetalhesCampanhaPage> createState() => _DetalhesCampanhaPageState();
}

class _DetalhesCampanhaPageState extends State<DetalhesCampanhaPage> {
  late final ApiService _api;
  Campaign? _campanha;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = ApiService(baseUrl: ApiConfig.baseUrl);
    _fetchCampanha();
  }

  Future<void> _fetchCampanha() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final resp = await _api.get('/campanhas/${widget.campanhaId}');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _campanha = _mapToCampaign(data);
        });
      } else {
        setState(() {
          _error = 'Erro ao carregar campanha: ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Falha de rede: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Campaign _mapToCampaign(Map<String, dynamic> json) {
    final metaAlimentos = <String, int>{};
    final arrecadados = <String, int>{};

    if (json['alimentos'] is List) {
      for (final item in json['alimentos']) {
        final nome = item['nm_alimento'] ?? item['nome'] ?? 'Desconhecido';

        // Popula o mapa de Metas
        final meta = (item['qt_alimento_meta'] ?? 0) as int;
        metaAlimentos[nome] = meta;

        // Popula o mapa de Arrecadados
        final qt = (item['qt_alimento_doado'] ?? 0) as int;
        arrecadados[nome] = qt;
      }
    }

    DateTime parseDate(dynamic d) {
      if (d == null) return DateTime.now();
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    final cidade = json['nm_cidade_campanha'];
    final estado = json['sg_estado_campanha'];
    String enderecoCompleto = '';
    if (cidade != null && estado != null) {
      enderecoCompleto = '$cidade, $estado';
    } else {
      enderecoCompleto = json['ds_endereco'] ?? json['endereco'] ?? '';
    }

    final String status;
    if (json['fg_campanha_ativa'] == true) {
      status = 'ativa';
    } else if (json['fg_campanha_ativa'] == false) {
      status = 'inativa';
    } else {
      status = json['st_campanha'] ?? 'ativa'; // Fallback
    }

    final dtFimJson = json['dt_encerramento_campanha'] ?? json['dt_fim'];

    return Campaign(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['nm_titulo_campanha'] ?? json['title'] ?? 'Campanha',
      description: json['ds_acao_campanha'] ?? json['description'] ?? '',
      imageUrl: "assets/generic_nn.jpg",
      status: status,
      metaAlimentos: metaAlimentos,
      alimentosArrecadados: arrecadados,
      tiposAlimento: (json['tipos_alimento'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      responsavel:
          json['nm_usuario'] ?? json['nm_responsavel'] ?? json['responsavel'] ?? '',
      dataInicio: parseDate(json['ts_criacao_campanha'] ?? json['dt_inicio']),
      dataFim: dtFimJson != null ? parseDate(dtFimJson) : null,
      endereco: enderecoCompleto,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detalhes da Campanha',
          style: TextStyle(
            color: Color(0xFF027ba1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF027ba1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF027ba1)),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                    ],
                  ),
                )
              : _campanha == null
                  ? const Center(
                      child: Text('Nenhuma campanha encontrada'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Imagem da Campanha
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: Image.asset(
                              _campanha!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Conteúdo Principal
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status Badge
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _campanha!.status == 'ativa'
                                          ? const Color(0xFF4CAF50)
                                          : const Color(0xFFF44336),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _campanha!.status == 'ativa'
                                          ? 'Ativa'
                                          : 'Inativa',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Título
                                Text(
                                  _campanha!.title,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1976d2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Descrição
                                Text(
                                  _campanha!.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Card de Informações Principais
                                Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildInfoRow(
                                          'Responsável',
                                          _campanha!.responsavel,
                                          Icons.person,
                                        ),
                                        const Divider(height: 16),
                                        _buildInfoRow(
                                          'Localização',
                                          _campanha!.endereco,
                                          Icons.location_on,
                                        ),
                                        const Divider(height: 16),
                                        _buildInfoRow(
                                          'Data de Início',
                                          _formatDate(_campanha!.dataInicio),
                                          Icons.calendar_today,
                                        ),
                                        if (_campanha!.dataFim != null) ...[
                                          const Divider(height: 16),
                                          _buildInfoRow(
                                            'Data de Término',
                                            _formatDate(_campanha!.dataFim!),
                                            Icons.calendar_today,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Seção de Alimentos
                                if (_campanha!.metaAlimentos.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Metas de Alimentos',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1976d2),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ..._campanha!.metaAlimentos.entries
                                          .map((entry) {
                                        final alimento = entry.key;
                                        final meta = entry.value;
                                        final arrecadado = _campanha!
                                                .alimentosArrecadados[alimento] ??
                                            0;
                                        final percentual = meta > 0
                                            ? (arrecadado / meta * 100).clamp(0, 100)
                                            : 0.0;

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    alimento,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$arrecadado/$meta unidades',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: LinearProgressIndicator(
                                                  value: percentual / 100,
                                                  minHeight: 8,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    percentual >= 75
                                                        ? const Color(
                                                            0xFF4CAF50,
                                                          )
                                                        : percentual >= 50
                                                            ? const Color(
                                                                0xFFFFC107,
                                                              )
                                                            : const Color(
                                                                0xFFFF9800,
                                                              ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                const SizedBox(height: 24),
                                // Botão de Doação
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(
                                          '/doar-alimentos',
                                          arguments: _campanha,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF027ba1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Fazer Doação',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF027ba1), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}