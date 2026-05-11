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
//  CART SCREEN  —  DESKTOP
// ══════════════════════════════════════════════════════════

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

            // ── زرار مسح الكارت ──────────────────────
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
                // ── Loading / Removing ────────────────
                if (state.status == CartStatus.loading ||
                    state.status == CartStatus.removing) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                // ── Error ────────────────────────────
                if (state.status == CartStatus.error) {
                  return _DesktopErrorView(
                    message: state.errorMessage,
                    onRetry: () => context.read<CartCubit>().retry(),
                  );
                }

                // ── Empty ────────────────────────────
                if (state.isEmpty) return const _DesktopEmptyView();

                // ── 2-Column Layout ──────────────────
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // يسار: قائمة المنتجات
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

                      // يمين: ملخص الطلب (sticky)
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

// ── Empty State ──────────────────────────────────────────

class _DesktopEmptyView extends StatelessWidget {
  const _DesktopEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.xl),
          Text('Your cart is empty', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Add some items to get started',
            style: AppTypography.bodyLarge
                .copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: 240,
            child: AppButton(
              onTap: () => context.go(AppRoutes.home),
              label: 'Continue Shopping',
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error State ──────────────────────────────────────────

class _DesktopErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _DesktopErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 80, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.xl),
          Text(
            message ?? 'Error loading cart',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(onTap: onRetry, label: 'Retry'),
        ],
      ),
    );
  }
}