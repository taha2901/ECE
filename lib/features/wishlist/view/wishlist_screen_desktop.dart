import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/data/models/wishlist_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_item_card.dart';

/// Layout الديسكتوب:
///   ┌─────────────────┬──────────────────────────────┐
///   │  Sidebar 260px  │  Grid (3 columns)            │
///   │                 │                              │
///   │  ♥ 12 items     │  [ card ][ card ][ card ]    │
///   │  Total: $XXX    │  [ card ][ card ][ card ]    │
///   │                 │                              │
///   │  [Add All]      │                              │
///   └─────────────────┴──────────────────────────────┘
class WishlistDesktop extends StatelessWidget {
  const WishlistDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is WishlistError) {
            return _ErrorView(message: state.message);
          }

          final items = _resolveItems(state);

          if (items.isEmpty) return const _EmptyView();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Sidebar ───────────────────────────
                    SizedBox(
                      width: 260,
                      child: _WishlistSidebar(
                        items: items,
                        state: state,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),

                    // ── Grid ──────────────────────────────
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSpacing.lg,
                          crossAxisSpacing: AppSpacing.lg,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final isActionLoading =
                              state is WishlistActionLoading &&
                                  state.productId == items[i].product.id;
                          return WishlistItemCard(
                            item: items[i],
                            isActionLoading: isActionLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

List<WishlistModel> _resolveItems(WishlistState state) {
  if (state is WishlistLoaded) return state.items;
  if (state is WishlistActionLoading) return state.currentItems;
  return [];
}

// ══════════════════════════════════════════════
// SIDEBAR
// ══════════════════════════════════════════════
class _WishlistSidebar extends StatelessWidget {
  final List<WishlistModel> items;
  final WishlistState state;

  const _WishlistSidebar({required this.items, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Card
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
                      color: AppColors.accent.withOpacity(0.1),
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
                  onPressed: () => _addAllToCart(context, items),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text('Add All to Cart'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addAllToCart(BuildContext context, List<WishlistModel> items) {
    for (final item in items) {
      context.read<CartCubit>().addToCart(
            productId: item.product.id,
            quantity: 1,
            size: 'M',
            color: item.product.variants.isNotEmpty
                ? item.product.variants.first.colorHex
                : '#000000',
          );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All items added to cart!')),
    );
  }
}

// ── Empty State ──────────────────────────────────
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 72,
            color: AppColors.textHint.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: AppTypography.h3.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items you love here',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Error State ──────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<WishlistCubit>().loadWishlist(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}