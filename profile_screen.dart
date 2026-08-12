import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../services/offline_cache_service.dart';
import '../widgets/disclaimer_banner.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoggedIn = false;

  void _sendOtp() {
    if (_mobileController.text.length == 10) {
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ओटीपी (123456) आपके मोबाइल नंबर पर भेजा गया।')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया 10 अंकों का मान्य मोबाइल नंबर दर्ज करें।')),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text == '123456') {
      setState(() {
        _isLoggedIn = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('सफलतापूर्वक लॉगिन हो गए।')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('गलत ओटीपी। टेस्ट हेतु 123456 का उपयोग करें।')),
      );
    }
  }

  void _toggleLanguage() async {
    final newLang = AppStrings.currentLang == 'hi' ? 'en' : 'hi';
    AppStrings.currentLang = newLang;
    await OfflineCacheService.saveLanguagePreference(newLang);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(newLang == 'hi' ? 'भाषा बदलकर हिंदी की गई' : 'Language switched to English')),
    );
  }

  void _showDisclaimerModal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(AppStrings.get('disclaimer_title'), style: const TextStyle(color: AppColors.saffronAccent, fontSize: 16)),
        content: Text(AppStrings.get('disclaimer_text'), style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('समझ गया (I Understand)', style: TextStyle(color: AppColors.royalGold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('profile')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DisclaimerBanner(),
            const SizedBox(height: 16),

            // Login Mock Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoggedIn
                    ? Column(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.royalGold,
                            child: Icon(Icons.person_rounded, size: 36, color: AppColors.royalNavy),
                          ),
                          const SizedBox(height: 10),
                          Text('मोबाइल: +91 ${_mobileController.text}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                          const SizedBox(height: 4),
                          const Text('पंजीकृत ग्रामजन (हरनावदा गजा)', style: TextStyle(fontSize: 12, color: AppColors.saffronAccent)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('नागरिक लॉगिन (OTP Authentication)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.royalGold)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: '10 अंकों का मोबाइल नंबर',
                              prefixText: '+91 ',
                              fillColor: AppColors.royalNavy,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          if (_otpSent) ...[
                            const SizedBox(height: 12),
                            TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.white),
                              decoration: const InputDecoration(
                                labelText: 'OTP दर्ज़ करें (Test: 123456)',
                                fillColor: AppColors.royalNavy,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _otpSent ? _verifyOtp : _sendOtp,
                              child: Text(_otpSent ? 'ओटीपी सत्यापित करें' : 'ओटीपी भेजें'),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Settings Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.translate_rounded, color: AppColors.royalGold),
                    title: Text(AppStrings.get('language_switch')),
                    subtitle: Text('वर्तमान भाषा: ${AppStrings.currentLang == 'hi' ? 'हिंदी' : 'English'}'),
                    trailing: const Icon(Icons.swap_horiz_rounded, color: AppColors.saffronAccent),
                    onTap: _toggleLanguage,
                  ),
                  const Divider(color: AppColors.borderGold, height: 1),
                  ListTile(
                    leading: const Icon(Icons.gavel_rounded, color: AppColors.royalGold),
                    title: const Text('गैर-सरकारी घोषणापत्र (Disclaimer)'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textMuted),
                    onTap: _showDisclaimerModal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
