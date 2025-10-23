import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../components/header_login.dart';
import '../components/profile_avatar.dart';
import '../components/profile_field.dart';
import '../services/api_service.dart';
import '../config/api.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({Key? key}) : super(key: key);

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  bool _loading = true;
  bool _editing = true; // open in edit mode
  String? _error;

  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _dataNascCtrl = TextEditingController();
  // estados/cidades data
  List<Map<String, dynamic>> _estadosCidades = [];
  String? _selectedEstado;
  String? _selectedCidade;

  @override
  void initState() {
    super.initState();
    _fetchPerfil();
    _fetchEstadosCidades();
  }

  Future<void> _fetchPerfil() async {
    setState(() => _loading = true);
    final api = ApiService(baseUrl: ApiConfig.baseUrlAndroid);
    try {
      final resp = await api.get('/perfil');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _nomeCtrl.text = data['nm_usuario'] ?? '';
          _cpfCtrl.text =
              data['nr_cpf_usuario'] ?? data['ch_cpf_usuario'] ?? '';
          _emailCtrl.text = data['cd_email_usuario'] ?? '';
          _celularCtrl.text = data['nr_celular_usuario'] ?? '';
          _selectedEstado = (data['sg_estado_usuario'] ?? '').toString();
          _selectedCidade = (data['nm_cidade_usuario'] ?? '').toString();
          _dataNascCtrl.text = _formatarData(data['dt_nascimento_usuario']);
        });
      } else {
        _error = 'Erro ao carregar perfil';
      }
    } catch (e) {
      _error = 'Falha ao conectar com o servidor';
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchEstadosCidades() async {
    final api = ApiService(baseUrl: ApiConfig.baseUrlAndroid);
    try {
      final resp = await api.get('/estadosCidades');
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        setState(() {
          _estadosCidades = data.cast<Map<String, dynamic>>();
          if ((_selectedEstado == null || _selectedEstado!.isEmpty) &&
              _estadosCidades.isNotEmpty) {
            _selectedEstado =
                (_estadosCidades[0]['sigla'] ?? _estadosCidades[0]['sg_estado'])
                    ?.toString();
          }
        });
      }
    } catch (_) {}
  }

  String _formatarData(String? data) {
    if (data == null || data.isEmpty) return '';
    try {
      final d = DateTime.parse(data);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return data;
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final api = ApiService(baseUrl: ApiConfig.baseUrlAndroid);
    final payload = {
      'nm_usuario': _nomeCtrl.text,
      'nr_celular_usuario': _celularCtrl.text,
      'sg_estado_usuario': _selectedEstado ?? _estadoCtrl.text,
      'nm_cidade_usuario': _selectedCidade ?? _cidadeCtrl.text,
    };

    try {
      final resp = await api.put('/usuario/perfil', body: payload);
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        if (mounted) Navigator.of(context).pop(true);
      } else {
        _error = 'Erro ao salvar alterações';
      }
    } catch (_) {
      _error = 'Falha ao conectar com o servidor';
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderLogin(showBack: true, onBack: () => Navigator.pop(context)),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: math.min(MediaQuery.of(context).size.width * 0.95, 600),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _loading
                    ? const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _error != null
                    ? Text(_error!, style: const TextStyle(color: Colors.red))
                    : Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Meus dados',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Avatar
                            const ProfileAvatar(size: 100),
                            const SizedBox(height: 20),

                            // Nome e CPF
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Nome:',
                                    controller: _nomeCtrl,
                                    enabled: _editing,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildField(
                                    label: 'CPF:',
                                    controller: _cpfCtrl,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Email e Celular
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Email:',
                                    controller: _emailCtrl,
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildField(
                                    label: 'Celular:',
                                    controller: _celularCtrl,
                                    enabled: _editing,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Estado e Cidade (dropdowns when editing)
                            Row(
                              children: [
                                Expanded(
                                  child: _editing
                                      ? DropdownButtonFormField<String>(
                                          value: _selectedEstado,
                                          items: _estadosCidades
                                              .map((e) {
                                                final label =
                                                    ((e['sigla'] ??
                                                                e['sg_estado']) ??
                                                            '')
                                                        .toString();
                                                return label.isNotEmpty
                                                    ? DropdownMenuItem<String>(
                                                        value: label,
                                                        child: Text(label),
                                                      )
                                                    : null;
                                              })
                                              .where((it) => it != null)
                                              .cast<DropdownMenuItem<String>>()
                                              .toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Estado:',
                                          ),
                                          onChanged: (v) => setState(() {
                                            _selectedEstado = v;
                                            _selectedCidade = null;
                                          }),
                                        )
                                      : ProfileField(
                                          label: 'Estado:',
                                          value: _selectedEstado ?? '',
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _editing
                                      ? DropdownButtonFormField<String>(
                                          value: _selectedCidade,
                                          items: (() {
                                            List<dynamic> cidades = [];
                                            try {
                                              final found = _estadosCidades
                                                  .firstWhere(
                                                    (e) =>
                                                        (((e['sigla'] ??
                                                                    e['sg_estado']) ??
                                                                '')
                                                            .toString() ==
                                                        (_selectedEstado ??
                                                            '')),
                                                    orElse: () => {},
                                                  );
                                              if (found.containsKey(
                                                'cidades',
                                              )) {
                                                final maybe = found['cidades'];
                                                if (maybe is List)
                                                  cidades = maybe;
                                                else if (maybe is String)
                                                  cidades = [maybe];
                                              }
                                            } catch (_) {
                                              cidades = [];
                                            }
                                            return cidades
                                                .map(
                                                  (c) =>
                                                      DropdownMenuItem<String>(
                                                        value: c.toString(),
                                                        child: Text(
                                                          c.toString(),
                                                        ),
                                                      ),
                                                )
                                                .toList();
                                          })(),
                                          decoration: const InputDecoration(
                                            labelText: 'Cidade:',
                                          ),
                                          onChanged: (v) => setState(
                                            () => _selectedCidade = v,
                                          ),
                                        )
                                      : ProfileField(
                                          label: 'Cidade:',
                                          value: _selectedCidade ?? '',
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Data de nascimento
                            _buildField(
                              label: 'Data de nascimento:',
                              controller: _dataNascCtrl,
                              enabled: false,
                            ),
                            const SizedBox(height: 30),

                            // Botão Editar / Salvar
                            ElevatedButton(
                              onPressed: _loading
                                  ? null
                                  : () {
                                      if (_editing) {
                                        _salvarAlteracoes();
                                      } else {
                                        setState(() => _editing = true);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B66FF),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(120, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                _editing ? 'Salvar' : 'Editar',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
