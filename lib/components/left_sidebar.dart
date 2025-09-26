import 'package:flutter/material.dart';

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
                  'Reduza a fome\nAtravés de sua\nação social',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191929),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Junte-se a nós e faça a diferença',
                  style: TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastrar-pedido');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFffc436),
                        foregroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
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
                        Navigator.pushNamed(context, '/login');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF769fcd)),
                        backgroundColor: const Color(0xFF769fcd),
                        foregroundColor: const Color.fromARGB(
                          255,
                          254,
                          255,
                          254,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Fazer doação'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Charity Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pratique a caridade!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191929),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encontre ações sociais da sua região e ajude a combater a fome perto de você',
                  style: TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/descobrir');
                  },
                  child: const Text(
                    'Encontre campanhas em sua região →',
                    style: TextStyle(color: Color(0xFF027ba1), fontSize: 14),
                  ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para ações sociais:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.people,
                  'Criar um projeto',
                  'para sua ação social',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.favorite,
                  'Apoiar um projeto',
                  'para sua ação social',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para doadores:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.search,
                  'Procurar projetos ou',
                  'ações na sua região',
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  Icons.description,
                  'Contribuir e entregar',
                  'por meio do chat',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // User Testimonials
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Relatos de nossos usuários',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191929),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTestimonial(
                  'AM',
                  'Ana Maria',
                  'Doadora há 2 anos',
                  '"Através do Nós consegui ajudar várias famílias da minha região. É muito gratificante saber que posso fazer a diferença."',
                  'Já doou mais de 50kg de arroz para famílias necessitadas',
                ),
                const SizedBox(height: 16),
                _buildTestimonial(
                  'CS',
                  'Carlos Silva',
                  'Organizador de campanhas',
                  '"Consegui organizar várias campanhas através da plataforma. É fácil de usar e muito eficiente."',
                  'Já organizou 15 campanhas',
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
            color: Colors.white.withOpacity(0.2),
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
                color: Colors.white.withOpacity(0.8),
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
