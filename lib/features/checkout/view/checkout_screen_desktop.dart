import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_step_indicator.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/customer_info_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/payment_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/review_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/shipping_step.dart';

// ══════════════════════════════════════════════════════
// DESKTOP LAYOUT
//
//  ┌─── AppBar ──────────────────────────────────────┐
//  ├─────────────────┬───────────────────────────────┤
//  │  Sidebar 300px  │  Step Content  (scrollable)   │
//  │                 │                               │
//  │  ● Step         │  [ Form fields ]              │
//  │  │              │                               │
//  │  ● Step         │                               │
//  │  │              │                               │
//  │  ● Step         ├───────────────────────────────┤
//  │  │              │  [ Continue / Place Order ]   │
//  │  ● Step         │                               │
//  │                 │                               │
//  │  ─────────────  │                               │
//  │  Order Summary  │                               │
//  └─────────────────┴───────────────────────────────┘
// ══════════════════════════════════════════════════════
class EnhancedCheckoutDesktop extends StatelessWidget {
  final int currentStep;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipCodeController;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final VoidCallback onPlaceOrder;

  const EnhancedCheckoutDesktop({
    super.key,
    required this.currentStep,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.zipCodeController,
    required this.onBack,
    required this.onCancel,
    required this.onNext,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cancel Checkout',
            onPressed: onCancel,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Sidebar ──────────────────────────────
                SizedBox(
                  width: 300,
                  child: _CheckoutSidebar(currentStep: currentStep),
                ),
                const SizedBox(width: AppSpacing.xl),

                // ── Step Content + Button ─────────────────
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: _buildStep(),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Action Button ───────────────────
                      BlocBuilder<CheckoutCubit, CheckoutState>(
                        builder: (context, state) {
                          final isLoading =
                              state.status == CheckoutStatus.creatingOrder;
                          return GradientButton(
                            label: currentStep == 3
                                ? (isLoading ? 'Placing Order...' : 'Place Order')
                                : 'Continue',
                            onTap: isLoading
                                ? null
                                : currentStep == 3
                                    ? onPlaceOrder
                                    : onNext,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (currentStep) {
      0 => CustomerInfoStep(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
        ),
      1 => ShippingStep(
          addressController: addressController,
          cityController: cityController,
          zipCodeController: zipCodeController,
        ),
      2 => const PaymentStep(),
      _ => const ReviewStep(),
    };
  }
}

// ══════════════════════════════════════════════════════
// SIDEBAR — Step Indicator + Order Summary
// ══════════════════════════════════════════════════════
class _CheckoutSidebar extends StatelessWidget {
  final int currentStep;

  const _CheckoutSidebar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step Indicator Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Progress', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.xl),
              CheckoutStepIndicatorVertical(currentStep: currentStep),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Order Summary Card
        BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final cartTotal = state.cartTotal;
            if (cartTotal == null) return const SizedBox.shrink();

            final subtotal = cartTotal.totalAsDouble;
            final shipping = state.shippingFee ?? 10.0;
            final tax = state.tax ?? 0.0;
            final total = subtotal + shipping + tax;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.lg),
                  _SummaryLine(
                    label: 'Items (${cartTotal.items.length})',
                    value: '\$${subtotal.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SummaryLine(
                    label: 'Shipping',
                    value: '\$${shipping.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SummaryLine(
                    label: 'Tax',
                    value: '\$${tax.toStringAsFixed(2)}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Divider(),
                  ),
                  _SummaryLine(
                    label: 'Total',
                    value: '\$${total.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Summary Line ───────────────────────────────
class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryLine({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold ? AppTypography.labelLarge : AppTypography.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style.copyWith(
            color: isBold ? AppColors.textPrimary : AppColors.textHint,
          ),
        ),
        Text(
          value,
          style: style.copyWith(
            color: isBold ? AppColors.accent : AppColors.textPrimary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}