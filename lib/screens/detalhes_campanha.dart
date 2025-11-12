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
    // Mapear campos conforme o modelo Campaign
    final metaAlimentos = <String, int>{};
    final arrecadados = <String, int>{};

    if (json['alimentos_campanha'] is List) {
      for (final item in json['alimentos_campanha']) {
        final nome = item['nm_alimento'] ?? item['nome'] ?? 'Desconhecido';
        final meta = (item['qt_alimento_meta'] ?? 0) as int;
        metaAlimentos[nome] = meta;
      }
    }

    if (json['alimentos_arrecadados'] is List) {
      for (final item in json['alimentos_arrecadados']) {
        final nome = item['nm_alimento'] ?? item['nome'] ?? 'Desconhecido';
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

    return Campaign(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['nm_titulo_campanha'] ?? json['title'] ?? 'Campanha',
      description: json['ds_acao_campanha'] ?? json['description'] ?? '',
      imageUrl: json['cd_imagem_campanha'],
      status: json['st_campanha'] ?? 'ativa',
      metaAlimentos: metaAlimentos,
      alimentosArrecadados: arrecadados,
      tiposAlimento:
          (json['tipos_alimento'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      responsavel: json['nm_responsavel'] ?? json['responsavel'] ?? '',
      dataInicio: parseDate(json['dt_inicio']),
      dataFim: json['dt_fim'] != null ? parseDate(json['dt_fim']) : null,
      endereco: json['ds_endereco'] ?? json['endereco'] ?? '',
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
                    Image.network(_campanha!.imageUrl!),
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
