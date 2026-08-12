import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class SuryaMandirScreen extends StatelessWidget {
  const SuryaMandirScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सूर्य मंदिर, झालरापाटन'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Banner Simulation
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGold),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.synagogue_rounded, size: 60, color: AppColors.royalGold),
                      SizedBox(height: 8),
                      Text('10th Century Sun Temple, Jhalrapatan', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'ऐतिहासिक सूर्य मंदिर (पद्मनाभ मंदिर), झालरापाटन',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.royalGold),
            ),
            const SizedBox(height: 6),
            const Text(
              'झालावाड़ जिला, राजस्थान • पुरातात्विक धरोहर',
              style: TextStyle(fontSize: 13, color: AppColors.saffronAccent, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'मंदिर की वास्तुकला एवं इतिहास',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'झालरापाटन का सूर्य मंदिर (जिसे पद्मनाभ मंदिर भी कहा जाता है) 10वीं शताब्दी का एक अत्यंत सुंदर व विशाल वास्तुकला का प्रतीक है। '
                      'यह मंदिर कोणार्क के सूर्य मंदिर की भांति ही सूर्य देव की भव्य प्रतिमा व रथ-शैली नक्काशी के लिए प्रसिद्ध है। '
                      'इसकी शिखर की ऊंचाई 97 फीट है जो दूर से ही दृष्टिगोचर होती है।',
                      style: TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://maps.google.com/?q=Surya+Mandir+Jhalrapatan+Rajasthan');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.directions_rounded),
                label: const Text('गूगल मैप्स पर लोकेशन देखें'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffronAccent),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
