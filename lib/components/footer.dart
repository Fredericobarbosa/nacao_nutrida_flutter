import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF191929),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ações sociais',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Plataforma para\nações sociais',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset('assets/logo.png', width: 32, height: 32),
              const SizedBox(width: 8),
              const Text(
                'Ajuda',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Acompanhe nossas\nredes sociais',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSocialIcon(
                icon: FontAwesomeIcons.facebook,
                onTap: () {
                  // TODO: Implementar navegação para Facebook
                },
              ),
              const SizedBox(width: 12),
              _buildSocialIcon(
                icon: FontAwesomeIcons.instagram,
                onTap: () {
                  // TODO: Implementar navegação para Instagram
                },
              ),
              const SizedBox(width: 12),
              _buildSocialIcon(
                icon: FontAwesomeIcons.twitter,
                onTap: () {
                  // TODO: Implementar navegação para Twitter
                },
              ),
              const SizedBox(width: 12),
              _buildSocialIcon(
                icon: FontAwesomeIcons.linkedin,
                onTap: () {
                  // TODO: Implementar navegação para LinkedIn
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Center(child: FaIcon(icon, size: 16, color: Colors.white70)),
      ),
    );
  }
}
