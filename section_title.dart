import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTrailingTap;
  final String? trailingText;

  const SectionTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.onTrailingTap,
    this.trailingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.saffronAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.royalGold,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
          if (trailingText != null && onTrailingTap != null)
            InkWell(
              onTap: onTrailingTap,
              child: Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.saffronAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
