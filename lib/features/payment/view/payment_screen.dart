import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_demo_store_card.dart';

export 'package:real_ecommerce/features/payment/view/payment_success_screen.dart';

/// شاشة تجريبية لطرق الدفع (UI فقط — للعرض أو بروتوتايب).
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  static const _methods = <(String, IconData)>[
    ('Credit / Debit Card', Icons.credit_card_rounded),
    ('Cash on Delivery', Icons.payments_outlined),
    ('Apple Pay', Icons.apple_rounded),
    ('Google Pay', Icons.g_mobiledata_rounded),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Payment')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Method', style: AppTypography.h2),
                  const SizedBox(height: AppSpacing.xl),
                  ...List.generate(_methods.length, (i) {
                    final m = _methods[i];
                    final isSelected = i == _selectedMethod;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMethod = i),
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.divider,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              m.$2,
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.textHint,
                              size: 26,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Text(
                                m.$1,
                                style: AppTypography.labelLarge,
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded,
                                  color: AppColors.accent, size: 22)
                            else
                              Icon(Icons.circle_outlined,
                                  color: AppColors.divider, size: 22),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (_selectedMethod == 0) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Text('Card Details', style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.xl),
                    const PaymentDemoStoreCard(),
                    const SizedBox(height: AppSpacing.xxl),
                    const AppTextField(
                      label: 'Card Number',
                      hint: '0000  0000  0000  0000',
                      prefixIcon: Icons.credit_card_rounded,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const AppTextField(
                      label: 'Card Holder',
                      hint: 'Name on card',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Expiry Date',
                            hint: 'MM / YY',
                            prefixIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: AppTextField(
                            label: 'CVV',
                            hint: '***',
                            prefixIcon: Icons.lock_outline_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: AppTypography.bodyMedium),
                    Text('\$409.96', style: AppTypography.priceLarge),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                GradientButton(
                  label: 'Pay Now',
                  onTap: () => context.go(AppRoutes.paymentSuccess),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
