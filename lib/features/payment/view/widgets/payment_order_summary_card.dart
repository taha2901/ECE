import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

/// ملخص المبلغ من `CheckoutCubit` (يعرض فقط عند وجود `cartTotal`).
class PaymentOrderSummaryCard extends StatelessWidget {
  const PaymentOrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final cartTotal = state.cartTotal;
        if (cartTotal == null) return const SizedBox.shrink();

        final subtotal = cartTotal.totalAsDouble;
        final shipping = state.shippingFee ?? 10.0;
        final tax = state.tax ?? 0.0;
        final total = subtotal + shipping + tax;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Order Summary', style: AppTypography.labelLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _AmountRow(
                'Items (${cartTotal.items.length})',
                '\$${subtotal.toStringAsFixed(2)}',
              ),
              _AmountRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
              _AmountRow('Tax', '\$${tax.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _AmountRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                emphasize: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _AmountRow(this.label, this.value, {this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: emphasize
                ? AppTypography.labelLarge
                : AppTypography.bodyMedium
                    .copyWith(color: AppColors.textHint),
          ),
          Text(
            value,
            style: emphasize
                ? AppTypography.labelLarge.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  )
                : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
