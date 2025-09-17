import 'package:flutter/material.dart';
import 'screens/pagina_inicial.dart';
import 'screens/descobrir.dart';
import 'screens/login.dart';
import 'screens/cadastro_usuario.dart';
import 'screens/cadastrar_pedido.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Action Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFf6f6f6),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PaginaInicial(),
        '/descobrir': (context) => const DescobrirPage(),
        '/login': (context) => const LoginPage(),
        '/cadastro-usuario': (context) => const CadastroUsuarioPage(),
        '/cadastrar-pedido': (context) => const CadastrarPedidoPage(),
      },
    );
  }
}