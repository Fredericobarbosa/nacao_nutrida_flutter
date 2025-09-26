import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class CadastroCampanhaForm extends StatefulWidget {
  const CadastroCampanhaForm({super.key});

  @override
  State<CadastroCampanhaForm> createState() => _CadastroCampanhaFormState();
}

class _CadastroCampanhaFormState extends State<CadastroCampanhaForm> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController dataEncerramentoController =
      TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  List<Map<String, dynamic>> alimentos = [
    {'tipo': 'Sólido', 'nome': '', 'quantidade': '', 'unidade': 'Kg'},
  ];
  List<String> imagens = [];

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
            _buildFormField(
              'Título',
              controller: tituloController,
              hintText: 'Sopão para moradores de rua',
            ),
            const SizedBox(height: 16),
            _buildFormField(
              'Data de encerramento',
              controller: dataEncerramentoController,
              hintText: '30/04/2021',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              'Estado',
              controller: estadoController,
              hintText: 'SP',
            ),
            const SizedBox(height: 16),
            _buildFormField(
              'Cidade',
              controller: cidadeController,
              hintText: 'FRANCA',
            ),
            const SizedBox(height: 24),
            const Text(
              'Alimentos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...alimentos.asMap().entries.map((entry) {
              int idx = entry.key;
              var alimento = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: alimento['tipo'],
                          items: ['Sólido', 'Líquido']
                              .map(
                                (tipo) => DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() => alimento['tipo'] = val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Tipo do alimento',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: alimento['nome'],
                          decoration: const InputDecoration(
                            labelText: 'Alimento',
                          ),
                          onChanged: (val) => alimento['nome'] = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: alimento['quantidade'],
                          decoration: const InputDecoration(
                            labelText: 'Quantidade',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => alimento['quantidade'] = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: alimento['unidade'],
                          items: ['Kg', 'L', 'Unidade']
                              .map(
                                (u) =>
                                    DropdownMenuItem(value: u, child: Text(u)),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() => alimento['unidade'] = val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Unidade',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (alimentos.length > 1)
                        TextButton(
                          onPressed: () {
                            setState(() => alimentos.removeAt(idx));
                          },
                          child: const Text('Remover'),
                        ),
                    ],
                  ),
                  const Divider(),
                ],
              );
            }),
            TextButton(
              onPressed: () {
                setState(() {
                  alimentos.add({
                    'tipo': 'Sólido',
                    'nome': '',
                    'quantidade': '',
                    'unidade': 'Kg',
                  });
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
            ),
            const SizedBox(height: 16),
            const Text(
              'Adicionar imagem de capa (máximo: 5 imagens)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ...imagens.map(
                  (img) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: img.isNotEmpty
                            ? Image.network(img, fit: BoxFit.cover)
                            : null,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => imagens.remove(img));
                        },
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                if (imagens.length < 5)
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );
                      if (result != null && result.files.isNotEmpty) {
                        Uint8List? fileBytes = result.files.first.bytes;
                        if (fileBytes != null) {
                          String base64Image =
                              'data:image/png;base64,${base64Encode(fileBytes)}';
                          setState(() => imagens.add(base64Image));
                        }
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(child: Text('Upload')),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode salvar os dados
                Navigator.of(context).pushNamed('/descobrir');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF064789),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Cadastrar Campanha'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label, {
    TextEditingController? controller,
    String? hintText,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF191929), fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: hintText),
                maxLines: maxLines,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: Color(0xFF8d8d8d)),
            ],
          ],
        ),
      ],
    );
  }
}
