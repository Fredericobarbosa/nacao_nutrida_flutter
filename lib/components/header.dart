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
          Row(
            children: [
              // Ícone de voltar
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF191929)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              if (showLogo) _buildLogoWithText(leftText),
            ],
          ),
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
    );
  }

  Widget _buildLogoWithText(String? text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFffc436),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: Color(0xFF191929),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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