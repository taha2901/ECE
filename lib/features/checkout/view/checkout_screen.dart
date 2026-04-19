import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// CHECKOUT SCREEN
// ═══════════════════════════════════════════════
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;

  void _handleBack(BuildContext context) {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  Future<void> _handleCancel(BuildContext context) async {
    // لو في أول خطوة اخرج مباشرة
    if (_step == 0) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
      return;
    }

    // لو في خطوة 1 أو 2 → اسأل تأكيد
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: const Text('Cancel Checkout?'),
        content: const Text(
          'Your progress will be lost.\nAre you sure you want to go back to cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => _handleBack(context),
        ),
        // زرار × يرجعك للكارت دفعة واحدة
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cancel Checkout',
            onPressed: () => _handleCancel(context),
          ),
        ],
      ),
      body: Column(
        children: [
          CheckoutStepIndicator(currentStep: _step),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: [
                const AddressStepContent(),
                const ShippingStepContent(),
                const ReviewStepContent(),
              ][_step],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            color: AppColors.white,
            child: GradientButton(
              label: _step == 2 ? 'Place Order' : 'Continue',
              onTap: () {
                if (_step < 2) {
                  setState(() => _step++);
                } else {
                  context.go(AppRoutes.payment);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step Indicator ────────────────────────────
class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicator({super.key, required this.currentStep});

  final _steps = const ['Address', 'Shipping', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepBefore = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepBefore < currentStep
                    ? AppColors.accent
                    : AppColors.divider,
              ),
            );
          }
          final step = i ~/ 2;
          final isCompleted = step < currentStep;
          final isCurrent = step == currentStep;

          return Column(
            children: [
              AnimatedContainer(
                duration: AppDurations.normal,
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : isCurrent
                      ? AppColors.accent
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : Icons.circle,
                  size: isCompleted ? 18 : 10,
                  color: isCompleted || isCurrent
                      ? AppColors.white
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _steps[step],
                style: AppTypography.labelSmall.copyWith(
                  color: isCurrent ? AppColors.accent : AppColors.textHint,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Step 1: Address ───────────────────────────
class AddressStepContent extends StatelessWidget {
  const AddressStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Address', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xl),
        _SavedAddressCard(isSelected: true),
        const SizedBox(height: AppSpacing.lg),
        _SavedAddressCard(isSelected: false),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          onPressed: () {
            context.go(AppRoutes.addAddress);
          },
          icon: const Icon(Icons.add_location_outlined),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ],
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  final bool isSelected;

  const _SavedAddressCard({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isSelected ? AppColors.accent : AppColors.divider,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.home_outlined,
              color: isSelected ? AppColors.accent : AppColors.textHint,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSelected ? 'Home' : 'Office',
                  style: AppTypography.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '123 El-Tahrir St, Cairo, Egypt',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: AppColors.white),
            ),
        ],
      ),
    );
  }
}

// ─── Step 2: Shipping ──────────────────────────
class ShippingStepContent extends StatefulWidget {
  const ShippingStepContent({super.key});

  @override
  State<ShippingStepContent> createState() => _ShippingStepContentState();
}

class _ShippingStepContentState extends State<ShippingStepContent> {
  int _selected = 0;

  final _options = [
    (
      'Standard Delivery',
      '3-5 Business Days',
      '\$4.99',
      Icons.local_shipping_rounded,
    ),
    ('Express Delivery', '1-2 Business Days', '\$9.99', Icons.flash_on_rounded),
    ('Same Day Delivery', 'Today by 10 PM', '\$19.99', Icons.bolt_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Method', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xl),
        ...List.generate(_options.length, (i) {
          final o = _options[i];
          final isSelected = i == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.divider,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withOpacity(0.1)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      o.$4,
                      color: isSelected ? AppColors.accent : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.$1, style: AppTypography.labelLarge),
                        Text(o.$2, style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  Text(o.$3, style: AppTypography.priceMedium),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Step 3: Review ────────────────────────────
class ReviewStepContent extends StatelessWidget {
  const ReviewStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Review', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Items (3)', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.lg),
              ...List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Container(
                          width: 52,
                          height: 52,
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 24,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Name',
                              style: AppTypography.labelLarge.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Qty: 1 • Size M',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text('\$149.99', style: AppTypography.priceSmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: const Column(
            children: [
              _ReviewPriceRow(label: 'Subtotal', value: '\$449.97'),
              _ReviewPriceRow(label: 'Shipping', value: '\$9.99'),
              _ReviewPriceRow(label: 'Discount', value: '-\$50.00', isDiscount: true),
              Divider(),
              _ReviewPriceRow(label: 'Total', value: '\$409.96', isTotal: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewPriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;
  final bool isTotal;

  const _ReviewPriceRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTypography.h3 : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.priceLarge
                : isDiscount
                ? AppTypography.labelLarge.copyWith(color: AppColors.success)
                : AppTypography.labelLarge,
          ),
        ],
      ),
    );
  }
}