import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  Map<String, dynamic>? _metricsReport;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  void _loadMetrics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Carrega métricas do armazenamento persistente
      final report = await AnalyticsService().getMetricsReport();
      setState(() {
        _metricsReport = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar métricas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      appBar: AppBar(
        title: const Text('Dashboard de Analytics'),
        backgroundColor: const Color(0xFF027ba1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMetrics,
            tooltip: 'Atualizar dados',
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: _sendDataToAPI,
            tooltip: 'Enviar dados para API',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAllData,
            tooltip: 'Limpar todos os dados',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboardContent(),
    );
  }

  Widget _buildDashboardContent() {
    if (_metricsReport == null) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 20),
          _buildMostAccessedPages(),
          const SizedBox(height: 20),
          _buildMostClickedButtons(),
          const SizedBox(height: 20),
          _buildPageLoadTimes(),
          const SizedBox(height: 20),
          _buildHeavyPages(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalMetrics = _metricsReport!['total_metrics'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: const Color(0xFF027ba1), size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Resumo Geral',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF027ba1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Total de Métricas',
                    totalMetrics.toString(),
                    Icons.data_usage,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    'Status da API',
                    'Configurada',
                    Icons.cloud_done,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMostAccessedPages() {
    final pages =
        _metricsReport!['most_accessed_pages'] as Map<String, int>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.visibility, color: Colors.orange, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Páginas Mais Acessadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pages.isEmpty)
              const Text('Nenhuma página acessada ainda')
            else
              ...pages.entries
                  .take(5)
                  .map(
                    (entry) => _buildListItem(
                      entry.key,
                      '${entry.value} visualizações',
                      Colors.orange,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostClickedButtons() {
    final buttons =
        _metricsReport!['most_clicked_buttons'] as Map<String, int>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.touch_app, color: Colors.purple, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Botões Mais Clicados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (buttons.isEmpty)
              const Text('Nenhum botão clicado ainda')
            else
              ...buttons.entries
                  .take(5)
                  .map(
                    (entry) => _buildListItem(
                      entry.key,
                      '${entry.value} cliques',
                      Colors.purple,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageLoadTimes() {
    final loadTimes =
        _metricsReport!['average_load_times'] as Map<String, double>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Tempo de Renderização',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (loadTimes.isEmpty)
              const Text('Nenhum tempo de renderização coletado')
            else
              ...loadTimes.entries.map(
                (entry) => _buildListItem(
                  entry.key,
                  '${entry.value.toStringAsFixed(0)}ms média',
                  entry.value > 1000 ? Colors.red : Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeavyPages() {
    final heavyPages =
        _metricsReport!['heavy_pages'] as Map<String, int>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Páginas Pesadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (heavyPages.isEmpty)
              const Text('Nenhuma página pesada detectada')
            else
              ...heavyPages.entries.map(
                (entry) => _buildListItem(
                  entry.key,
                  '${entry.value} ocorrências',
                  Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendDataToAPI() async {
    // Salva o contexto antes do await
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Mostra dialog de loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Enviando dados para API...'),
          ],
        ),
      ),
    );

    try {
      await AnalyticsService().sendMetricsToAPI();

      if (mounted) {
        navigator.pop(); // Fecha loading dialog

        // Mostra sucesso
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Dados enviados com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Atualiza os dados
        _loadMetrics();
      }
    } catch (e) {
      if (mounted) {
        navigator.pop(); // Fecha loading dialog

        // Mostra erro
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Erro ao enviar: $e'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearAllData() async {
    // Mostra confirmação
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Dados'),
        content: const Text(
          'Tem certeza que deseja limpar todos os dados de analytics?\n\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Limpar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Salva o contexto antes do await
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Limpando dados...'),
          ],
        ),
      ),
    );

    try {
      await AnalyticsService().clearAllData();

      if (mounted) {
        navigator.pop(); // Fecha loading dialog

        // Mostra sucesso
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Dados limpos com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Atualiza os dados
        _loadMetrics();
      }
    } catch (e) {
      if (mounted) {
        navigator.pop(); // Fecha loading dialog

        // Mostra erro
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Erro ao limpar: $e'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
