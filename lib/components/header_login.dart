import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderLogin extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const HeaderLogin({Key? key, this.showBack = false, this.onBack})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  // --- MODAL "Sobre nós" ---
  void _showSobreNos(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sobre nós',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF027ba1),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'O projeto Nação Nutrida nasceu para conectar pessoas, ONGs e empresas em prol do combate à fome e à insegurança alimentar no Brasil. Nosso objetivo é facilitar doações, promover campanhas solidárias e criar uma rede de apoio que transforma vidas.\n\n'
                  'Aqui, você pode criar campanhas, doar alimentos, acompanhar o progresso das ações e conversar diretamente com quem está fazendo a diferença. Junte-se a nós e faça parte dessa corrente do bem!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF027ba1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- FUNÇÃO DE LOGOUT ---
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove dados de login
    await prefs.clear();

    // Mostra mensagem de saída
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout realizado com sucesso.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Redireciona para tela de login (ajuste conforme sua rota)
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Logo e botão voltar
          Row(
            children: [
              if (showBack)
                IconButton(
                  icon:
                      const Icon(Icons.arrow_back, color: Color(0xFF027ba1)),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/'),
                child: Row(
                  children: [
                    Image.asset('assets/logo.png', width: 36, height: 36),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          // Links do header
          Row(
            children: [
              _HeaderLink(
                label: 'Descobrir',
                onTap: () => Navigator.of(context).pushNamed('/descobrir-campanha'),
              ),
              const SizedBox(width: 12),
              _HeaderLink(
                label: 'Criar',
                onTap: () => Navigator.of(context).pushNamed('/cadastrar-campanha'),
              ),
              const SizedBox(width: 12),
              _HeaderLink(
                label: 'Sobre nós',
                onTap: () => _showSobreNos(context),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Avatar com menu
          PopupMenuButton<int>(
            tooltip: 'Conta',
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Painel')),
              const PopupMenuItem(value: 2, child: Text('Chat')),
              const PopupMenuItem(value: 3, child: Text('Meus dados')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 99,
                child: Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (v) {
              switch (v) {
                case 1:
                  Navigator.of(context).pushNamed('/painel');
                  break;
                case 2:
                  Navigator.of(context).pushNamed('/chat');
                  break;
                case 3:
                  Navigator.of(context).pushNamed('/perfil');
                  break;
                case 99:
                  _logout(context);
                  break;
              }
            },
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, color: Colors.black54),
                ),
                SizedBox(width: 8),
                Icon(Icons.expand_more, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeaderLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
