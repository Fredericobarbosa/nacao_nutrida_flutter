import 'package:flutter/material.dart';

class TabsSelector extends StatelessWidget {
  final String selected;
  final VoidCallback onCampanhas;
  final VoidCallback onDoacoes;

  const TabsSelector({
    super.key,
    required this.selected,
    required this.onCampanhas,
    required this.onDoacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTab('Minhas campanhas', 'campanhas', onCampanhas),
        const SizedBox(height: 20), // Espaço vertical entre os botões
        _buildTab('Minhas doações', 'doacoes', onDoacoes),
      ],
    );
  }

  Widget _buildTab(String label, String value, VoidCallback onPressed) {
    final bool active = selected == value;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            active ? const Color(0xFF1976d2) : const Color(0xFFE3EAF7),
        foregroundColor:
            active ? Colors.white : const Color(0xFF1976d2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
