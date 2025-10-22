import 'package:flutter/material.dart';
import '../components/header_auth.dart';
import '../components/cadastro_campanha.dart';
import '../services/analytics_service.dart';

class CadastrarCampanhaPage extends StatefulWidget {
  const CadastrarCampanhaPage({super.key});

  @override
  State<CadastrarCampanhaPage> createState() => _CadastrarCampanhaPageState();
}

class _CadastrarCampanhaPageState extends State<CadastrarCampanhaPage> {
  bool _carregou = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('CadastrarCampanha');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _carregou = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // nothing to do here
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
                    padding: const EdgeInsets.all(16.0),
                    child: CadastroCampanhaForm(),
                  ),
                ],
              ),
            ),
    );
  }
}
