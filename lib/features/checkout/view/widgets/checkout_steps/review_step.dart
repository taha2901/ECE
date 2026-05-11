import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        if (state.cartTotal == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_couponController.text != (state.coupon ?? '')) {
          _couponController.text = state.coupon ?? '';
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
              title: 'Coupon',
              children: [
                _CouponInput(
                  controller: _couponController,
                  currentCoupon: state.coupon,
                ),
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
                if (state.coupon != null && state.coupon!.isNotEmpty) ...[
                  const Divider(),
                  _ReviewRow('Coupon', state.coupon!),
                ],
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

class _CouponInput extends StatelessWidget {
  final TextEditingController controller;
  final String? currentCoupon;

  const _CouponInput({
    required this.controller,
    required this.currentCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final isApplied = currentCoupon != null && currentCoupon!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Coupon Code',
            hintText: 'Enter coupon code',
            border: const OutlineInputBorder(),
            suffixIcon: TextButton(
              onPressed: () {
                final code = controller.text.trim();
                if (code.isNotEmpty) {
                  context.read<CheckoutCubit>().updateCouponCode(code);
                } else {
                  context.read<CheckoutCubit>().updateCouponCode(null);
                }
              },
              child: Text(isApplied ? 'Update' : 'Apply'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          isApplied
              ? 'Coupon "$currentCoupon" added. It will be sent with the order.'
              : 'Add a coupon code if you have one. Otherwise you can continue without it.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
        ),
      ],
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