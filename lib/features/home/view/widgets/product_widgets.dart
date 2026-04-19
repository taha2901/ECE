import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// PRODUCT CARD — VERTICAL (horizontal list)
// ═══════════════════════════════════════════════
class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    topRight: Radius.circular(AppRadius.xl),
                  ),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, size: 44, color: AppColors.textHint),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: AppBadge(
                    label: '-20%',
                    backgroundColor: AppColors.accent,
                    textColor: AppColors.white,
                    isSmall: true,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: const Icon(Icons.favorite_outline_rounded, size: 16, color: AppColors.textHint),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Samsung Galaxy S25',
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const RatingStars(rating: 4.5, size: 12),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$299', style: AppTypography.priceSmall),
                      const SizedBox(width: 6),
                      Text('\$399', style: AppTypography.priceStrikethrough),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// PRODUCT CARD — GRID
// ═══════════════════════════════════════════════
class ProductCardGrid extends StatelessWidget {
  const ProductCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_outlined, size: 44, color: AppColors.textHint),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: AppBadge(
                      label: 'New',
                      backgroundColor: AppColors.success.withOpacity(0.15),
                      textColor: AppColors.success,
                      isSmall: true,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: const Icon(Icons.favorite_outline_rounded, size: 16, color: AppColors.textHint),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nike Air Max 2025',
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$149', style: AppTypography.priceSmall),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}