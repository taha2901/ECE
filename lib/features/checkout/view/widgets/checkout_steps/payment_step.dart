import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';

class PaymentStep extends StatefulWidget {
  const PaymentStep({super.key});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  String _selectedPayment = 'deposit';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xl),
        _PaymentOption(
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive your order',
          value: 'deposit',
          groupValue: _selectedPayment,
          onChanged: (value) {
            setState(() => _selectedPayment = value ?? 'deposit');
            context.read<CheckoutCubit>().updatePaymentInfo(paymentMethod: value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _PaymentOption(
          title: 'Credit/Debit Card',
          subtitle: 'Secure payment with your card',
          value: 'card',
          groupValue: _selectedPayment,
          onChanged: (value) {
            setState(() => _selectedPayment = value ?? 'deposit');
            context.read<CheckoutCubit>().updatePaymentInfo(paymentMethod: value);
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        // Info banner
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.accent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Shipping fee will be calculated based on your location.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.accent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Payment Option Card ────────────────────────
class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}