import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/pagina_inicial.dart';
import '../services/analytics_service.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('pagina_inicial');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            const SizedBox.shrink(),
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
