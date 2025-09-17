import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/center_content.dart';

class DescobrirPage extends StatelessWidget {
  const DescobrirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(
              leftText: 'Campanhas • Criar • Apostar',
              rightText: 'Não tem conta?',
              rightButtonText: 'Cadastre-se',
              onRightButtonPressed: null,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CenterContent(),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}