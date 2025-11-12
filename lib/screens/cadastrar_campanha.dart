import 'package:flutter/material.dart';
import '../components/header_login.dart';
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
      
      // **ALTERAÇÃO AQUI:** Usando HeaderLogin no appBar
      // showBack: true é usado para incluir o botão de voltar, comum em formulários de cadastro.
      appBar: const HeaderLogin(showBack: true), 

      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // O componente HeaderAuth (ou a lógica de cabeçalho antiga) foi removido daqui
                  // const SizedBox.shrink(),
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