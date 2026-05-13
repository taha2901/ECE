import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/cart_total_empty_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/cart_total_error_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/cart_total_line_item_card.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/cart_total_summary_row.dart';

class CartTotalScreen extends StatefulWidget {
  const CartTotalScreen({super.key});

  @override
  State<CartTotalScreen> createState() => _CartTotalScreenState();
}

class _CartTotalScreenState extends State<CartTotalScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      context.read<CheckoutCubit>().loadCartTotal();
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
        title: const Text('Order Summary'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          if (state.status == CheckoutStatus.loadingCartTotal) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CheckoutStatus.error) {
            return CartTotalErrorState(message: state.errorMessage);
          }

          if (state.cartTotal == null || state.cartTotal!.items.isEmpty) {
            return const CartTotalEmptyState();
          }

          final cartTotal = state.cartTotal!;
          final items = cartTotal.items;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(
                            color: AppColors.accent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items in cart',
                              style: AppTypography.labelLarge,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                              child: Text(
                                '${items.length}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Order Items', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.md),
                      ...items.map(
                        (item) => CartTotalLineItemCard(item: item),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          children: [
                            CartTotalSummaryRow(
                              label: 'Subtotal',
                              value: '\$${cartTotal.total}',
                            ),
                            const Divider(height: 16),
                            const CartTotalSummaryRow(
                              label: 'Shipping',
                              value: 'TBD',
                              isHighlight: true,
                            ),
                            const Divider(height: 16),
                            const CartTotalSummaryRow(
                              label: 'Tax',
                              value: 'TBD',
                              isHighlight: true,
                            ),
                            const Divider(height: 16),
                            CartTotalSummaryRow(
                              label: 'Total',
                              value: '\$${cartTotal.total}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                color: AppColors.white,
                child: GradientButton(
                  label: 'Proceed to Checkout',
                  onTap: () => context.go(AppRoutes.enhancedCheckout),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
