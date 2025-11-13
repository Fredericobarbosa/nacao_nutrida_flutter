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


      appBar: const HeaderLogin(showBack: true), 


      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [

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