import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/cadastro_usuario_form.dart';

class CadastroUsuarioPage extends StatelessWidget {
  const CadastroUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(
              leftText: null,
              rightText: 'Já tem conta?',
              rightButtonText: 'Entrar',
              onRightButtonPressed: null,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CadastroUsuarioForm(),
            ),
          ],
        ),
      ),
    );
  }
}