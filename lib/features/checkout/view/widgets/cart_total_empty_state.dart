import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

class CartTotalEmptyState extends StatelessWidget {
  const CartTotalEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Your cart is empty', style: AppTypography.h2),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add items to your cart to continue shopping',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          GradientButton(
            label: 'Continue Shopping',
            onTap: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
