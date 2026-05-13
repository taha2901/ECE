import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class WishlistEmptyView extends StatelessWidget {
  const WishlistEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 72,
            color: AppColors.textHint.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: AppTypography.h3.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items you love here',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
