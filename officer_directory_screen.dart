import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';
import '../widgets/verification_badge.dart';

class OfficerDirectoryScreen extends StatefulWidget {
  const OfficerDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<OfficerDirectoryScreen> createState() => _OfficerDirectoryScreenState();
}

class _OfficerDirectoryScreenState extends State<OfficerDirectoryScreen> {
  List<OfficialContact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await SupabaseService().fetchOfficialContacts();
    setState(() {
      _contacts = data;
      _isLoading = false;
    });
  }

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'हरनावदा गजा - जन समस्या संदर्भ'},
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('officer_directory')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.royalGold))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.royalNavy,
                              child: Text(
                                contact.name.substring(0, 2),
                                style: const TextStyle(color: AppColors.royalGold, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                                  ),
                                  Text(
                                    contact.designation,
                                    style: const TextStyle(fontSize: 13, color: AppColors.saffronAccent, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    contact.department,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                contact.officeAddress,
                                style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        VerificationBadge(sourceUrl: contact.verifiedSourceUrl),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _makeCall(contact.phone),
                                icon: const Icon(Icons.call_rounded, size: 18),
                                label: Text(AppStrings.get('call')),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.royalGold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _sendEmail(contact.email),
                                icon: const Icon(Icons.email_rounded, size: 18),
                                label: Text(AppStrings.get('email')),
                              ),
                            ),
                          ],
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
