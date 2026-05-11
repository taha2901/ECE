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

// ═══════════════════════════════════════════════
// CART TOTAL SCREEN (عرض الإجمالي والمنتجات)
// ═══════════════════════════════════════════════
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
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
      ),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          if (state.status == CheckoutStatus.loadingCartTotal) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CheckoutStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Failed to load cart',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CheckoutCubit>().loadCartTotal();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state.cartTotal == null || state.cartTotal!.items.isEmpty) {
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
                      // عدد المنتجات
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
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
                                borderRadius: BorderRadius.circular(AppRadius.md),
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

                      // قائمة المنتجات
                      Text('Order Items', style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.md),
                      ...items.map((item) => _CartItemCard(item: item)),
                      const SizedBox(height: AppSpacing.xl),

                      // الملخص
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: 'Subtotal',
                              value: '\$${cartTotal.total}',
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
                              label: 'Shipping',
                              value: 'TBD',
                              isHighlight: true,
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
                              label: 'Tax',
                              value: 'TBD',
                              isHighlight: true,
                            ),
                            const Divider(height: 16),
                            _SummaryRow(
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

              // زر الدفع
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

// ─── Cart Item Card ────────────────────────────
Color _hexToColor(String colorString) {
  try {
    final hexString = colorString.replaceFirst('#', '');
    return Color(int.parse('ff$hexString', radix: 16));
  } catch (e) {
    return AppColors.textHint;
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic item;

  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceVariant,
              child: item.productImage.isNotEmpty
                  ? Image.network(
                      item.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _hexToColor(item.color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Size: ${item.size}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price} x ${item.quantity}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    Text(
                      '\$${item.lineTotal.toStringAsFixed(2)}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Row ────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
              .copyWith(
            color:
                isHighlight ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: (isBold ? AppTypography.h3 : AppTypography.bodyMedium)
              .copyWith(
            color:
                isHighlight ? AppColors.accent : AppColors.textPrimary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
