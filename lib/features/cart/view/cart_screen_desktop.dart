import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/states.dart';
import 'package:real_ecommerce/features/cart/view/widgets/cart_dialogs.dart';
import 'package:real_ecommerce/features/cart/view/widgets/cart_item_card.dart';
import 'package:real_ecommerce/features/cart/view/widgets/cart_screen_shared.dart';
import 'package:real_ecommerce/features/cart/view/widgets/order_summary_box.dart';

class CartScreenDesktop extends StatefulWidget {
  const CartScreenDesktop({super.key});

  @override
  State<CartScreenDesktop> createState() => _CartScreenDesktopState();
}

class _CartScreenDesktopState extends State<CartScreenDesktop> {
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
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Shopping Cart'),
            centerTitle: false,
            actions: [
              if (state.status == CartStatus.loaded && !state.isEmpty)
                TextButton.icon(
                  onPressed: () => showClearCartDialog(context),
                  icon: const Icon(Icons.delete_sweep_rounded,
                      color: AppColors.error, size: 20),
                  label: Text(
                    'Clear Cart',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.error),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: CartFeedbackListener(
            child: Builder(
              builder: (context) {
                if (state.status == CartStatus.loading ||
                    state.status == CartStatus.removing) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                if (state.status == CartStatus.error) {
                  return CartErrorView(
                    message: state.errorMessage,
                    onRetry: () => context.read<CartCubit>().retry(),
                    wideLayout: true,
                  );
                }

                if (state.isEmpty) {
                  return const CartEmptyView(wideLayout: true);
                }

                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Cart Items', style: AppTypography.h2),
                                const SizedBox(width: AppSpacing.md),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppRadius.pill),
                                  ),
                                  child: Text(
                                    '${state.items.length} items',
                                    style: AppTypography.labelSmall
                                        .copyWith(color: AppColors.accent),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Expanded(
                              child: ListView.separated(
                                itemCount: state.items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.lg),
                                itemBuilder: (_, index) =>
                                    CartItemCard(item: state.items[index]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      SizedBox(
                        width: 340,
                        child: OrderSummaryBox(state: state, isCard: true),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
