import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// PAYMENT SCREEN
// ═══════════════════════════════════════════════
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final _methods = [
    ('Credit / Debit Card', Icons.credit_card_rounded),
    ('Cash on Delivery', Icons.payments_outlined),
    ('Apple Pay', Icons.apple_rounded),
    ('Google Pay', Icons.g_mobiledata_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                            Radio<int>(
                              value: i,
                              groupValue: _selectedMethod,
                              onChanged: (v) =>
                                  setState(() => _selectedMethod = v!),
                              activeColor: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (_selectedMethod == 0) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Text('Card Details', style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.xl),
                    const CreditCardVisual(),
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
                    Row(
                      children: const [
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
                  onTap: () {
                    context.go(AppRoutes.paymentSuccess);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Credit Card Visual ────────────────────────
class CreditCardVisual extends StatelessWidget {
  const CreditCardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Luxe Store',
                style: AppTypography.h3.copyWith(color: AppColors.white),
              ),
              const Icon(Icons.wifi_rounded, color: Colors.white54, size: 28),
            ],
          ),
          const Spacer(),
          Text(
            '•••• •••• •••• 4242',
            style: AppTypography.h2.copyWith(
              color: AppColors.white,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    'Ahmed Mohamed',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xxl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    '09 / 27',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'VISA',
                  style: AppTypography.h3.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// PAYMENT SUCCESS SCREEN
// ═══════════════════════════════════════════════
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

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
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Order Placed! 🎉', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your order #ORD-2025-0042 has been confirmed.\nExpected delivery in 3-5 business days.',
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
                    _OrderInfoItem(label: 'Order ID', value: '#0042'),
                    _OrderInfoItem(label: 'Amount', value: '\$409.96'),
                    _OrderInfoItem(label: 'Delivery', value: '3-5 Days'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              GradientButton(
                label: 'Track My Order',
                onTap: () {
                  context.go(AppRoutes.orders);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Continue Shopping',
                isOutlined: true,
                onTap: () {
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _OrderInfoItem({required this.label, required this.value});

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