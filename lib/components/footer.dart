import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: const Color(0xFF191929),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  /// Layout para telas grandes (como o da imagem)
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Coluna: Logo e nome
        Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
              color: const Color(0xFF191929),
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 8),
            const Text(
              'Nação Nutrida',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Coluna: Ações sociais
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ações sociais',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text('Criar', style: TextStyle(color: Colors.white70)),
            Text('Fazer doação', style: TextStyle(color: Colors.white70)),
            Text('Descobrir', style: TextStyle(color: Colors.white70)),
          ],
        ),

        // Coluna: Ajuda
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ajuda',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text('Fale conosco', style: TextStyle(color: Colors.white70)),
            Text('Dúvidas frequentes', style: TextStyle(color: Colors.white70)),
            Text('Atualizações', style: TextStyle(color: Colors.white70)),
          ],
        ),

        // Coluna: Redes sociais
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Redes sociais',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSocialIcon(FontAwesomeIcons.facebook),
                const SizedBox(width: 12),
                _buildSocialIcon(FontAwesomeIcons.instagram),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Layout empilhado para telas pequenas (mobile)
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo e nome
        Row(
          children: [
            Image.asset('assets/logo.png', width: 36, height: 36),
            const SizedBox(width: 8),
            const Text(
              'Nação Nutrida',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Ações sociais
        const Text(
          'Ações sociais',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Criar', style: TextStyle(color: Colors.white70)),
        const Text('Fazer doação', style: TextStyle(color: Colors.white70)),
        const Text('Descobrir', style: TextStyle(color: Colors.white70)),

        const SizedBox(height: 24),

        // Ajuda
        const Text(
          'Ajuda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Fale conosco', style: TextStyle(color: Colors.white70)),
        const Text(
          'Dúvidas frequentes',
          style: TextStyle(color: Colors.white70),
        ),
        const Text('Atualizações', style: TextStyle(color: Colors.white70)),

        const SizedBox(height: 24),

        // Redes sociais
        const Text(
          'Redes sociais',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSocialIcon(FontAwesomeIcons.facebook),
            const SizedBox(width: 12),
            _buildSocialIcon(FontAwesomeIcons.instagram),
          ],
        ),
      ],
    );
  }

  static Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(50), width: 1),
      ),
      child: Center(child: FaIcon(icon, size: 18, color: Colors.white70)),
    );
  }
}
