import 'package:flutter/material.dart';
import '../components/header_cadastro_usuario.dart';
import '../components/cadastro_usuario_form.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
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
      body: !_carregou
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  HeaderCadastroUsuario(
                    rightText: 'Já tem conta?',
                    rightButtonText: 'Entrar',
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
