import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../models/campaign.dart';
import '../models/auth_manager.dart';

class DoarAlimentosPage extends StatefulWidget {
  final Campaign campanha;

  const DoarAlimentosPage({super.key, required this.campanha});

  @override
  State<DoarAlimentosPage> createState() => _DoarAlimentosPageState();
}

class _DoarAlimentosPageState extends State<DoarAlimentosPage> {
  final Map<String, int> _doacoes = {};

  @override
  void initState() {
    super.initState();
    // Inicializa o mapa de doações com os alimentos da campanha
    for (String alimento in widget.campanha.tiposAlimento) {
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
        color: const Color(0xFF027ba1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF027ba1).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.campaign, color: const Color(0xFF027ba1), size: 32),
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
            color: Colors.grey.withValues(alpha: 0.1),
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
            children: widget.campanha.tiposAlimento.map((alimento) {
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
                        Icon(
                          Icons.restaurant,
                          color: const Color(0xFF027ba1),
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
                            color: necessario > 0
                                ? Colors.orange
                                : Colors.green,
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
                            decoration: InputDecoration(
                              labelText: 'Quantidade (kg)',
                              hintText: '0',
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
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
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
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
    final alimentosComDoacao = _doacoes.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (totalDoacao == 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              const Text(
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
            onPressed: () => Navigator.pop(context),
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
            onPressed: _confirmarDoacao,
            icon: const Icon(Icons.volunteer_activism),
            label: const Text('Confirmar Doação'),
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

  void _confirmarDoacao() {
    final authManager = Provider.of<AuthManager>(context, listen: false);

    // Se usuário não estiver logado, redirecionar para login
    if (!authManager.isLoggedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.login, color: const Color(0xFF027ba1), size: 28),
                const SizedBox(width: 8),
                const Text('Login Necessário'),
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
                  Navigator.of(context).pop(); // Fecha dialog
                  Navigator.of(context).pushNamed('/login'); // Vai para login
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

    // Simular confirmação da doação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Doação Confirmada!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sua doação foi registrada com sucesso!'),
              const SizedBox(height: 12),
              const Text(
                'Próximos passos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. O responsável da campanha entrará em contato'),
              const Text('2. Será combinado local e horário para entrega'),
              const Text('3. Você receberá um comprovante da doação'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Volta para detalhes
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
