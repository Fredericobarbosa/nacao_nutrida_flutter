import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String? leftText;
  final String rightText;
  final String rightButtonText;
  final VoidCallback? onRightButtonPressed;
  final bool showLogo;

  const Header({
    super.key,
    this.leftText,
    required this.rightText,
    required this.rightButtonText,
    this.onRightButtonPressed,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showLogo)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
              child: _buildLogoWithText(leftText),
            ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: const Text(
                  'Página Inicial',
                  style: TextStyle(
                    color: Color(0xFF027ba1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/descobrir');
                },
                child: const Text(
                  'Campanhas',
                  style: TextStyle(
                    color: Color(0xFF027ba1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cadastrar-campanha');
                },
                child: const Text(
                  'Criar',
                  style: TextStyle(
                    color: Color(0xFF027ba1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // Ajustes: pode ser ajustado para a rota correta
                  Navigator.of(context).pushNamed('/ajustes');
                },
                child: const Text(
                  'Ajustes',
                  style: TextStyle(
                    color: Color(0xFF027ba1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              RichText(
                text: TextSpan(
                  text: '$rightText ',
                  style: const TextStyle(
                    color: Color(0xFF8d8d8d),
                    fontSize: 14,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: onRightButtonPressed,
                        child: Text(
                          rightButtonText,
                          style: const TextStyle(
                            color: Color(0xFF027ba1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoWithText(String? text) {
    return Row(
      children: [
        Image.asset('assets/logo.png', width: 32, height: 32),
        if (text != null) ...[
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF191929),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
