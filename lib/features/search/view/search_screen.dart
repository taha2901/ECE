import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/search/logic/search_cubit.dart';
import 'package:real_ecommerce/features/search/logic/search_states.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart' as cart;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Products'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Search Input ────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products, brands...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          context.read<SearchCubit>().clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (query) {
                setState(() {});
                context.read<SearchCubit>().searchProducts(query);
              },
            ),
          ),

          // ── Search Results ──────────────────────
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is SearchInitial) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_outlined,
                            size: 72,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'ابحث عن منتجك هنا و ضيفه للعربة',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'اكتب اسم المنتج في مربع البحث علشان نجيبلك النتايج من غير ما نستدعي كل المنتجات عند فتح الصفحة.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found for "${_searchController.text}"',
                        style: AppTypography.bodyMedium,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return _SearchProductCard(product: product);
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// PRODUCT CARD — مع wishlist + cart + details
// ═══════════════════════════════════════════════
class _SearchProductCard extends StatelessWidget {
  final ProductModel product;

  const _SearchProductCard({required this.product});

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
            // ── Image ────────────────────────────
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
                        errorBuilder: (context, error, stackTrace) => const Icon(
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

            // ── Details ──────────────────────────
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
                      '\$${double.parse(product.price.toString()).toStringAsFixed(2)}',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wishlist button
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
                        // Add to cart button
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
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                                content: Text('${product.name} added to cart'),
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
                              borderRadius: BorderRadius.circular(AppRadius.sm),
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
