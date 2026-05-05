import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';

class ProductBottomBar extends StatefulWidget {
  final int productId;
  final String selectedSize;
  final String selectedColor;

  const ProductBottomBar({
    super.key,
    required this.productId,
    required this.selectedSize,
    required this.selectedColor,
  });

  @override
  State<ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<ProductBottomBar> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity control
          _QuantityControl(
            quantity: _qty,
            onIncrement: () => setState(() => _qty++),
            onDecrement: () {
              if (_qty > 1) setState(() => _qty--);
            },
          ),
          const SizedBox(width: AppSpacing.lg),

          // Add to Cart
          Expanded(
            child: GestureDetector(
              onTap: _handleAddToCart,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.accentShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.addToCart,
                      style: AppTypography.buttonLarge
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart() {
    final isLoggedIn = context.read<AuthCubit>().state.isSuccess;
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: const Text('Please sign in to add items to your cart.'),
            action: SnackBarAction(
              label: 'Sign In',
              onPressed: () => context.push(AppRoutes.login),
            ),
          ),
        );
      return;
    }

    context.read<CartCubit>().addToCart(
          productId: widget.productId,
          quantity: _qty,
          size: widget.selectedSize,
          color: widget.selectedColor,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart!')),
    );
  }
}

// ─── Quantity Control ────────────────────────────
class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child:
                Text('$quantity', style: AppTypography.h3.copyWith(fontSize: 16)),
          ),
          _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement, filled: true),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyBtn(
      {required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 46,
        decoration: BoxDecoration(
          gradient: filled ? AppColors.accentGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? AppColors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}