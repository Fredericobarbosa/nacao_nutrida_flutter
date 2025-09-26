import 'package:flutter/material.dart';

class HeaderAuth extends StatelessWidget {
  final VoidCallback? onRightButtonPressed;
  final String rightText;
  final String rightButtonText;
  final bool showBackButton;

  const HeaderAuth({
    super.key,
    required this.rightText,
    required this.rightButtonText,
    this.onRightButtonPressed,
    this.showBackButton = false,
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
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF191929)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              _buildLogo(),
            ],
          ),
          RichText(
            text: TextSpan(
              text: '$rightText ',
              style: const TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
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

  Widget _buildLogo() {
    return Container(
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
    );
  }
}
