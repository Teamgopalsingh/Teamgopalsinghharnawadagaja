import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../widgets/hero_card.dart';
import '../widgets/section_title.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/bottom_nav_bar.dart';
import 'surya_mandir_screen.dart';
import 'complaint_screen.dart';
import 'development_screen.dart';
import 'officer_directory_screen.dart';
import 'election_center_screen.dart';
import 'harnawada_gaja_screen.dart';
import 'schemes_screen.dart';
import 'profile_screen.dart';

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const ComplaintScreen(),
    const DevelopmentScreen(),
    const OfficerDirectoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('कोई नया सरकारी नोटिफिकेशन उपलब्ध नहीं है।')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer Banner
            const DisclaimerBanner(),

            // Hero Card for Surya Mandir
            HeroCard(
              title: AppStrings.get('surya_mandir_hero_title'),
              subtitle: AppStrings.get('surya_mandir_hero_subtitle'),
              buttonText: AppStrings.get('surya_mandir_btn'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SuryaMandirScreen()),
                );
              },
            ),

            // Quick Actions Grid
            SectionTitle(title: AppStrings.get('quick_actions')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _buildQuickActionCard(
                    context,
                    AppStrings.get('action_complaint'),
                    AppColors.saffronAccent,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ComplaintScreen()),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    AppStrings.get('action_development'),
                    AppColors.royalGold,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DevelopmentScreen()),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    '🏛️ हरनावदा गजा जानकारी',
                    AppColors.textLight,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HarnawadaGajaScreen()),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    context,
                    AppStrings.get('action_schemes'),
                    AppColors.successGreen,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SchemesScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Assembly AC-198 Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: AppColors.cardDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.borderGold, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.royalNavy,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.royalGold, width: 1),
                        ),
                        child: const Icon(
                          Icons.how_to_vote_rounded,
                          color: AppColors.royalGold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('constituency_title'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.royalGold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.get('district_label'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.saffronAccent, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ElectionCenterScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Important Notices & News
            SectionTitle(title: '📰 गांव की ताजा खबरें एवं सूचनाएं'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.campaign_rounded, color: AppColors.saffronAccent, size: 30),
                  title: const Text(
                    'हरनावदा गजा में नल-जल योजना का विस्तार कार्य शुरू',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                  subtitle: const Text(
                    'ग्राम पंचायत क्षेत्र के समस्त वार्डों में स्वच्छ पेयजल हेतु पाइपलाइन बिछाने का कार्य जारी।',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  trailing: const Text('12 Aug', style: TextStyle(fontSize: 11, color: AppColors.saffronAccent)),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, Color accentColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
