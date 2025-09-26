import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/cadastro_campanha.dart';

class CadastrarPedidoPage extends StatelessWidget {
  const CadastrarPedidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              leftText: null,
              rightText: 'Não tem conta?',
              rightButtonText: 'Cadastre-se',
              onRightButtonPressed: () {
                Navigator.of(context).pushNamed('/cadastro-usuario');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CadastroCampanhaForm(),
            ),
          ],
        ),
      ),
    );
  }
}
