import 'package:flutter/material.dart';

class HeaderInicial extends StatelessWidget {
  final String? leftText;
  final String? rightText;
  final String? rightButtonText;
  final VoidCallback? onRightButtonPressed;
  final bool showLogo;

  const HeaderInicial({
    super.key,
    this.leftText,
    this.rightText,
    this.rightButtonText,
    this.onRightButtonPressed,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showLogo) _buildLogoWithText(leftText),
          if (rightText != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText!,
                  style: const TextStyle(
                    color: Color(0xFF191929),
                    fontSize: 14,
                  ),
                ),
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
