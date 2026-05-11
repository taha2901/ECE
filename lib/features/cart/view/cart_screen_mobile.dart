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
import 'package:real_ecommerce/features/cart/view/widgets/cart_dialogs.dart';
import 'package:real_ecommerce/features/cart/view/widgets/cart_item_card.dart';
import 'package:real_ecommerce/features/cart/view/widgets/order_summary_box.dart';

// ══════════════════════════════════════════════════════════
//  CART SCREEN  —  MOBILE
// ══════════════════════════════════════════════════════════

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

            // ── زرار مسح الكارت ──────────────────────
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
          body: BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state.errorMessage != null &&
                  state.status == CartStatus.loaded) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(state.errorMessage!)),
                      ],
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 3),
                  ));
              }
              if (state.status == CartStatus.loaded &&
                  state.message == 'Cart cleared') {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Cart cleared successfully'),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ));
              }
            },
            child: Builder(
              builder: (context) {
                // ── Loading ──────────────────────────
                if (state.status == CartStatus.loading ||
                    state.status == CartStatus.removing) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                // ── Error ────────────────────────────
                if (state.status == CartStatus.error) {
                  return _ErrorView(
                    message: state.errorMessage,
                    onRetry: () => context.read<CartCubit>().retry(),
                  );
                }

                // ── Empty ────────────────────────────
                if (state.isEmpty) return const _EmptyView();

                // ── Loaded ───────────────────────────
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

// ── Empty State ──────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.lg),
          Text('Your cart is empty', style: AppTypography.h2),
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
}

// ── Error State ──────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 60, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message ?? 'Error loading cart',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(onTap: onRetry, label: 'Retry'),
        ],
      ),
    );
  }
}