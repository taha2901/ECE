import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';




class ProductCardVertical extends StatelessWidget {
  final ProductModel product;
  const ProductCardVertical({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail),
      child: Container(
        width: 145,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: _ProductImage(
                    url: product.imageUrl,
                    height: 148,
                    cacheWidth: 300,
                  ),
                ),

                // Discount badge
                if (product.discount.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _DiscountBadge(label: product.discount),
                  ),

                // Wishlist button
                Positioned(
                  top: 8,
                  right: 8,
                  child: _WishlistBtn(
                    wishlisted: false,
                    size: 34,
                    iconSize: 16,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            // ── Info ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Brand + rating row
                  Row(
                    children: [
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          size: 12, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 2),
                      Text(
                        product.formattedRating,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price row
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: AppTypography.priceSmall,
                      ),
                      const SizedBox(width: 6),
                      if (product.originalPrice > product.price)
                        Text(
                          product.formattedOriginalPrice,
                          style: AppTypography.priceStrikethrough
                              .copyWith(fontSize: 11),
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


class ProductCardGrid extends StatelessWidget {
  final ProductModel product;
  const ProductCardGrid({super.key, required this.product});

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: _ProductImage(
                        url: product.imageUrl,
                        cacheWidth: 300,
                      ),
                    ),
                  ),

                  // "New" badge
                  if (product.isNew)
                    const Positioned(
                      top: 9,
                      left: 9,
                      child: _NewBadge(),
                    ),

                  // Discount badge
                  if (product.discount.isNotEmpty && !product.isNew)
                    Positioned(
                      top: 9,
                      left: 9,
                      child: _DiscountBadge(label: product.discount),
                    ),

                  // Wishlist
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _WishlistBtn(
                      wishlisted: false,
                      size: 30,
                      iconSize: 14,
                      onTap: () {},
                          
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 11, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 2),
                      Text(
                        product.formattedRating,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price + Add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.formattedPrice,
                            style: AppTypography.priceSmall
                                .copyWith(fontSize: 14),
                          ),
                          if (product.originalPrice > product.price)
                            Text(
                              product.formattedOriginalPrice,
                              style: AppTypography.priceStrikethrough
                                  .copyWith(fontSize: 10),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: AppColors.white, size: 17),
                        ),
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

// ══════════════════════════════════════════════════════════
//  SHARED SUB-WIDGETS  (extracted for reuse & const)
// ══════════════════════════════════════════════════════════

/// Network image with shimmer placeholder — cacheWidth reduces memory
class _ProductImage extends StatelessWidget {
  final String url;
  final double? height;
  final int cacheWidth;

  const _ProductImage({
    required this.url,
    this.height,
    required this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      height: height,
      cacheWidth: cacheWidth,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.surfaceVariant,
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.image_outlined,
            color: AppColors.textHint, size: 36),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final String label;
  const _DiscountBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Text(
        'New',
        style: TextStyle(
          color: Color(0xFF16A34A),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _WishlistBtn extends StatelessWidget {
  final bool wishlisted;
  final double size;
  final double iconSize;
  final VoidCallback onTap;

  const _WishlistBtn({
    required this.wishlisted,
    required this.size,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          wishlisted
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          size: iconSize,
          color: wishlisted ? AppColors.accent : AppColors.textHint,
        ),
      ),
    );
  }
}