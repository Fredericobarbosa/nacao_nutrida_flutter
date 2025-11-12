import 'package:flutter/material.dart';
import '../components/header_login.dart';
import '../components/footer.dart';
import '../services/analytics_service.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import '../models/campaign.dart';
import 'dart:convert';

class DescobrirCampanhaPage extends StatefulWidget {
  const DescobrirCampanhaPage({super.key});

  @override
  State<DescobrirCampanhaPage> createState() => _DescobrirCampanhaPage();
}

class _DescobrirCampanhaPage extends State<DescobrirCampanhaPage> {
  bool _loadingApi = false;
  String? _error;
  List<Campaign> _campanhas = [];

  // Campos da barra de pesquisa
  String? _estadoSelecionado;
  String? _selectedCidade;
  final TextEditingController _cidadeController = TextEditingController();
  List<Map<String, dynamic>> _estadosCidades = [];
  bool _usingFallbackEstados = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('Descobrir');
    _fetchEstadosCidades();
    _fetchCampanhas();
  }

  Future<void> _fetchEstadosCidades() async {
    // Tenta buscar do backend com até 2 tentativas. Se falhar, usa fallback embutido para dev.
    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    int attempts = 0;
    while (attempts < 2) {
      attempts += 1;
      try {
        final resp = await api.get('/estadosCidades');
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as List<dynamic>;
          setState(() {
            _usingFallbackEstados = false;
            _estadosCidades = data
                .map((e) => e as Map<String, dynamic>)
                .toList();
            if (_estadosCidades.isNotEmpty && _estadoSelecionado == null) {
              _estadoSelecionado = _estadosCidades[0]['sg_estado'] as String;
            }
          });
          return;
        } else {
          print('Falha ao buscar estadosCidades: ' + resp.body);
        }
      } catch (e) {
        print('Tentativa $attempts: erro ao buscar estadosCidades: $e');
        // se última tentativa, siga para fallback
        if (attempts >= 2) break;
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    // Se chegou aqui, todas as tentativas falharam — usar fallback embutido para desenvolvimento
    setState(() {
      _usingFallbackEstados = true;
      _estadosCidades = [
        {
          'sg_estado': 'SP',
          'cidades': ['São Paulo', 'Campinas', 'Santos'],
        },
        {
          'sg_estado': 'RJ',
          'cidades': ['Rio de Janeiro', 'Niterói', 'Petrópolis'],
        },
        {
          'sg_estado': 'MG',
          'cidades': ['Belo Horizonte', 'Uberlândia', 'Ouro Preto'],
        },
      ];
      if (_estadoSelecionado == null && _estadosCidades.isNotEmpty) {
        _estadoSelecionado = _estadosCidades[0]['sg_estado'] as String;
      }
    });
    // opcional: log para dev
    print('Usando fallback local de estadosCidades (dev)');
  }

  Future<void> _fetchCampanhas({String? estado, String? cidade}) async {
    setState(() {
      _loadingApi = true;
      _error = null;
    });

    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    try {
      final resp = await api.get('/campanhas');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        final list = data.map((e) => _mapToCampaign(e)).toList();

        List<Campaign> filtradas = List<Campaign>.from(list);

        if (estado != null && estado.isNotEmpty) {
          filtradas = filtradas
              .where((c) => c.endereco.contains('- $estado'))
              .toList();
        }
        if (cidade != null && cidade.isNotEmpty) {
          filtradas = filtradas
              .where(
                (c) => c.endereco.toLowerCase().contains(cidade.toLowerCase()),
              )
              .toList();
        }

        setState(() {
          _campanhas = filtradas;
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

  void _limparFiltros() {
    setState(() {
      _estadoSelecionado = null;
      _selectedCidade = null;
      _cidadeController.clear();
    });
    _fetchCampanhas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com botão voltar
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
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
                const Expanded(child: HeaderLogin()),
              ],
            ),

            // Barra de pesquisa
            Container(
              color: const Color(0xFF7da3cc),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Encontre campanhas de combate à fome perto de você',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  if (_usingFallbackEstados)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Modo fallback: carregando lista local (desenvolvimento)',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                  // Linha com Estado e Cidade (dropdowns dependentes)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Selecione o Estado'),
                              ),
                              value: _estadoSelecionado,
                              isExpanded: true,
                              items: _estadosCidades
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e['sg_estado'] as String,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(e['sg_estado'] as String),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _estadoSelecionado = newValue;
                                  _selectedCidade = null;
                                  _cidadeController.text = '';
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE5F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Selecione a Cidade'),
                              ),
                              value: _selectedCidade,
                              isExpanded: true,
                              items:
                                  (_estadosCidades.firstWhere(
                                            (e) =>
                                                e['sg_estado'] ==
                                                _estadoSelecionado,
                                            orElse: () => {
                                              'cidades': <String>[],
                                            },
                                          )['cidades']
                                          as List<dynamic>)
                                      .map(
                                        (c) => DropdownMenuItem<String>(
                                          value: c,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(c),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                setState(() {
                                  _selectedCidade = v;
                                  _cidadeController.text = v ?? '';
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Botões abaixo da barra
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _fetchCampanhas(
                            estado: _estadoSelecionado,
                            cidade: _cidadeController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCC02E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Procurar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _limparFiltros,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Limpar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Lista de campanhas
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
                                          width: 80,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.grey.withAlpha(30),
                                          ),
                                          child: const Icon(
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
                                                const Icon(
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
