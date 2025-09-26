import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/left_sidebar.dart';
import '../services/analytics_service.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
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
      final loadTime = _stopwatch.elapsedMilliseconds;

      // Coleta métricas da página inicial
      AnalyticsService().trackPageView('pagina_inicial');
      AnalyticsService().trackPageLoadTime('pagina_inicial', loadTime);

      // Se demorou mais de 1 segundo, considera página pesada
      if (loadTime > 1000) {
        AnalyticsService().trackHeavyPageMetrics(
          'pagina_inicial',
          loadTimeMs: loadTime,
          heavyOperations: ['Loading sidebar', 'Loading header'],
        );
      }

      setState(() {
        _tempoCarregamento = loadTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              rightText: '',
              rightButtonText: 'Login',
              onRightButtonPressed: () {
                AnalyticsService().trackButtonClick('Login', 'Header');
                Navigator.of(context).pushNamed('/login');
              },
            ),
            if (_tempoCarregamento != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tempo de carregamento: ${_tempoCarregamento!.toInt()} ms',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(padding: const EdgeInsets.all(24), child: LeftSidebar()),
            const Footer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AnalyticsService().trackButtonClick(
            'Analytics Dashboard',
            'FloatingButton',
          );
          Navigator.of(context).pushNamed('/analytics');
        },
        backgroundColor: const Color(0xFF027ba1),
        child: const Icon(Icons.analytics, color: Colors.white),
      ),
    );
  }
}
