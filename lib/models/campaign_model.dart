class Campaign {
  final String id;
  final String title;
  final String description;
  final String image;
  final List<String> foods;
  final int? remainingDays;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.foods,
    this.remainingDays,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? '',
      title: json['nm_titulo_campanha'] ?? '',
      description: json['ds_acao_campanha'] ?? '',
      image: json['cd_imagem_campanha'] ?? '',
      foods:
          (json['alimentos'] as List?)
              ?.map((a) => a['nm_alimento'] as String)
              .toList() ??
          [],
      remainingDays: json['dias_restantes'],
    );
  }
}
