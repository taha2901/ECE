import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class BrandAndRating extends StatelessWidget {
  const BrandAndRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BrandBadge(label: 'Nike'),
        const Spacer(),
        RatingChip(rating: 4.7, count: '2.4k'),
      ],
    );
  }
}


class BrandBadge extends StatelessWidget {
  final String label;

  const BrandBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


class RatingChip extends StatelessWidget {
  final double rating;
  final String count;

  const RatingChip({super.key, required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 16),
          const SizedBox(width: 4),
          Text(
            '$rating',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            ' ($count)',
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

