import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.royalNavy,
        border: Border(
          top: BorderSide(color: AppColors.borderGold, width: 0.8),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.royalNavy,
        selectedItemColor: AppColors.royalGold,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: AppStrings.get('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.rate_review_rounded),
            label: AppStrings.get('nav_complaint'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.engineering_rounded),
            label: AppStrings.get('nav_development'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.contacts_rounded),
            label: AppStrings.get('nav_directory'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: AppStrings.get('nav_more'),
          ),
        ],
      ),
    );
  }
}
