import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../models/campaign.dart';
import '../models/auth_manager.dart';
import '../services/analytics_service.dart';
import '../services/api_service.dart';
import '../config/api.dart';

class DoarAlimentosPage extends StatefulWidget {
  final Campaign campanha;

  const DoarAlimentosPage({super.key, required this.campanha});

  @override
  State<DoarAlimentosPage> createState() => _DoarAlimentosPageState();
}

class _DoarAlimentosPageState extends State<DoarAlimentosPage> {
  final Map<String, int> _doacoes = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('Doar Alimentos');
    for (String alimento in widget.campanha.metaAlimentos.keys) {
      _doacoes[alimento] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              rightText: authManager.isLoggedIn
                  ? 'Olá, ${authManager.userName?.split(' ').first}!'
                  : 'Já tem conta?',
              rightButtonText: authManager.isLoggedIn ? 'Sair' : 'Entrar',
              onRightButtonPressed: () {
                if (authManager.isLoggedIn) {
                  authManager.logout();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushNamed('/login');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCabecalho(),
                  const SizedBox(height: 24),
                  _buildResumoCapmanha(),
                  const SizedBox(height: 24),
                  _buildSeletorAlimentos(),
                  const SizedBox(height: 24),
                  _buildResumoDoacao(),
                  const SizedBox(height: 32),
                  _buildBotoesAcao(),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF027ba1)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fazer Doação de Alimentos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF027ba1),
                    ),
                  ),
                  Text(
                    'Para: ${widget.campanha.title}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumoCapmanha() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF027ba1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF027ba1).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Color(0xFF027ba1), size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.campanha.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Responsável: ${widget.campanha.responsavel}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Local: ${widget.campanha.endereco}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeletorAlimentos() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os Alimentos para Doar (kg)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF027ba1),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.campanha.metaAlimentos.keys.map((alimento) {
              final metaQtd = widget.campanha.metaAlimentos[alimento] ?? 0;
              final arrecadadoQtd =
                  widget.campanha.alimentosArrecadados[alimento] ?? 0;
              final necessario = metaQtd - arrecadadoQtd;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          color: Color(0xFF027ba1),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alimento,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Necessário: ${necessario > 0 ? necessario : 0} kg',
                          style: TextStyle(
                            fontSize: 12,
                            color: necessario > 0 ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantidade (kg)',
                              hintText: '0',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _doacoes[alimento] = int.tryParse(value) ?? 0;
                              });
                            },
                            validator: (value) {
                              final qty = int.tryParse(value ?? '0') ?? 0;
                              if (qty < 0) {
                                return 'Quantidade deve ser positiva';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (_doacoes[alimento] ?? 0) > 0
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_doacoes[alimento] ?? 0} kg',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (_doacoes[alimento] ?? 0) > 0
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoDoacao() {
    final totalDoacao = _doacoes.values.fold(0, (sum, qty) => sum + qty);
    final alimentosComDoacao =
        _doacoes.entries.where((entry) => entry.value > 0).toList();

    if (totalDoacao == 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Resumo da Sua Doação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alimentosComDoacao.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 16)),
                  Text(
                    '${entry.value} kg',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '$totalDoacao kg',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotoesAcao() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF027ba1),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _confirmarDoacao,
            icon: _isLoading
                ? Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.volunteer_activism),
            label: Text(_isLoading ? 'Enviando...' : 'Confirmar Doação'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmarDoacao() async {
    final authManager = Provider.of<AuthManager>(context, listen: false);

    if (!authManager.isLoggedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.login, color: Color(0xFF027ba1), size: 28),
                SizedBox(width: 8),
                Text('Login Necessário'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Para concluir sua doação, é necessário fazer login.'),
                SizedBox(height: 12),
                Text(
                  'Benefícios do login:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Acompanhar suas doações'),
                Text('• Receber comprovantes por e-mail'),
                Text('• Histórico de contribuições'),
                Text('• Contato direto com responsáveis'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF027ba1),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Fazer Login'),
              ),
            ],
          );
        },
      );
      return;
    }

    final totalDoacao = _doacoes.values.fold(0, (sum, qty) => sum + qty);
    if (totalDoacao == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um alimento para doar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bool sucesso = await _postDoacao();

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (sucesso) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Doação Confirmada!'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sua doação foi registrada com sucesso!'),
                SizedBox(height: 12),
                Text(
                  'Próximos passos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1. O responsável da campanha entrará em contato'),
                Text('2. Será combinado local e horário para entrega'),
                Text('3. Você receberá um comprovante da doação'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _postDoacao() async {
    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    if (!mounted) return false;

    try {
      final perfilResp = await api.get('/perfil');
      if (perfilResp.statusCode != 200) {
        debugPrint('Falha ao buscar /usuario/perfil. Status: ${perfilResp.statusCode}');
        debugPrint('Corpo da Resposta (Erro): ${perfilResp.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível obter perfil do usuário.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      final perfil = jsonDecode(perfilResp.body);
      final usuarioId = perfil['_id']?.toString() ?? perfil['id']?.toString();
      if (usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID do usuário inválido.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      final campanhaResp = await api.get('/campanhas/${widget.campanha.id}');
      if (campanhaResp.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível obter dados da campanha.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      final campanhaJson = jsonDecode(campanhaResp.body);
      final alimentosCampanha = campanhaJson['alimentos'] as List?;
      final Map<String, String> nomeParaId = {};
      if (alimentosCampanha != null) {
        for (final a in alimentosCampanha) {
          final id = a['alimento_id']?.toString() ?? a['id']?.toString();
          final nome =
              a['nm_alimento']?.toString() ?? a['nome']?.toString() ?? id;
          if (id != null && nome != null) nomeParaId[nome] = id;
        }
      }

      final alimentosDoacao = <Map<String, dynamic>>[];
      _doacoes.forEach((nome, qty) {
        if (qty > 0) {
          final alimentoId = nomeParaId[nome];
          if (alimentoId == null) {
            throw Exception('ID do alimento não encontrado para $nome');
          }
          alimentosDoacao.add({
            'alimento_id': alimentoId,
            'qt_alimento_doacao': qty,
          });
        }
      });

      if (alimentosDoacao.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione ao menos um alimento para doar.'),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }

      final payload = {
        'infos_doacao': {
          'usuario_doacao': usuarioId.toString(),
          'cd_campanha_doacao': widget.campanha.id,
        },
        'alimentos_doacao': alimentosDoacao,
      };

      final resp = await api.post('/doacoes', payload);
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar doação: ${resp.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao registrar doação: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}