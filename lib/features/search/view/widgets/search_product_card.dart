import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart' as cart;
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';

/// بطاقة منتج في نتائج البحث: صورة، سعر، مفضلة، إضافة للعربة.
class SearchProductCard extends StatelessWidget {
  final ProductModel product;

  const SearchProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '${AppRoutes.productDetail}?id=${product.id}',
          extra: product,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.xl),
                bottomLeft: Radius.circular(AppRadius.xl),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: AppColors.surfaceVariant,
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textHint,
                        ),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        color: AppColors.textHint,
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedPrice,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<WishlistCubit, dynamic>(
                          builder: (context, state) {
                            final wishlistCubit = context.read<WishlistCubit>();
                            final isInWishlist =
                                wishlistCubit.isWishlisted(product.id);
                            return IconButton(
                              icon: Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWishlist
                                    ? AppColors.error
                                    : AppColors.textHint,
                                size: 20,
                              ),
                              onPressed: () {
                                wishlistCubit.toggleWishlist(product.id);
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<cart.CartCubit>().addToCart(
                                  productId: product.id,
                                  quantity: 1,
                                  size: product.availableSizes.isNotEmpty
                                      ? product.availableSizes.first
                                      : 'M',
                                  color: product.variants.isNotEmpty
                                      ? product.variants.first.colorHex
                                      : '#000000',
                                );
                            appScaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 96),
                                content:
                                    Text('${product.name} added to cart'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Cart',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
