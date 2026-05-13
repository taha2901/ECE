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

/// شاشة نجاح / فشل الطلب بعد الدفع.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, checkoutState) {
        if (checkoutState.status == CheckoutStatus.error) {
          return _PaymentFailureLayout(
            message: checkoutState.errorMessage ?? 'Failed to create order.',
          );
        }

        final order = checkoutState.createdOrder;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).unfocus();
        });

        return Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Order Placed! 🎉',
                      style: AppTypography.displayMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    order != null
                        ? 'Your order #${order.id} has been confirmed.\nExpected delivery in 3-5 business days.'
                        : 'Your order has been confirmed.\nExpected delivery in 3-5 business days.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PaymentOrderFact(
                          label: 'Order ID',
                          value: order != null ? '#${order.id}' : '#0042',
                        ),
                        PaymentOrderFact(
                          label: 'Amount',
                          value:
                              '\$${checkoutState.cartTotal?.total ?? '409.96'}',
                        ),
                        const PaymentOrderFact(
                          label: 'Delivery',
                          value: '3-5 Days',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  GradientButton(
                    label: 'Track My Order',
                    onTap: () => context.go(AppRoutes.orders),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Continue Shopping',
                    isOutlined: true,
                    onTap: () => context.go(AppRoutes.home),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PaymentOrderFact extends StatelessWidget {
  final String label;
  final String value;

  const PaymentOrderFact({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge),
      ],
    );
  }
}

class _PaymentFailureLayout extends StatelessWidget {
  final String message;

  const _PaymentFailureLayout({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Order Failed', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              GradientButton(
                label: 'Try Again',
                onTap: () => context.go(AppRoutes.enhancedCheckout),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Contact Support',
                isOutlined: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
