import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import 'package:intl/intl.dart'; 

class _Alimento {
  final String id;
  final String nome;

  _Alimento({required this.id, required this.nome});

  factory _Alimento.fromJson(Map<String, dynamic> json) {
    return _Alimento(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      nome: json['nm_alimento']?.toString() ?? json['nome']?.toString() ?? 'Sem nome',
    );
  }
}

class CadastroCampanhaForm extends StatefulWidget {
  const CadastroCampanhaForm({super.key});

  @override
  State<CadastroCampanhaForm> createState() => _CadastroCampanhaFormState();
}

class _CadastroCampanhaFormState extends State<CadastroCampanhaForm> {
  late final ApiService _api;
  final _formKey = GlobalKey<FormState>(); 

  // Controladores
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController dataEncerramentoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  // Os controladores de cidade e estado foram removidos, usaremos
  // _selectedEstado e _selectedCidade

  DateTime? _dataEncerramento;

  // --- LÓGICA DE ESTADOS E CIDADES ---
  List<Map<String, dynamic>> _estadosCidades = [];
  String? _selectedEstado;
  String? _selectedCidade;
  // --- FIM ---

  List<_Alimento> _alimentosDisponiveis = [];

  List<Map<String, dynamic>> alimentos = [
    {'id': null, 'quantidade': ''},
  ];

  bool _isLoading = false; 
  bool _pageLoading = true; 
  String _pageError = ''; // Para guardar erros de carregamento

  @override
  void initState() {
    super.initState();
    _api = ApiService(baseUrl: ApiConfig.baseUrl);
    _loadDependencies();
  }

  // CORREÇÃO: Agora carrega Alimentos E Estados/Cidades
  Future<void> _loadDependencies() async {
    setState(() {
      _pageLoading = true;
      _pageError = '';
    });
    try {
      // Carrega ambos em paralelo
      final responses = await Future.wait([
        _api.get('/alimentos'),
        _api.get('/estadosCidades') 
      ]);

      // --- Processa Alimentos ---
      final respAlimentos = responses[0];
      if (respAlimentos.statusCode == 200) {
        final data = jsonDecode(respAlimentos.body) as List;
        // CORREÇÃO: Lógica para "achatar" a lista aninhada do seu backend
        List<_Alimento> allAlimentos = [];
        for (var tipoGroup in data) { // 'tipoGroup' é {nm_tipo_alimento, alimentos: [...]}
          if (tipoGroup['alimentos'] is List) {
            final alimentosList = tipoGroup['alimentos'] as List;
            for (var alimentoJson in alimentosList) {
              allAlimentos.add(_Alimento.fromJson(alimentoJson as Map<String, dynamic>));
            }
          }
        }
        _alimentosDisponiveis = allAlimentos;
      } else {
         throw Exception('Falha ao carregar alimentos (Status: ${respAlimentos.statusCode})');
      }

      // --- Processa Estados e Cidades ---
      final respEstados = responses[1];
      if (respEstados.statusCode == 200) {
        final data = jsonDecode(respEstados.body) as List<dynamic>;
         _estadosCidades = data.map((e) => e as Map<String, dynamic>).toList();
         if (_estadosCidades.isNotEmpty) {
           _selectedEstado = _estadosCidades[0]['sg_estado'] as String;
         }
      } else {
         throw Exception('Falha ao carregar estados (Status: ${respEstados.statusCode})');
      }

    } catch (e) {
      debugPrint('Erro ao carregar dependências: $e');
      _pageError = e.toString();
    } finally {
      if (mounted) {
        setState(() { _pageLoading = false; });
      }
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    dataEncerramentoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataEncerramento ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataEncerramento) {
      setState(() {
        _dataEncerramento = picked;
        dataEncerramentoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pageLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando dependências...'),
          ],
        ),
      );
    }
    
    if (_pageError.isNotEmpty) {
       return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Erro ao carregar a página:\n$_pageError', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadDependencies, child: const Text('Tentar Novamente'))
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form( 
          key: _formKey,
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
              _buildFormField(
                'Título',
                controller: tituloController,
                hintText: 'Sopão para moradores de rua',
                validator: (val) => val == null || val.trim().isEmpty ? 'Título é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildFormField(
                    'Data de encerramento',
                    controller: dataEncerramentoController,
                    hintText: 'dd/mm/aaaa',
                    icon: Icons.calendar_today,
                    validator: (val) => _dataEncerramento == null ? 'Data é obrigatória' : null,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                items: _estadosCidades
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e['sg_estado'] as String,
                        child: Text(e['sg_estado'] as String),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedEstado = v;
                    _selectedCidade = null; // Reseta a cidade
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Estado',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obrigatório';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCidade,
                // Filtra as cidades baseado no estado selecionado
                items: (_estadosCidades.firstWhere(
                  (e) => e['sg_estado'] == _selectedEstado,
                  orElse: () => {'cidades': <String>[]},
                )['cidades'] as List<dynamic>)
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c,
                        child: Text(c),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedCidade = v;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cidade',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Campo obrigatório';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Alimentos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (_alimentosDisponiveis.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Não foi possível carregar os alimentos. Tente recarregar a página.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                ...alimentos.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var alimento = entry.value;
                  
                  _Alimento? selectedAlimento;
                  if (alimento['id'] != null) {
                    try {
                      selectedAlimento = _alimentosDisponiveis.firstWhere((a) => a.id == alimento['id']);
                    } catch (e) {
                      selectedAlimento = null; // O ID não está mais na lista
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      DropdownButtonFormField<_Alimento>(
                        value: selectedAlimento, // Agora é seguro
                        hint: const Text('Selecione um alimento'),
                        items: _alimentosDisponiveis
                            .map((alimento) => DropdownMenuItem(
                                  value: alimento,
                                  child: Text(alimento.nome),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => alimento['id'] = val?.id);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Alimento',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null ? 'Selecione um alimento' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: alimento['quantidade'],
                        decoration: const InputDecoration(
                          labelText: 'Meta (em Kg, L ou Unidade)',
                          hintText: 'Ex: 50',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => alimento['quantidade'] = val,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Quantidade é obrigatória';
                          if (int.tryParse(val) == null || int.parse(val) <= 0) return 'Deve ser um número positivo';
                          return null;
                        },
                      ),
                      if (alimentos.length > 1)
                        TextButton(
                          onPressed: () {
                            setState(() => alimentos.removeAt(idx));
                          },
                          child: const Text('Remover', style: TextStyle(color: Colors.red)),
                        ),
                      const Divider(),
                    ],
                  );
                }),
              
              // Só permite adicionar se a lista de alimentos foi carregada
              if (_alimentosDisponiveis.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      alimentos.add({'id': null, 'quantidade': ''});
                    });
                  },
                  child: const Text('+ Adicionar mais um alimento'),
                ),
              
              const SizedBox(height: 24),
              const Text(
                'Dados finais',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _buildFormField(
                'Descrição da campanha',
                controller: descricaoController,
                hintText:
                    'Insira a relevância por trás do seu pedido, descrevendo a ação social.',
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty ? 'Descrição é obrigatória' : null,
              ),
              
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _criarCampanha,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF064789),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Cadastrar Campanha'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _criarCampanha() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, corrija os erros no formulário.'), backgroundColor: Colors.orange,),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final perfilResp = await _api.get('/perfil');
      if (perfilResp.statusCode != 200) {
        setState(() { _isLoading = false; });
        throw Exception('Faça login para criar uma campanha');
      }
      final perfil = jsonDecode(perfilResp.body);
      final usuarioId = perfil['_id']?.toString() ?? perfil['id']?.toString();
      if (usuarioId == null) {
         throw Exception('ID do usuário não encontrado');
      }

      final alimentosPayload = alimentos.map((a) {
        return {
          'id': a['id'], 
          'qt_alimento_meta': int.parse(a['quantidade']), 
        };
      }).toList();

      final infosCampanha = {
          'usuario_id': usuarioId,
          'nm_titulo_campanha': tituloController.text.trim(),
          'dt_encerramento_campanha': _dataEncerramento!.toIso8601String(), 
          'nm_cidade_campanha': _selectedCidade,
          'sg_estado_campanha': _selectedEstado,
          'ds_acao_campanha': descricaoController.text.trim(),
          'cd_imagem_campanha': "", 
      };
      
      final payload = {
        'infos_campanha': infosCampanha,
        'alimentos_campanha': alimentosPayload,
      };

      final resp = await _api.post('/campanhas', payload);

      if (!mounted) return;

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campanha criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamed('/descobrir-campanha'); 
      } else {
         final errorBody = jsonDecode(resp.body);
         String errorMessage = 'Erro ao criar campanha';
         if (errorBody['message'] is String) {
           errorMessage = errorBody['message'];
         } else if (errorBody['message'] is List && errorBody['message'].isNotEmpty) {
           errorMessage = errorBody['message'][0]['message'] ?? 'Erro de validação';
         }

         throw Exception('Erro ${resp.statusCode}: $errorMessage');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Widget _buildFormField(
    String label, {
    TextEditingController? controller,
    String? hintText,
    int maxLines = 1,
    IconData? icon,
    String? Function(String?)? validator,
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
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(), 
            suffixIcon: icon != null ? Icon(icon, size: 20, color: Color(0xFF8d8d8d)) : null,
          ),
          maxLines: maxLines,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}