import 'package:flutter/material.dart';
import '../components/header_cadastro_usuario.dart';
import '../components/cadastro_usuario_form.dart';
import '../services/analytics_service.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  bool _carregou = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('CadastroUsuario');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _carregou = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // analytics.page view tracked in initState
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
                  HeaderCadastroUsuario(
                    rightText: 'Já tem conta?',
                    rightButtonText: 'Faça o login',
                    onRightButtonPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                  ),
                  const SizedBox.shrink(),
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
