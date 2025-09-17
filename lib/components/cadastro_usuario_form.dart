import 'package:flutter/material.dart';

class CadastroUsuarioForm extends StatelessWidget {
  const CadastroUsuarioForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Cadastro do usuário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191929),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Novos usuários',
              style: TextStyle(
                color: Color(0xFF8d8d8d),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      'Pessoa física',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      'Empresa/Estabelecimento',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFormField('CPF'),
            const SizedBox(height: 16),
            _buildFormField('Email', isEmail: true),
            const SizedBox(height: 16),
            _buildFormField('Data de nascimento'),
            const SizedBox(height: 16),
            _buildFormField('Celular'),
            const SizedBox(height: 16),
            _buildFormField('Confirmação de senha', isPassword: true),
            const SizedBox(height: 16),
            _buildFormField('Cidade'),
            const SizedBox(height: 16),
            _buildFormField('Senha', isPassword: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF064789),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label,
      {bool isPassword = false, bool isEmail = false}) {
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
          obscureText: isPassword,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        ),
      ],
    );
  }
}