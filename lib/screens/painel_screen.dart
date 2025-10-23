import 'package:flutter/material.dart';
import '../components/header_login.dart';
import '../models/campaign_model.dart';
import '../models/donation_campaign_model.dart';
import '../components/campaign_card.dart';
import '../components/donation_card.dart';
import '../components/tabs_selector.dart';

class PainelScreen extends StatefulWidget {
  const PainelScreen({super.key});

  @override
  State<PainelScreen> createState() => _PainelScreenState();
}

class _PainelScreenState extends State<PainelScreen> {
  String aba = 'campanhas';
  bool loading = false;

  List<Campaign> campanhas = [];
  List<DonationByCampaign> doacoes = [];

  @override
  void initState() {
    super.initState();
    _fetchCampanhas();
  }

  Future<void> _fetchCampanhas() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // simulação
    setState(() {
      campanhas = [
        Campaign(
          id: '1',
          title: 'Campanha Solidária',
          description: 'Ajude famílias em necessidade.',
          image: 'https://picsum.photos/200/140',
          foods: ['Arroz', 'Feijão', 'Macarrão'],
        ),
      ];
      doacoes = [
        DonationByCampaign(
          campaign: CampaignInfo(
            id: '1',
            name: 'Campanha Solidária',
            city: 'Franca',
            state: 'SP',
          ),
          foods: [
            FoodDonation(id: '1', name: 'Arroz', quantity: 5),
            FoodDonation(id: '2', name: 'Feijão', quantity: 2),
          ],
        ),
      ];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // **ALTERAÇÃO AQUI: Passando showBack: true para o HeaderLogin**
      appBar: const HeaderLogin(showBack: true),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Painel',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TabsSelector(
                    selected: aba,
                    onCampanhas: () => setState(() => aba = 'campanhas'),
                    onDoacoes: () => setState(() => aba = 'doacoes'),
                  ),

                  const SizedBox(height: 24),

                  if (aba == 'campanhas')
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: campanhas
                          .map(
                            (c) => CampaignCard(campaign: c, onManage: () {}),
                          )
                          .toList(),
                    )
                  else
                    Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: doacoes
                            .map((d) => DonationCard(donation: d))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}