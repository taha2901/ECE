import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class ProfileAvatar extends StatelessWidget {
  final String displayName;
  final String subtitle;
  final String? username;

  const ProfileAvatar({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 44,
                color: AppColors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(displayName, style: AppTypography.h2),
        Text(subtitle, style: AppTypography.bodyMedium),
        if (username != null && username!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text('Username: $username', style: AppTypography.bodySmall),
        ],
      ],
    );
  }
}