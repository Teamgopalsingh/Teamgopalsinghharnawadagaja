import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';

class HarnawadaGajaScreen extends StatelessWidget {
  const HarnawadaGajaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('harnawada_info')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Village Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ग्राम पंचायत हरनावदा गजा',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.royalGold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'तहसील एवं उपखंड: झालरापाटन | जिला: झालावाड़ (राजस्थान)',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'हरनावदा गजा झालावाड़ जिले के झालरापाटन उपखंड का एक प्रमुख व समृद्ध ग्राम पंचायत क्षेत्र है। '
                      'यह गांव अपनी सांस्कृतिक धरोहर, कृषि उत्पादन और प्रगतिशील समुदाय के लिए जाना जाता है।',
                      style: TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text('🏫 गांव की प्रमुख सुविधाएं (Key Infrastructure)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.royalGold)),
            const SizedBox(height: 10),

            _buildFacilityItem(Icons.school_rounded, 'शिक्षा (Education)', 'राजकीय उच्च माध्यमिक विद्यालय, प्राथमिक बालिका स्कूल एवं आंगनवाड़ी केंद्र।'),
            _buildFacilityItem(Icons.local_hospital_rounded, 'स्वास्थ्य (Health)', 'उप-स्वास्थ्य केंद्र हरनावदा गजा एवं नियमित स्वास्थ्य शिविर सुविधा।'),
            _buildFacilityItem(Icons.water_drop_rounded, 'जल एवं कृषि (Water & Agri)', 'चंबल-कालीसिंध जल योजना लिंक, एनिकेट एवं कृषि सेवा केंद्र।'),
            _buildFacilityItem(Icons.alt_route_rounded, 'यातायात (Connectivity)', 'झालरापाटन-झालावाड़ मुख्य सड़क मार्ग से सीधी कनेक्टिविटी।'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityItem(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.saffronAccent, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      ),
    );
  }
}
