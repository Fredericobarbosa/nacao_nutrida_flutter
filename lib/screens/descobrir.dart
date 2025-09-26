import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/center_content.dart';

class DescobrirPage extends StatefulWidget {
  const DescobrirPage({super.key});

  @override
  State<DescobrirPage> createState() => _DescobrirPageState();
}

class _DescobrirPageState extends State<DescobrirPage> {
  late Stopwatch _stopwatch;
  int? _tempoCarregamento;
  bool _carregou = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _carregou = true;
        _stopwatch.stop();
        _tempoCarregamento = _stopwatch.elapsedMilliseconds;
      });
    });
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70, // mesma altura do header
                        child: Container(
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
                      ),
                      Expanded(
                        child: Header(
                          leftText: '',
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
                  if (_tempoCarregamento != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tempo de carregamento: ${_tempoCarregamento!.toInt()} ms',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: CenterContent(),
                  ),
                  const Footer(),
                ],
              ),
            ),
    );
  }
}
