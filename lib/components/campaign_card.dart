import 'package:flutter/material.dart';
import '../models/campaign.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onManage;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              campaign.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              campaign.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976d2),
              ),
            ),
            const SizedBox(height: 8),
            Text(campaign.description, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              "Alimentos: ${campaign.tiposAlimento.join(', ')}",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onManage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF0B66FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Gerenciar campanha"),
            ),
          ],
        ),
      ),
    );
  }
}
