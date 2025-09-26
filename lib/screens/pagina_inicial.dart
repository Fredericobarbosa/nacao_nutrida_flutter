import 'package:flutter/material.dart';
import '../components/header_inicial.dart';
import '../components/footer.dart';
import '../components/left_sidebar.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderInicial(
              rightText: 'Campanhas • Criar • Ajustes',
            ),
            Padding(padding: const EdgeInsets.all(24), child: LeftSidebar()),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
