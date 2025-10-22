import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_manager.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main CTA Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Arrecade alimentos \npara sua campanha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191929),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Alcance mais pessoas e transforme mais vidas',
                  style: TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final isLoggedIn = Provider.of<AuthManager>(
                          context,
                          listen: false,
                        ).isLoggedIn;
                        if (isLoggedIn) {
                          Navigator.of(
                            context,
                          ).pushNamed('/cadastrar-campanha');
                        } else {
                          Navigator.of(context).pushNamed('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFffc436),
                        foregroundColor: const Color(0xFFFFFFFF),
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Cadastrar Campanha'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/descobrir');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF769fcd)),
                        backgroundColor: const Color(0xFF769fcd),
                        foregroundColor: const Color(0xFFFFFFFF),
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Fazer Doação'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Social Actions Categories
        Card(
          color: const Color(0xFF769fcd),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Para campanhas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.inventory_2_outlined ,
                  'Criar uma campanha para',
                  'sua ação social',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.autorenew_outlined,
                  'Aguardar as solicitações de',
                  ' doação',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.forum_outlined,
                  'Combinar a entrega por',
                  'meio do chat',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.volunteer_activism,
                  'Receber os alimentos e ser',
                  'feliz',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Donors Section
        Card(
          color: const Color(0xFF064789),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Para doadores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.search,
                  'Procurar campanhas de',
                  'combate a fome',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.thumb_up_alt_outlined,
                  'Enviar uma solicitação de',
                  'ajuda e esperar',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.forum_outlined,
                  'Combinar a entrega por meio',
                  'do chat',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.volunteer_activism,
                  'Entregar os alimentos e ser',
                  'feliz',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.2 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withAlpha((0.8 * 255).toInt()),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTestimonial(
    String initials,
    String name,
    String role,
    String testimonial,
    String achievement,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: Text(initials),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191929),
                  fontSize: 14,
                ),
              ),
              Text(
                role,
                style: const TextStyle(color: Color(0xFF8d8d8d), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                testimonial,
                style: const TextStyle(
                  color: Color(0xFF191929),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                achievement,
                style: const TextStyle(color: Color(0xFF027ba1), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
