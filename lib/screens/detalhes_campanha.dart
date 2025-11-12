import 'dart:convert';
import 'package:flutter/material.dart';
import '../config/api.dart'; // Verifique se os caminhos de import estão corretos
import '../models/campaign.dart'; // Verifique se os caminhos de import estão corretos
import '../services/api_service.dart'; // Verifique se os caminhos de import estão corretos

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
      status: status, // Corrigido
      metaAlimentos: metaAlimentos, // Corrigido
      alimentosArrecadados: arrecadados, // Corrigido
      
      tiposAlimento:
          (json['tipos_alimento'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
          
      responsavel: json['nm_usuario'] ?? json['nm_responsavel'] ?? json['responsavel'] ?? '',
      
      dataInicio: parseDate(json['ts_criacao_campanha'] ?? json['dt_inicio']),
      
      dataFim: dtFimJson != null ? parseDate(dtFimJson) : null,
      
      endereco: enderecoCompleto,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_campanha?.title ?? 'Detalhes da Campanha')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _campanha == null
                  ? const Center(child: Text('Nenhuma campanha encontrada'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_campanha!.imageUrl != null)
                            Image.asset(_campanha!.imageUrl!),
                          const SizedBox(height: 12),
                          Text(
                            _campanha!.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_campanha!.description),
                          const SizedBox(height: 12),
                          // Agora deve exibir "Yago Silva"
                          Text('Responsável: ${_campanha!.responsavel}'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed('/doar-alimentos', arguments: _campanha),
                            child: const Text('Fazer Doação'),
                          ),
                        ],
                      ),
                    ),
    );
  }
}