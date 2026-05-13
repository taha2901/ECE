import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_card_preview.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_field_shell.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_trust_badges.dart';

/// فورم حامل الكارت + `CardField` من Stripe + خيار الحفظ.
class PaymentStripeCardForm extends StatefulWidget {
  final ValueChanged<bool> onCardCompleteChanged;
  final bool saveCard;
  final ValueChanged<bool> onSaveCardChanged;

  const PaymentStripeCardForm({
    super.key,
    required this.onCardCompleteChanged,
    required this.saveCard,
    required this.onSaveCardChanged,
  });

  @override
  State<PaymentStripeCardForm> createState() => _PaymentStripeCardFormState();
}

class _PaymentStripeCardFormState extends State<PaymentStripeCardForm> {
  String _displayNumber = '•••• •••• •••• ••••';
  String _displayExpiry = 'MM / YY';
  String _displayHolder = 'YOUR NAME';
  late final TextEditingController _holderController;

  @override
  void initState() {
    super.initState();
    _holderController = TextEditingController();
    _holderController.addListener(() {
      setState(() {
        _displayHolder = _holderController.text.isEmpty
            ? 'YOUR NAME'
            : _holderController.text.toUpperCase();
      });
    });
  }

  @override
  void dispose() {
    _holderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentCardPreview(
          number: _displayNumber,
          expiry: _displayExpiry,
          holder: _displayHolder,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 16, color: AppColors.accent),
            const SizedBox(width: AppSpacing.sm),
            Text('Card Details', style: AppTypography.labelLarge),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security_rounded,
                      size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    'SSL Secured',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          controller: _holderController,
          label: 'Card Holder',
          hint: 'Name on card',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: AppSpacing.xl),
        PaymentFieldShell(
          child: SizedBox(
            height: 54,
            child: CardField(
              onCardChanged: (details) {
                final complete = details?.complete ?? false;
                setState(() {
                  _displayNumber = details?.last4 != null
                      ? '•••• •••• •••• ${details!.last4}'
                      : '•••• •••• •••• ••••';
                  if (details?.expiryMonth != null &&
                      details?.expiryYear != null) {
                    final month =
                        details!.expiryMonth!.toString().padLeft(2, '0');
                    final year = details.expiryYear!.toString();
                    _displayExpiry = year.length == 4
                        ? '$month / ${year.substring(year.length - 2)}'
                        : '$month / $year';
                  } else {
                    _displayExpiry = 'MM / YY';
                  }
                });
                widget.onCardCompleteChanged(complete);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.bookmark_outline_rounded,
                    size: 18, color: AppColors.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Save card for later',
                        style: AppTypography.labelSmall),
                    Text(
                      'Secured via Stripe Vault',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.saveCard,
                onChanged: widget.onSaveCardChanged,
                activeThumbColor: AppColors.accent,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const PaymentTrustBadgesRow(),
      ],
    );
  }
}
