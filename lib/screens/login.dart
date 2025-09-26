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
      int loadTime = _stopwatch.elapsedMilliseconds;

      // Tracking analytics
      AnalyticsService().trackPageView('Login');
      AnalyticsService().trackPageLoadTime('Login', loadTime);

      // Track heavy page if load time > 1000ms
      if (loadTime > 1000) {
        AnalyticsService().trackHeavyPageMetrics(
          'Login',
          loadTimeMs: loadTime,
          heavyOperations: ['Loading header', 'Loading login form'],
        );
      }

      setState(() {
        _tempoCarregamento = loadTime;
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
                  HeaderAuth(
                    rightText: 'Não tem conta?',
                    rightButtonText: 'Cadastrar-se',
                    onRightButtonPressed: () {
                      Navigator.of(context).pushNamed('/cadastro-usuario');
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
                    child: LoginForm(),
                  ),
                ],
              ),
            ),
    );
  }
}
