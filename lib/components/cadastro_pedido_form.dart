import 'package:flutter/material.dart';

class CadastroPedidoForm extends StatelessWidget {
  const CadastroPedidoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cadastrar campanha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191929),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dados iniciais',
              style: TextStyle(
                color: Color(0xFF191929),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _buildFormField('Título',
                hintText: 'Sopão para moradores de rua'),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data de encerramento',
                  style: TextStyle(
                    color: Color(0xFF191929),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '30/04/2021',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today,
                        size: 20, color: Color(0xFF8d8d8d)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Additional form fields would be added here
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF064789),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Cadastrar pedido'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, {String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF191929),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}