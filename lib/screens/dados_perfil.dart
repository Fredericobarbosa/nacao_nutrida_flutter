import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../components/profile_avatar.dart';
import '../components/profile_field.dart';
import '../components/header_login.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import 'dart:convert';
// image picker and intl removed to avoid adding new dependencies here

class DadosPerfil extends StatefulWidget {
  DadosPerfil({super.key});

  @override
  State<DadosPerfil> createState() => _DadosPerfilState();
}

class _DadosPerfilState extends State<DadosPerfil> {
  UserModel? user;
  bool _loading = true;
  String? _error;
  String? _cpf;
  // no avatar ImageProvider here (ProfileAvatar currently only supports size)

  @override
  void initState() {
    super.initState();
    _fetchPerfil();
  }

  Future<void> _fetchPerfil() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final api = ApiService(baseUrl: ApiConfig.baseUrl);
    try {
      final resp = await api.get('/perfil');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        setState(() {
          user = UserModel(
            name: data['nm_usuario'] as String? ?? '',
            email: data['cd_email_usuario'] as String? ?? '',
            phone: data['nr_celular_usuario'] as String? ?? '',
            state: data['sg_estado_usuario'] as String? ?? '',
            city: data['nm_cidade_usuario'] as String? ?? '',
            birthDate: (data['dt_nascimento_usuario'] as String?) ?? '',
          );
          _cpf =
              (data['nr_cpf_usuario'] as String?) ??
              (data['ch_cpf_usuario'] as String?) ??
              '';
        });
      } else {
        setState(() {
          _error = 'Falha ao buscar perfil: ${resp.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao conectar com backend: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _formatBirthDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      // Try parsing common formats: full ISO or yyyy-MM-dd
      DateTime dt = DateTime.parse(raw);
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString();
      return '$day/$month/$year';
    } catch (_) {
      // If it's already in dd/MM/yyyy or another format, try a simple heuristics
      final parts = raw.split('-');
      if (parts.length == 3) {
        // assume yyyy-MM-dd
        final y = parts[0];
        final m = parts[1].padLeft(2, '0');
        final d = parts[2].padLeft(2, '0');
        return '$d/$m/$y';
      }
      // fallback: return raw
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderLogin(
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _loading
                    ? const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _error != null
                    ? SizedBox(height: 200, child: Center(child: Text(_error!)))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              const Text(
                                'Meus dados',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const ProfileAvatar(size: 100),
                              const SizedBox(height: 20),

                              // Campos de informação abaixo do avatar
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Nome:',
                                      value: user?.name ?? '',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ProfileField(
                                      label: 'CPF:',
                                      value: _cpf ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Email:',
                                      value: user?.email ?? '',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Celular:',
                                      value: user?.phone ?? '',
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Estado:',
                                      value: user?.state ?? '',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Cidade:',
                                      value: user?.city ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileField(
                                      label: 'Data de nascimento:',
                                      value: _formatBirthDate(user?.birthDate),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.of(
                                context,
                              ).pushNamed('/editar-perfil');
                              if (result == true) {
                                // reload profile after successful save
                                _fetchPerfil();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              backgroundColor: const Color(0xFFF3F4F6),
                              foregroundColor: const Color(0xFF0B66FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Editar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
