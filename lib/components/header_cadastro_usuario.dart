import 'package:flutter/material.dart';

class HeaderCadastroUsuario extends StatelessWidget {
  final String rightText;
  final String rightButtonText;
  final VoidCallback? onRightButtonPressed;

  const HeaderCadastroUsuario({
    super.key,
    required this.rightText,
    required this.rightButtonText,
    this.onRightButtonPressed,
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
              IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF027ba1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: Image.asset('assets/logo.png', width: 32, height: 32),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                rightText,
                style: const TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onRightButtonPressed,
                child: Text(
                  rightButtonText,
                  style: const TextStyle(
                    color: Color(0xFF027ba1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
