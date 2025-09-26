import 'package:flutter/material.dart';
import '../components/header_auth.dart';
import '../components/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderAuth(
              rightText: 'Não tem conta?',
              rightButtonText: 'Cadastre-se',
              onRightButtonPressed: () {
                Navigator.pushNamed(context, '/cadastro-usuario');
              },
              showBackButton: true,
            ),
            Padding(padding: const EdgeInsets.all(24), child: LoginForm()),
          ],
        ),
      ),
    );
  }
}
