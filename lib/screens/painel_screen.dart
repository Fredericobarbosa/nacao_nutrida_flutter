import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/header_login.dart';
import '../models/campaign.dart';
import '../services/api_service.dart';
import '../config/api.dart';
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
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => loading = true);
    final api = ApiService(baseUrl: ApiConfig.baseUrl);

    try {
      // Buscar campanhas do usuário
      try {
        final resp = await api.get('/campanhas/minhas');
        if (resp.statusCode == 200) {
          final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
          final List<Campaign> lista = data
              .map((e) => Campaign.fromJson(e as Map<String, dynamic>))
              .toList();
          setState(() => campanhas = lista);
        } else {
          // Não fatal: apenas log
          print('Erro ao buscar campanhas: ${resp.statusCode} ${resp.body}');
        }
      } catch (e) {
        print('Erro ao conectar para campanhas: $e');
      }

      // Buscar doações do usuário
      try {
        final resp2 = await api.get('/doacoes/minhas');
        if (resp2.statusCode == 200) {
          final List<dynamic> data2 = jsonDecode(resp2.body) as List<dynamic>;
          final List<DonationByCampaign> lista2 = data2
              .map((e) => DonationByCampaign.fromJson(e as Map<String, dynamic>))
              .toList();
          setState(() => doacoes = lista2);
        } else {
          print('Erro ao buscar doacoes: ${resp2.statusCode} ${resp2.body}');
        }
      } catch (e) {
        print('Erro ao conectar para doacoes: $e');
      }
    } finally {
      setState(() => loading = false);
    }
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