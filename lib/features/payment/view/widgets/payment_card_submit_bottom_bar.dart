import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/payment/logic/cubit.dart';
import 'package:real_ecommerce/features/payment/logic/states.dart';

/// زر الدفع السفلي لمسار الكارت (يختفي عند اختيار Google Pay).
class PaymentCardSubmitBottomBar extends StatelessWidget {
  final bool cardComplete;
  final int selectedMethodIndex;

  const PaymentCardSubmitBottomBar({
    super.key,
    required this.cardComplete,
    required this.selectedMethodIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (selectedMethodIndex == 1) return const SizedBox.shrink();

        final isLoading = state is PaymentLoading;
        final isReady = state is CheckoutSuccess || state is PaymentFailure;
        final canPay = isReady && cardComplete && !isLoading;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is PaymentFailure)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            state.message,
                            style: AppTypography.bodySmall
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              GradientButton(
                label: isLoading ? 'Processing…' : 'Pay Now',
                onTap: canPay ? () => _submitCardPayment(context) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitCardPayment(BuildContext context) {
    final s = context.read<CheckoutCubit>().state;
    context.read<PaymentCubit>().confirmPayment(
          name: '${s.firstName ?? ''} ${s.lastName ?? ''}'.trim(),
          email: s.email ?? '',
        );
  }
}
