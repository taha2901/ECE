import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        if (state.cartTotal == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final cartTotal = state.cartTotal!;
        final subtotal = cartTotal.totalAsDouble;
        final shipping = state.shippingFee ?? 10.0;
        final tax = state.tax ?? 0.0;
        final total = subtotal + shipping + tax;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Review', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),

            _ReviewSection(
              title: 'Customer Information',
              children: [
                _ReviewRow('Name', '${state.firstName} ${state.lastName}'),
                _ReviewRow('Email', state.email ?? ''),
                _ReviewRow('Phone', state.phone ?? ''),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _ReviewSection(
              title: 'Shipping Address',
              children: [
                _ReviewRow('Address', state.address ?? ''),
                _ReviewRow('City', state.city ?? ''),
                _ReviewRow('Zip Code', state.zipCode ?? ''),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _ReviewSection(
              title: 'Order Summary',
              children: [
                _ReviewRow('Items', '${cartTotal.items.length}'),
                _ReviewRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                _ReviewRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
                _ReviewRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                const Divider(),
                _ReviewRow(
                  'Total',
                  '\$${total.toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// ─── Section Container ──────────────────────────
class _ReviewSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ReviewSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

// ─── Review Row ─────────────────────────────────
class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReviewRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
                .copyWith(color: AppColors.textHint),
          ),
          Text(
            value,
            style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
                .copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}