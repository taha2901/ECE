import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class HomeAppBarContent extends StatelessWidget {
  const HomeAppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop&crop=face',
            width: 42,
            height: 42,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppColors.accent, size: 22),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Good morning 👋',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textHint,
                fontSize: 11,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'Ahmed Hassan',
              style: AppTypography.h3.copyWith(fontSize: 15),
            ),
          ],
        ),
        const Spacer(),
        _AppBarIconBtn(
          icon: Icons.notifications_outlined,
          badgeCount: 3,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.sm),
        _AppBarIconBtn(
          icon: Icons.shopping_bag_outlined,
          badgeCount: 2,
          onTap: () {},
        ),
      ],
    );
  }
}


class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _AppBarIconBtn({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: AppColors.cardShadow,
            ),
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
          if (badgeCount > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
