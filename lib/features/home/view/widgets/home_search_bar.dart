import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.search),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.lg),
            const Icon(Icons.search_rounded,
                color: AppColors.textHint, size: 22),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Search products, brands...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textHint,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(6),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.tune_rounded,
                  color: AppColors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
