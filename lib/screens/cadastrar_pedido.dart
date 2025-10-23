import 'package:flutter/material.dart';
import '../components/header_login.dart';
import '../components/cadastro_campanha.dart';
import '../services/analytics_service.dart';

class CadastrarPedidoPage extends StatefulWidget {
  const CadastrarPedidoPage({super.key});

  @override
  State<CadastrarPedidoPage> createState() => _CadastrarPedidoPageState();
}

class _CadastrarPedidoPageState extends State<CadastrarPedidoPage> {
  bool _carregou = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService().trackPageView('CadastrarPedido');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _carregou = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // nothing to do
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),

      // **SUBSTITUIÇÃO AQUI:** Usando HeaderLogin no appBar
      // showBack: true garante que o botão de voltar apareça.
      appBar: const HeaderLogin(showBack: true), 
      // O HeaderLogin trata do botão de voltar e do layout do cabeçalho.

      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  
                  // REMOVEMOS A ROW COM O ICONBUTTON E O HEADER MANUAL
                  // Essa lógica foi movida para o appBar

                  const SizedBox.shrink(),
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