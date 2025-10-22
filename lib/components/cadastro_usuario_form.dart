import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

class CadastroUsuarioForm extends StatefulWidget {
  const CadastroUsuarioForm({super.key});

  @override
  State<CadastroUsuarioForm> createState() => _CadastroUsuarioFormState();
}

class _CadastroUsuarioFormState extends State<CadastroUsuarioForm> {
  bool isPessoaFisica = true;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _nascimentoController = TextEditingController();
  final _celularController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();
  bool _loading = false;
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _celMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
                style: TextStyle(color: Color(0xFF8d8d8d), fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPessoaFisica = true;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isPessoaFisica
                            ? const Color(0xFFffc436)
                            : null,
                      ),
                      child: const Text(
                        'Pessoa física',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPessoaFisica = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: !isPessoaFisica
                            ? const Color(0xFFffc436)
                            : null,
                      ),
                      child: const Text(
                        'Empresa/Estabelecimento',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormField(
                isPessoaFisica ? 'Nome completo' : 'Nome da empresa',
                controller: _nomeController,
              ),
              const SizedBox(height: 16),
              isPessoaFisica
                  ? _buildFormField(
                      'CPF',
                      controller: _cpfCnpjController,
                      inputFormatters: [_cpfMask],
                    )
                  : _buildFormField(
                      'CNPJ',
                      controller: _cpfCnpjController,
                      inputFormatters: [_cnpjMask],
                    ),
              const SizedBox(height: 16),
              _buildFormField(
                'Email',
                isEmail: true,
                controller: _emailController,
                hintText: 'exemplo@email.com',
              ),
              const SizedBox(height: 16),
              if (isPessoaFisica)
                _buildFormField(
                  'Data de nascimento',
                  controller: _nascimentoController,
                  inputFormatters: [_dateMask],
                ),
              if (isPessoaFisica) const SizedBox(height: 16),
              _buildFormField(
                'Celular',
                controller: _celularController,
                inputFormatters: [_celMask],
              ),
              const SizedBox(height: 16),
              _buildFormField('Cidade', controller: _cidadeController),
              const SizedBox(height: 16),
              _buildFormField('Estado', controller: _estadoController),
              const SizedBox(height: 16),
              _buildFormField(
                'Senha',
                isPassword: true,
                controller: _senhaController,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                'Confirmação de senha',
                isPassword: true,
                controller: _confirmSenhaController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF064789),
                    foregroundColor: Colors.white,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final senha = _senhaController.text;
    final confirm = _confirmSenhaController.text;
    if (senha != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Senhas não coincidem')));
      return;
    }

    setState(() => _loading = true);
    final api = ApiService(baseUrl: ApiConfig.baseUrlAndroid);

    final userInfos = <String, dynamic>{
      'tipo_usuario': isPessoaFisica ? 'pf' : 'pj',
      'nm_usuario': _nomeController.text.trim(),
      'cd_email_usuario': _emailController.text.trim(),
      'nr_celular_usuario': _celularController.text.trim(),
      'cd_senha_usuario': senha,
      'sg_estado_usuario': _estadoController.text.trim(),
      'nm_cidade_usuario': _cidadeController.text.trim(),
      // Adicionamos apenas quando houver valor (evita enviar null ao backend)
      if (isPessoaFisica)
        'dt_nascimento_usuario': _nascimentoController.text.trim(),
      if (isPessoaFisica) 'ch_cpf_usuario': _cpfCnpjController.text.trim(),
      if (!isPessoaFisica) 'ch_cnpj_usuario': _cpfCnpjController.text.trim(),
    };

    try {
      final path = '/usuarioCadastro';
      final payload = {'user_infos': userInfos};
      // Logs para depuração
      print(
        '>>> Cadastrando usuário - POST ' + ApiConfig.baseUrlAndroid + path,
      );
      print('>>> Payload: ' + jsonEncode(payload));

      final resp = await api.post(path, payload);

      print('<<< Response status: ${resp.statusCode}');
      print('<<< Response body: ${resp.body}');

      if (resp.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso')),
        );
        Navigator.of(context).pushNamed('/login');
      } else {
        String msg = 'Erro no cadastro';
        try {
          final body = jsonDecode(resp.body);
          msg = (body['message'] ?? body['error'] ?? msg).toString();
        } catch (_) {
          msg = 'Erro no cadastro (resposta inválida)';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e, st) {
      // Log detalhado de exceção
      print('!!! Exception ao cadastrar usuário: $e');
      print(st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _nascimentoController.dispose();
    _celularController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    super.dispose();
  }

  Widget _buildFormField(
    String label, {
    bool isPassword = false,
    bool isEmail = false,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    String? hintText, // novo parâmetro
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF191929), fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatters,
          obscureText: isPassword,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Campo obrigatório';
            }
            if (isEmail) {
              final v = value.trim();
              if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v)) {
                return 'Email inválido';
              }
            }
            if (label == 'CPF' && value.isNotEmpty) {
              // Validação simples de CPF (apenas formato/dígitos)
              final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits.length != 11) return 'CPF inválido';
            }
            if (label == 'CNPJ' && value.isNotEmpty) {
              final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits.length != 14) return 'CNPJ inválido';
            }
            if (label == 'Celular' && value.isNotEmpty) {
              final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits.length < 10) return 'Telefone inválido';
            }
            if (label == 'Data de nascimento' && value.isNotEmpty) {
              // Valida formato dd/MM/yyyy e checa data plausível
              final v = value.trim();
              final parts = v.split('/');
              if (parts.length != 3) return 'Data inválida';
              final d = int.tryParse(parts[0]);
              final m = int.tryParse(parts[1]);
              final y = int.tryParse(parts[2]);
              if (d == null || m == null || y == null) return 'Data inválida';
              try {
                final dt = DateTime(y, m, d);
                // verifica se a data foi construída corretamente
                if (dt.day != d || dt.month != m || dt.year != y)
                  return 'Data inválida';
                final now = DateTime.now();
                if (dt.isAfter(now)) return 'Data no futuro';
                final age =
                    now.year -
                    dt.year -
                    ((now.month < dt.month ||
                            (now.month == dt.month && now.day < dt.day))
                        ? 1
                        : 0);
                if (age < 0 || age > 130) return 'Data de nascimento inválida';
              } catch (_) {
                return 'Data inválida';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
