import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/states.dart';
import 'widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      context.read<CartCubit>().loadCart();
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Shopping Cart'),
        centerTitle: true,
      ),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          // عرض رسالة الخطأ في snackbar عند حدوث خطأ في التحديث
          if (state.errorMessage != null && state.status == CartStatus.loaded) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.status == CartStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                ),
              );
            }

            if (state.status == CartStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      state.errorMessage ?? 'Error loading cart',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      onTap: () => context.read<CartCubit>().retry(),
                      label: 'Retry',
                    ),
                  ],
                ),
              );
            }

            if (state.isEmpty) {
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
                  Text(
                    'Your cart is empty',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Add some items to get started',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textHint),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    onTap: () => context.go(AppRoutes.home),
                    label: 'Continue Shopping',
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (_, index) => CartItemWidget(
                    item: state.items[index],
                  ),
                ),
              ),
              _CartSummary(state: state),
              const SizedBox(height: 100),
            ],
          );
          },
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartState state;

  const _CartSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final subtotal = state.totalPrice;
    final shipping = 10.0;
    final tax = subtotal * 0.1;
    final total = subtotal + shipping + tax;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: AppTypography.bodyMedium),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping', style: AppTypography.bodyMedium),
              Text(
                '\$${shipping.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: AppTypography.bodyMedium),
              Text(
                '\$${tax.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          const Divider(),
          const SizedBox(height: AppSpacing.lg),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.h3),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTypography.h3.copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Checkout Button
          AppButton(
            onTap: () => context.push(AppRoutes.cartTotal),
            label: 'Proceed to Checkout',
            isFullWidth: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Continue Shopping
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(
              'Continue Shopping',
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
