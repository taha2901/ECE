import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/data/models/wishlist_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';

/// يضيف كل عناصر المفضلة للعربة (نفس السلوك في الموبايل والديسكتوب).
void addAllWishlistItemsToCart(BuildContext context, List<WishlistModel> items) {
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

/// زر "Add All" في الـ AppBar (يظهر فقط عند وجود عناصر).
class WishlistAddAllAppBarButton extends StatelessWidget {
  const WishlistAddAllAppBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state is! WishlistLoaded || state.items.isEmpty) {
          return const SizedBox.shrink();
        }
        return TextButton(
          onPressed: () => addAllWishlistItemsToCart(context, state.items),
          child: Text(
            'Add All to Cart',
            style: AppTypography.labelMedium.copyWith(color: AppColors.accent),
          ),
        );
      },
    );
  }
}
