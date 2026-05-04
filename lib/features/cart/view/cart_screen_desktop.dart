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
import 'package:real_ecommerce/features/cart/view/widgets/cart_item_card.dart';
import 'package:real_ecommerce/features/cart/view/widgets/order_summary_box.dart';

// ══════════════════════════════════════════════════════════
//  CART SCREEN  —  DESKTOP
//  Layout أفقي: قائمة المنتجات يسار (flex 3) + الملخص يمين (flex 1)
//  الملخص sticky — المنتجات scrollable
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Shopping Cart'),
        centerTitle: false,
      ),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.status == CartStatus.loaded) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
              ));
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.status == CartStatus.loading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.accent));
            }

            if (state.status == CartStatus.error) {
              return _DesktopErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<CartCubit>().retry(),
              );
            }

            if (state.isEmpty) {
              return const _DesktopEmptyView();
            }

            // ── 2-column layout ──────────────────────
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── يسار: قائمة المنتجات (scrollable) ──
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
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
                                borderRadius: BorderRadius.circular(AppRadius.pill),
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

                        // Items list
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

                  // ── يمين: ملخص الطلب (sticky) ────────
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
          Icon(Icons.shopping_cart_outlined, size: 100, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.xl),
          Text('Your cart is empty', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Add some items to get started',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textHint),
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
          const Icon(Icons.error_outline, size: 80, color: AppColors.textHint),
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