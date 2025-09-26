import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/cadastro_campanha.dart';

class CadastrarCampanhaPage extends StatelessWidget {
  const CadastrarCampanhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              rightText: '',
              rightButtonText: '',
              onRightButtonPressed: null,
              showLogo: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CadastroCampanhaForm(),
            ),
          ],
        ),
      ),
    );
  }
}
