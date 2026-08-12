import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';

class VerificationBadge extends StatelessWidget {
  final String sourceUrl;

  const VerificationBadge({
    Key? key,
    required this.sourceUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(sourceUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.royalNavy,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.successGreen, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_rounded,
              color: AppColors.successGreen,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${AppStrings.get('verified_source')} ${Uri.parse(sourceUrl).host}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.successGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.successGreen,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
