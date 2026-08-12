import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.royalNavy,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.saffronAccent.withOpacity(0.5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.saffronAccent,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('disclaimer_title'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.saffronAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('disclaimer_text'),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textLight,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
