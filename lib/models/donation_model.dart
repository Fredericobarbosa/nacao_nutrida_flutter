class Donation {
  final String id;
  final int quantity;
  final String donorName;
  final String donorCity;
  final String donorState;
  final String foodName;

  Donation({
    required this.id,
    required this.quantity,
    required this.donorName,
    required this.donorCity,
    required this.donorState,
    required this.foodName,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id_doacao'] ?? '',
      quantity: json['quantidade_doada'] ?? 0,
      donorName: json['doador']?['nome'] ?? '',
      donorCity: json['doador']?['cidade'] ?? '',
      donorState: json['doador']?['estado'] ?? '',
      foodName: json['alimento']?['nome'] ?? '',
    );
  }
}
