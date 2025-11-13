

class Campaign {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String status; // 'ativa', 'concluida'
  final Map<String, int> metaAlimentos; // alimento -> quantidade necessária
  final Map<String, int> alimentosArrecadados; // alimento -> quantidade arrecadada
  final List<String> tiposAlimento; // Lista de nomes de alimentos
  final String responsavel;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final String endereco;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = "assets/generic_nn.jpg",
    required this.status,
    required this.metaAlimentos,
    required this.alimentosArrecadados,
    required this.tiposAlimento,
    required this.responsavel,
    required this.dataInicio,
    this.dataFim,
    required this.endereco,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    final List<dynamic> alimentosList = json['alimentos'] as List? ?? [];
    
    final Map<String, int> meta = {};
    final Map<String, int> arrecadado = {};
    final List<String> tipos = [];

    for (var item in alimentosList) {
      final String? nome = item['nm_alimento'] as String?;
      final int metaQty = (item['qt_alimento_meta'] as num?)?.toInt() ?? 0;
      final int doadoQty = (item['qt_alimento_doado'] as num?)?.toInt() ?? 0;

      if (nome != null) {
        tipos.add(nome);
        meta[nome] = metaQty;
        arrecadado[nome] = doadoQty;
      }
    }

    final String cidade = json['nm_cidade_campanha'] as String? ?? 'N/D';
    final String estado = json['sg_estado_campanha'] as String? ?? '';
    final String enderecoCompleto = '$cidade, $estado';

    final String statusCalculado = (json['fg_campanha_ativa'] as bool? ?? false) ? 'ativa' : 'concluida';

    return Campaign(
      id: json['id'] as String? ?? '',
      title: json['nm_titulo_campanha'] as String? ?? 'Título indisponível',
      description: json['ds_acao_campanha'] as String? ?? 'Sem descrição',
      imageUrl: "assets/generic_nn.jpg",
      status: statusCalculado,
      metaAlimentos: meta,
      alimentosArrecadados: arrecadado,
      tiposAlimento: tipos,
      responsavel: json['nm_usuario'] as String? ?? 'Responsável não informado',
      
      dataInicio: DateTime.parse(json['ts_criacao_campanha'] as String),
      
      dataFim: json['dt_encerramento_campanha'] != null
          ? DateTime.parse(json['dt_encerramento_campanha'] as String)
          : null,
          
      endereco: enderecoCompleto,
    );
  }

  int get totalMetaAlimentos =>
      metaAlimentos.values.fold(0, (sum, qty) => sum + qty);
  int get totalAlimentosArrecadados =>
      alimentosArrecadados.values.fold(0, (sum, qty) => sum + qty);

  double get percentualArrecadado => totalMetaAlimentos > 0
      ? (totalAlimentosArrecadados / totalMetaAlimentos) * 100
      : 0;

  String get statusFormatado {
    switch (status.toLowerCase()) {
      case 'ativa':
        return 'Ativa';
      case 'concluida':
        return 'Concluída';
      case 'pausada':
        return 'Pausada';
      default:
        return 'Ativa';
    }
  }
}