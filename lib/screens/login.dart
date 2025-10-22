import 'package:flutter/material.dart';
import '../components/header_auth.dart';
import '../components/login_form.dart';
import '../services/analytics_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _carregou = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('Login');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _carregou = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // analytics page view already tracked in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  HeaderAuth(
                    rightText: 'Não tem conta?',
                    rightButtonText: 'Cadastrar-se',
                    onRightButtonPressed: () {
                      Navigator.of(context).pushNamed('/cadastro-usuario');
                    },
                  ),
                  const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: LoginForm(),
                  ),
                ],
              ),
            ),
    );
  }
}
