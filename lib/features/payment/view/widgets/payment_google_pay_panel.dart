import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/payment/logic/payment_order_completion.dart';
import 'package:real_ecommerce/features/payment/logic/cubit.dart';
import 'package:real_ecommerce/features/payment/logic/states.dart';

/// لوحة Google Pay + `PlatformPayButton` بعد جاهزية الـ client secret.
class PaymentGooglePayPanel extends StatelessWidget {
  const PaymentGooglePayPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final clientSecret =
            state is CheckoutSuccess ? state.clientSecret : null;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              const Icon(Icons.g_mobiledata_rounded,
                  size: 48, color: AppColors.accent),
              const SizedBox(height: AppSpacing.md),
              Text('Google Pay', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fast and secure payment with your Google account',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textHint),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (clientSecret != null)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PlatformPayButton(
                    onPressed: () async =>
                        _confirmGooglePay(context, clientSecret),
                    type: PlatformButtonType.pay,
                  ),
                )
              else
                const CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmGooglePay(
    BuildContext context,
    String clientSecret,
  ) async {
    try {
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret,
        confirmParams: const PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            testEnv: true,
            merchantName: 'LuxeStore',
            merchantCountryCode: 'US',
            currencyCode: 'USD',
          ),
        ),
      );
      if (!context.mounted) return;
      await finalizePaidCheckoutAndNavigate(context);
    } on StripeException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error.localizedMessage ?? 'Google Pay failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
