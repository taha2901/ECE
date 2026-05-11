import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';

class ProductCardVertical extends StatelessWidget {
  final ProductModel product;
  const ProductCardVertical({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetail, extra: product),
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
                    url: product.image,
                    height: 148,
                    width: double.infinity,
                    cacheWidth: 145,
                  ),
                ),

                // Wishlist button
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      final wishlisted = context
                          .read<WishlistCubit>()
                          .isWishlisted(product.id);
                      return _WishlistBtn(
                        wishlisted: wishlisted,
                        size: 34,
                        iconSize: 16,
                        onTap: () => context
                            .read<WishlistCubit>()
                            .toggleWishlist(product.id),
                      );
                    },
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

                  // Category + rating row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.categoryName,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFF59E0B),
                      ),
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
                  Text(product.formattedPrice, style: AppTypography.priceSmall),
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
      onTap: () => context.push(AppRoutes.productDetail, extra: product),
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
                      child: _ProductImage(url: product.image, cacheWidth: 300),
                    ),
                  ),

                  // Wishlist
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, state) {
                        final wishlisted = context
                            .read<WishlistCubit>()
                            .isWishlisted(product.id);
                        return _WishlistBtn(
                          wishlisted: wishlisted,
                          size: 30,
                          iconSize: 14,
                          onTap: () => context
                              .read<WishlistCubit>()
                              .toggleWishlist(product.id),
                        );
                      },
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
                      const Icon(
                        Icons.star_rounded,
                        size: 11,
                        color: Color(0xFFF59E0B),
                      ),
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
                            style: AppTypography.priceSmall.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          if (!product.inStock)
                            Text(
                              'Out of stock',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 10,
                                color: AppColors.error,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          final isLoggedIn = context.read<AuthCubit>().state.isSuccess;
                          if (!isLoggedIn) {
                            appScaffoldMessengerKey.currentState
                              ?..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                                  content: const Text(
                                    'Please sign in to add items to your cart.',
                                  ),
                                  action: SnackBarAction(
                                    label: 'Sign In',
                                    onPressed: () => context.push(AppRoutes.login),
                                  ),
                                ),
                              );
                            return;
                          }

                          context.read<CartCubit>().addToCart(
                            productId: product.id,
                            quantity: 1,
                            size: 'M', // Default size
                            color: product.variants.isNotEmpty
                                ? product.variants.first.colorHex
                                : '#000000',
                          );
                          appScaffoldMessengerKey.currentState?.showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 96),
                              content: Text('Added to cart!'),
                            ),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: AppColors.white,
                            size: 17,
                          ),
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
  final double? width;
  final int cacheWidth;

  const _ProductImage({
    required this.url,
    this.height,
    this.width,
    required this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: width,
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
          child: const Icon(
            Icons.image_outlined,
            color: AppColors.textHint,
            size: 36,
          ),
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
          wishlisted ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          size: iconSize,
          color: wishlisted ? AppColors.accent : AppColors.textHint,
        ),
      ),
    );
  }
}
