import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../models/campaign.dart';
import '../models/auth_manager.dart';
import '../services/analytics_service.dart';

class DetalhesCampanhaPage extends StatefulWidget {
  final Campaign campanha;

  const DetalhesCampanhaPage({super.key, required this.campanha});

  @override
  State<DetalhesCampanhaPage> createState() => _DetalhesCampanhaPageState();
}

class _DetalhesCampanhaPageState extends State<DetalhesCampanhaPage> {
  late Stopwatch _stopwatch;
  int? _tempoCarregamento;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tempoCarregamento == null) {
      _stopwatch.stop();
      int loadTime = _stopwatch.elapsedMilliseconds;

      // Tracking analytics
      AnalyticsService().trackPageView('Detalhes Campanha');
      AnalyticsService().trackPageLoadTime('Detalhes Campanha', loadTime);

      // Track heavy page if load time > 1000ms
      if (loadTime > 1000) {
        AnalyticsService().trackHeavyPageMetrics(
          'Detalhes Campanha',
          loadTimeMs: loadTime,
          heavyOperations: [
            'Loading campaign details',
            'Loading header',
            'Loading footer',
          ],
        );
      }

      setState(() {
        _tempoCarregamento = loadTime;
      });
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
                  _buildImagemEInfo(),
                  const SizedBox(height: 24),
                  _buildProgressoArrecadacao(),
                  const SizedBox(height: 24),
                  _buildDetalhesAlimentos(),
                  const SizedBox(height: 24),
                  _buildInformacoesGerais(),
                  const SizedBox(height: 32),
                  _buildBotoesAcao(context),
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
            Icon(Icons.campaign, color: const Color(0xFF027ba1), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.campanha.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF027ba1),
                ),
              ),
            ),
            _buildStatusChip(),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.campanha.description,
          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color corStatus;
    switch (widget.campanha.status.toLowerCase()) {
      case 'ativa':
        corStatus = Colors.green;
        break;
      case 'concluida':
        corStatus = Colors.blue;
        break;
      case 'pausada':
        corStatus = Colors.orange;
        break;
      default:
        corStatus = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: corStatus.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: corStatus, width: 1),
      ),
      child: Text(
        widget.campanha.statusFormatado,
        style: TextStyle(
          color: corStatus,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildImagemEInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagem da campanha
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.campanha.imageUrl != null
                ? Image.network(
                    widget.campanha.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildImagemPadrao(),
                  )
                : _buildImagemPadrao(),
          ),
        ),
        const SizedBox(width: 24),
        // Informações básicas
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem('Responsável', widget.campanha.responsavel),
              const SizedBox(height: 12),
              _buildInfoItem('Endereço', widget.campanha.endereco),
              const SizedBox(height: 12),
              _buildInfoItem(
                'Data Início',
                _formatarData(widget.campanha.dataInicio),
              ),
              if (widget.campanha.dataFim != null) ...[
                const SizedBox(height: 12),
                _buildInfoItem(
                  'Data Fim',
                  _formatarData(widget.campanha.dataFim!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagemPadrao() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Sem imagem',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressoArrecadacao() {
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
            'Progresso da Arrecadação de Alimentos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF027ba1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.campanha.totalAlimentosArrecadados} kg',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                '${widget.campanha.percentualArrecadado.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF027ba1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Meta: ${widget.campanha.totalMetaAlimentos} kg',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: widget.campanha.percentualArrecadado / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildDetalhesAlimentos() {
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
            'Alimentos Necessários (kg)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF027ba1),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.campanha.metaAlimentos.entries.map((entry) {
              final alimento = entry.key;
              final metaQtd = entry.value;
              final arrecadadoQtd =
                  widget.campanha.alimentosArrecadados[alimento] ?? 0;
              final percentual = metaQtd > 0
                  ? (arrecadadoQtd / metaQtd) * 100
                  : 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 18,
                              color: const Color(0xFF027ba1),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              alimento,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$arrecadadoQtd / $metaQtd kg',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: percentual >= 100
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentual / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentual >= 100 ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${percentual.toStringAsFixed(1)}% arrecadado',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildInformacoesGerais() {
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
            'Informações Gerais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF027ba1),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ID da Campanha', widget.campanha.id),
          _buildInfoRow('Status Atual', widget.campanha.statusFormatado),
          _buildInfoRow('Responsável', widget.campanha.responsavel),
          _buildInfoRow('Localização', widget.campanha.endereco),
          _buildInfoRow('Início', _formatarData(widget.campanha.dataInicio)),
          if (widget.campanha.dataFim != null)
            _buildInfoRow('Término', _formatarData(widget.campanha.dataFim!)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(valor, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildBotoesAcao(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              AnalyticsService().trackButtonClick(
                'Fazer Doação',
                'Detalhes Campanha',
              );
              Navigator.of(
                context,
              ).pushNamed('/doar-alimentos', arguments: widget.campanha);
            },
            icon: const Icon(Icons.volunteer_activism),
            label: const Text('Fazer Doação'),
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
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
      ],
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
