class Campaign {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String status; // 'ativa', 'concluida', 'pausada'
  final Map<String, int>
  metaAlimentos; // alimento -> quantidade necessária (kg)
  final Map<String, int>
  alimentosArrecadados; // alimento -> quantidade arrecadada (kg)
  final List<String> tiposAlimento;
  final String responsavel;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final String endereco;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
    required this.metaAlimentos,
    required this.alimentosArrecadados,
    required this.tiposAlimento,
    required this.responsavel,
    required this.dataInicio,
    this.dataFim,
    required this.endereco,
  });

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
