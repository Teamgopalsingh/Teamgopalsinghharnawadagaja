import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../models/models.dart';
import '../widgets/disclaimer_banner.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({Key? key}) : super(key: key);

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  final List<GovernmentScheme> _schemes = [
    GovernmentScheme(
      id: '1',
      title: 'मुख्यमंत्री किसान सम्मान निधि योजना',
      category: 'किसान',
      benefits: 'वार्षिक रु. 2,000 की अतिरिक्त वित्तीय सहायता सीधी बैंक खाते में।',
      eligibility: 'राजस्थान के समस्त लघु एवं सीमांत कृषक।',
      applicationProcess: 'ई-मित्रा केंद्र के माध्यम से अथवा राज किसान साथी पोर्टल पर आवेदन।',
      officialPortalUrl: 'https://rajkisan.rajasthan.gov.in',
    ),
    GovernmentScheme(
      id: '2',
      title: 'इंदिरा गांधी स्मार्टफोन / लाडो प्रोत्साहन योजना',
      category: 'महिला',
      benefits: 'निःशुल्क डिजिटल कनेक्टिविटी एवं बालिका शिक्षा प्रोत्साहन।',
      eligibility: 'जन आधार कार्ड धारक परिवार की महिलाएं व छात्राएं।',
      applicationProcess: 'ग्राम पंचायत शिविर में जन आधार कार्ड प्रस्तुत कर पंजीयन।',
      officialPortalUrl: 'https://janaadhaar.rajasthan.gov.in',
    ),
    GovernmentScheme(
      id: '3',
      title: 'मुख्यमंत्री युवा संबल योजना (अधिशेष भत्ता)',
      category: 'युवा',
      benefits: 'स्नातक बेरोजगार युवाओं को रु. 4,000 - 4,500 प्रतिमाह भत्ता।',
      eligibility: 'राजस्थान के मूल निवासी स्नातक युवा।',
      applicationProcess: 'SSO आईडी द्वारा नेशनल करियर सर्विस (NCS) पोर्टल पर आवेदन।',
      officialPortalUrl: 'https://sso.rajasthan.gov.in',
    ),
    GovernmentScheme(
      id: '4',
      title: 'मुख्यमंत्री सामाजिक सुरक्षा वृद्धजन पेंशन',
      category: 'वरिष्ठ नागरिक',
      benefits: 'रु. 1,150 प्रतिमाह सामाजिक सुरक्षा पेंशन।',
      eligibility: '55 वर्ष से अधिक महिला व 60 वर्ष से अधिक पुरुष।',
      applicationProcess: 'ई-मित्र केंद्र के माध्यम से एसएसओ पोर्टल पर पंजीयन।',
      officialPortalUrl: 'https://ssp.rajasthan.gov.in',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('schemes')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _schemes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: DisclaimerBanner(),
            );
          }
          final scheme = _schemes[index - 1];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scheme.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.royalGold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.saffronAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.saffronAccent),
                        ),
                        child: Text(scheme.category, style: const TextStyle(color: AppColors.saffronAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('लाभ: ${scheme.benefits}', style: const TextStyle(fontSize: 13, color: AppColors.white)),
                  const SizedBox(height: 6),
                  Text('पात्रता: ${scheme.eligibility}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Text('प्रक्रिया: ${scheme.applicationProcess}', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(scheme.officialPortalUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_browser_rounded, size: 16),
                      label: const Text('आधिकारिक पोर्टल पर जाएं (Official Link)'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
