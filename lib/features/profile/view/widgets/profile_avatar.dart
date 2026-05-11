import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class ProfileAvatar extends StatelessWidget {
  final String displayName;
  final String subtitle;
  final String? username;
  final String phone;
  final String location;

  const ProfileAvatar({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.username,
    this.phone = '',
    this.location = '',
  });

  String get initials {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppColors.cardShadow,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: AppTypography.h2.copyWith(color: AppColors.white, fontSize: 32),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(displayName, style: AppTypography.h2),
        Text(subtitle, style: AppTypography.bodyMedium),
        if (username != null && username!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text('Username: $username', style: AppTypography.bodySmall),
        ],
        if (phone.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text('Phone: $phone', style: AppTypography.bodySmall),
        ],
        if (location.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(location, style: AppTypography.bodySmall),
        ],
      ],
    );
  }
}
