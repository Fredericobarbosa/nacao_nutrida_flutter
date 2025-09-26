import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';
import '../components/left_sidebar.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  late Stopwatch _stopwatch;
  int? _tempoCarregamento;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tempoCarregamento == null) {
      _stopwatch.stop();
      setState(() {
        _tempoCarregamento = _stopwatch.elapsedMilliseconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              rightText: '',
              rightButtonText: 'Login',
              onRightButtonPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
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
            Padding(padding: const EdgeInsets.all(24), child: LeftSidebar()),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
