import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_manager.dart';
import 'models/campaign.dart';
import 'screens/pagina_inicial.dart';
import 'screens/descobrir.dart';
import 'screens/descobrir_campanha.dart';
import 'screens/login.dart';
import 'screens/cadastro_usuario.dart';
import 'screens/cadastrar_campanha.dart';
import 'screens/detalhes_campanha.dart';
import 'screens/doar_alimentos.dart';
import 'screens/analytics_dashboard.dart';
import 'screens/dados_perfil.dart';
import 'screens/editar_perfil.dart';
import 'screens/painel_screen.dart';
import 'config/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.initialize();
  runApp(
    ChangeNotifierProvider(create: (_) => AuthManager(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Action Platform',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFf6f6f6)),
      initialRoute: '/',
      routes: {
        '/': (context) => const PaginaInicial(),
        '/descobrir': (context) => const DescobrirPage(),
        '/login': (context) => const LoginPage(),
        '/cadastro-usuario': (context) => const CadastroUsuarioPage(),
        '/cadastrar-campanha': (context) => const CadastrarCampanhaPage(),
        '/analytics': (context) => const AnalyticsDashboard(),
        '/descobrir-campanha': (context) => const DescobrirCampanhaPage(),
        '/perfil': (context) => DadosPerfil(),
        '/editar-perfil': (context) => const EditarPerfilPage(),
        '/painel': (context) => const PainelScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalhes-campanha') {
          final campanha = settings.arguments as Campaign;
          return MaterialPageRoute(
            builder: (context) => DetalhesCampanhaPage(campanhaId: campanha.id),
          );
        }
        if (settings.name == '/doar-alimentos') {
          final campanha = settings.arguments as Campaign;
          return MaterialPageRoute(
            builder: (context) => DoarAlimentosPage(campanha: campanha),
          );
        }
        return null;
      },
    );
  }
}
