import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../services/analytics_service.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import '../models/campaign.dart';
import 'dart:convert';

class DescobrirPage extends StatefulWidget {
  const DescobrirPage({super.key});

  @override
  State<DescobrirPage> createState() => _DescobrirPageState();
}

class _DescobrirPageState extends State<DescobrirPage> {
  bool _loadingApi = false;
  String? _error;
  List<Campaign> _campanhas = [];

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('Descobrir');
    // Buscar campanhas do backend quando a página carregar
    _fetchCampanhas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mantemos o comportamento de buscar campanhas caso não tenham sido carregadas
    if (_campanhas.isEmpty && !_loadingApi) {
      _fetchCampanhas();
    }
  }

  Future<void> _fetchCampanhas() async {
    setState(() {
      _loadingApi = true;
      _error = null;
    });

    final api = ApiService(baseUrl: ApiConfig.baseUrlAndroid);
    try {
      final resp = await api.get('/campanhas');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        final list = data.map((e) => _mapToCampaign(e)).toList();
        setState(() {
          _campanhas = List<Campaign>.from(list);
        });
      } else {
        setState(() {
          _error = 'Erro ao buscar campanhas: ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao conectar com backend: $e';
      });
    } finally {
      setState(() {
        _loadingApi = false;
      });
    }
  }

  Campaign _mapToCampaign(dynamic json) {
    // json expected to be aggregated campanha object from backend
    final id = json['id'] as String? ?? '';
    final title =
        json['nm_titulo_campanha'] as String? ?? json['title'] as String? ?? '';
    final description = json['ds_acao_campanha'] as String? ?? '';
    final imageUrl = json['cd_imagem_campanha'] as String?;
    final status = (json['fg_campanha_ativa'] == true) ? 'ativa' : 'pausada';
    final alimentos = json['alimentos'] as List<dynamic>? ?? [];
    final Map<String, int> metaAlimentos = {};
    final Map<String, int> alimentosArrecadados = {};
    final List<String> tiposAlimento = [];
    for (final a in alimentos) {
      final nome = a['nm_alimento'] as String? ?? 'desconhecido';
      final meta = (a['qt_alimento_meta'] as num?)?.toInt() ?? 0;
      final doado = (a['qt_alimento_doado'] as num?)?.toInt() ?? 0;
      metaAlimentos[nome] = meta;
      alimentosArrecadados[nome] = doado;
      tiposAlimento.add(nome);
    }

    final responsavel = json['nm_usuario'] as String? ?? '';
    DateTime dataInicio;
    try {
      dataInicio = DateTime.parse(
        json['ts_criacao_campanha'] ?? json['ts_criacao_campanha'] as String,
      );
    } catch (_) {
      dataInicio = DateTime.now();
    }
    DateTime? dataFim;
    try {
      final df = json['dt_encerramento_campanha'] as String?;
      if (df != null) dataFim = DateTime.parse(df);
    } catch (_) {
      dataFim = null;
    }

    final endereco =
        '${json['nm_cidade_campanha'] ?? ''} - ${json['sg_estado_campanha'] ?? ''}';

    return Campaign(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      status: status,
      metaAlimentos: metaAlimentos,
      alimentosArrecadados: alimentosArrecadados,
      tiposAlimento: tiposAlimento,
      responsavel: responsavel,
      dataInicio: dataInicio,
      dataFim: dataFim,
      endereco: endereco,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70, // mesma altura do header
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF027ba1),
                      ),
                      onPressed: () {
                        AnalyticsService().trackButtonClick(
                          'Voltar',
                          'Descobrir',
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Header(
                    leftText: '',
                    rightText: 'Não tem conta?',
                    rightButtonText: 'Cadastre-se',
                    onRightButtonPressed: () {
                      Navigator.of(context).pushNamed('/cadastro-usuario');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _loadingApi
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : _campanhas.isEmpty
                  ? const Center(child: Text('Nenhuma campanha encontrada'))
                  : Column(
                      children: _campanhas
                          .map(
                            (campanha) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/detalhes-campanha',
                                  arguments: campanha,
                                );
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 0,
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  400
                                              ? 60
                                              : 100,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.grey.withAlpha(30),
                                          ),
                                          child: Icon(
                                            Icons.campaign,
                                            size: 32,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              campanha.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF191929),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Alimentos • ${campanha.tiposAlimento.take(3).join(' • ')}',
                                              style: const TextStyle(
                                                color: Color(0xFF8d8d8d),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
