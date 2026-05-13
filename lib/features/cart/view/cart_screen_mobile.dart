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

class CartScreenMobile extends StatefulWidget {
  const CartScreenMobile({super.key});

  @override
  State<CartScreenMobile> createState() => _CartScreenMobileState();
}

class _CartScreenMobileState extends State<CartScreenMobile> {
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
            title: Column(
              children: [
                const Text('Shopping Cart'),
                if (state.status == CartStatus.loaded && !state.isEmpty)
                  Text(
                    '${state.totalItems} items',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textHint),
                  ),
              ],
            ),
            centerTitle: true,
            actions: [
              if (state.status == CartStatus.loaded && !state.isEmpty)
                IconButton(
                  onPressed: () => showClearCartDialog(context),
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    color: AppColors.error,
                  ),
                  tooltip: 'Clear Cart',
                ),
            ],
          ),
          body: CartFeedbackListener(
            child: Builder(
              builder: (context) {
                if (state.status == CartStatus.loading ||
                    state.status == CartStatus.removing) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                if (state.status == CartStatus.error) {
                  return CartErrorView(
                    message: state.errorMessage,
                    onRetry: () => context.read<CartCubit>().retry(),
                  );
                }

                if (state.isEmpty) return const CartEmptyView();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.all(AppSpacing.pagePadding),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (_, index) =>
                            CartItemCard(item: state.items[index]),
                      ),
                    ),
                    OrderSummaryBox(state: state),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
