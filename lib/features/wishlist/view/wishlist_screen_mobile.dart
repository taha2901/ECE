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

/// Layout الموبايل: Grid 2 columns عادي
class WishlistMobile extends StatelessWidget {
  const WishlistMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [_AddAllButton()],
      ),
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

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final isActionLoading = state is WishlistActionLoading &&
                  state.productId == items[i].product.id;
              return WishlistItemCard(
                item: items[i],
                isActionLoading: isActionLoading,
              );
            },
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

// ── Add All Button ───────────────────────────────
class _AddAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state is! WishlistLoaded || state.items.isEmpty) {
          return const SizedBox.shrink();
        }
        return TextButton(
          onPressed: () => _addAllToCart(context, state.items),
          child: Text(
            'Add All to Cart',
            style: AppTypography.labelMedium.copyWith(color: AppColors.accent),
          ),
        );
      },
    );
  }
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
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
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