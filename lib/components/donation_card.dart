import 'package:flutter/material.dart';
import '../models/donation_campaign_model.dart';

class DonationCard extends StatelessWidget {
  final DonationByCampaign donation;

  const DonationCard({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    final campaign = donation.campaign;
    return Align(
      alignment: Alignment.center, 
      child: SizedBox(
        width: 400, 
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976d2),
                  ),
                ),
                const SizedBox(height: 4),
                Text("Cidade: ${campaign.city} - ${campaign.state}"),
                const SizedBox(height: 8),
                const Text(
                  "Alimentos doados:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976d2),
                  ),
                ),
                const SizedBox(height: 6),
                ...donation.foods.map(
                  (f) => Text(
                    "• ${f.name} - ${f.quantity}${f.donationId != null ? ' (ID: ${f.donationId})' : ''}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
