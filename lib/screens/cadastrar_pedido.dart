import 'package:flutter/material.dart';
import '../components/header.dart';
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
      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF027ba1),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Header(
                          leftText: null,
                          rightText: 'Não tem conta?',
                          rightButtonText: 'Cadastre-se',
                          onRightButtonPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/cadastro-usuario');
                          },
                        ),
                      ),
                    ],
                  ),
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
