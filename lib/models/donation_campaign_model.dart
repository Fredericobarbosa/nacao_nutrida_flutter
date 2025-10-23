class DonationByCampaign {
  final CampaignInfo campaign;
  final List<FoodDonation> foods;

  DonationByCampaign({required this.campaign, required this.foods});

  factory DonationByCampaign.fromJson(Map<String, dynamic> json) {
    return DonationByCampaign(
      campaign: CampaignInfo.fromJson(json['campanha']),
      foods: (json['alimentos_doados'] as List?)
              ?.map((a) => FoodDonation.fromJson(a))
              .toList() ??
          [],
    );
  }
}

class CampaignInfo {
  final String id;
  final String name;
  final String city;
  final String state;

  CampaignInfo({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
  });

  factory CampaignInfo.fromJson(Map<String, dynamic> json) {
    return CampaignInfo(
      id: json['id'] ?? '',
      name: json['nome'] ?? '',
      city: json['cidade'] ?? '',
      state: json['estado'] ?? '',
    );
  }
}

class FoodDonation {
  final String id;
  final String name;
  final int quantity;
  final String? donationId;

  FoodDonation({
    required this.id,
    required this.name,
    required this.quantity,
    this.donationId,
  });

  factory FoodDonation.fromJson(Map<String, dynamic> json) {
    return FoodDonation(
      id: json['alimento']?['id'] ?? '',
      name: json['alimento']?['nome'] ?? '',
      quantity: json['quantidade'] ?? 0,
      donationId: json['id_doacao'],
    );
  }
}
