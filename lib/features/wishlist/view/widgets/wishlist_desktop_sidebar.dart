import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/wishlist/data/models/wishlist_model.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_add_all.dart';

/// الشريط الجانبي في مفضلة الديسكتوب: ملخص + إضافة للعربة.
class WishlistDesktopSidebar extends StatelessWidget {
  final List<WishlistModel> items;

  const WishlistDesktopSidebar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Wishlist', style: AppTypography.labelLarge),
                        Text(
                          '${items.length} item${items.length == 1 ? '' : 's'}',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.lg),
                Text('Quick Actions', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        addAllWishlistItemsToCart(context, items),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: const Text('Add All to Cart'),
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
