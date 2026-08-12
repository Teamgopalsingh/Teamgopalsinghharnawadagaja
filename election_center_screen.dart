import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/verification_badge.dart';

class ElectionCenterScreen extends StatefulWidget {
  const ElectionCenterScreen({Key? key}) : super(key: key);

  @override
  State<ElectionCenterScreen> createState() => _ElectionCenterScreenState();
}

class _ElectionCenterScreenState extends State<ElectionCenterScreen> {
  ElectionData? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await SupabaseService().fetchElectionData();
    setState(() {
      _data = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('election_center')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.royalGold))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DisclaimerBanner(),
                  const SizedBox(height: 16),

                  // Constituency Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _data!.constituencyName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.royalGold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.royalNavy,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.saffronAccent),
                                ),
                                child: Text(_data!.constituencyCode, style: const TextStyle(color: AppColors.saffronAccent, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.borderGold),
                          const SizedBox(height: 12),

                          // Aggregated Non-sensitive Elector Statistics
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('कुल मतदाता (अनुमानित)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text('${_data!.totalElectorate}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.white)),
                                  ],
                                ),
                              ),
                              Container(width: 1, height: 36, color: AppColors.borderGold),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('ऐतिहासिक मतदान %', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text('${_data!.historicalTurnoutPercent}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.successGreen)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text('📍 प्रमुख मतदान केंद्र (Polling Stations)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.royalGold)),
                  const SizedBox(height: 10),

                  ..._data!.pollingStations.map((station) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.location_city_rounded, color: AppColors.saffronAccent),
                        title: Text(station['name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.white)),
                        subtitle: Text('केंद्र कोड: ${station['code']}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 16),
                  VerificationBadge(sourceUrl: 'https://ceorajasthan.nic.in'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
