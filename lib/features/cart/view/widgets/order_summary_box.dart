import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/cart/logic/states.dart';

// ══════════════════════════════════════════════════════════
//  ORDER SUMMARY BOX  —  مشتركة بين Mobile و Desktop
//  يعرض Subtotal / Shipping / Tax / Total + زرار Checkout
// ══════════════════════════════════════════════════════════

class OrderSummaryBox extends StatelessWidget {
  final CartState state;

  /// لو [isCard] = true تظهر كـ Card مستقلة (Desktop)
  /// لو false تظهر كـ bottom sheet مرفقة (Mobile)
  final bool isCard;

  const OrderSummaryBox({
    super.key,
    required this.state,
    this.isCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = state.totalPrice;
    final shipping = 10.0;
    final tax = subtotal * 0.1;
    final total = subtotal + shipping + tax;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCard) ...[
          Text('Order Summary', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xl),
        ],

        // ── السطور ──────────────────────────────────
        _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: AppSpacing.md),
        _SummaryRow(label: 'Shipping', value: '\$${shipping.toStringAsFixed(2)}'),
        const SizedBox(height: AppSpacing.md),
        _SummaryRow(label: 'Tax (10%)', value: '\$${tax.toStringAsFixed(2)}'),
        const SizedBox(height: AppSpacing.lg),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),

        // ── الإجمالي ─────────────────────────────────
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

        // ── Checkout Button ──────────────────────────
        AppButton(
          onTap: () => context.push(AppRoutes.cartTotal),
          label: 'Proceed to Checkout',
          isFullWidth: true,
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Continue Shopping ────────────────────────
        Center(
          child: TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(
              'Continue Shopping',
              style: AppTypography.labelLarge.copyWith(color: AppColors.accent),
            ),
          ),
        ),
      ],
    );

    // Desktop → Card مستقلة
    if (isCard) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.cardShadow,
        ),
        child: content,
      );
    }

    // Mobile → bottom attached panel
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
      child: content,
    );
  }
}

// ── Summary Row ──────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.bodyMedium),
      ],
    );
  }
}