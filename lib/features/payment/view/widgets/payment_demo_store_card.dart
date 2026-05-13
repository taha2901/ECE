import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

/// كارت تجريبي للعرض في شاشة اختيار طريقة الدفع (بدون Stripe).
class PaymentDemoStoreCard extends StatelessWidget {
  const PaymentDemoStoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
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
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    'Ahmed Mohamed',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.white),
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
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '09 / 27',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
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
