import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/cadastro_pedido_form.dart';

class CadastrarPedidoPage extends StatelessWidget {
  const CadastrarPedidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(
              leftText: null,
              rightText: 'Não tem conta?',
              rightButtonText: 'Cadastre-se',
              onRightButtonPressed: null,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CadastroPedidoForm(),
            ),
          ],
        ),
      ),
    );
  }
}