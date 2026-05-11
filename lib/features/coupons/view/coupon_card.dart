import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/coupons/data/models/coupon_model.dart';

class ActiveCouponCard extends StatelessWidget {
  final CouponModel coupon;

  const ActiveCouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 100,
            decoration: BoxDecoration(
              gradient: coupon.isActive
                  ? AppColors.accentGradient
                  : const LinearGradient(
                      colors: [AppColors.textHint, AppColors.textHint],
                    ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.xl),
                bottomLeft: Radius.circular(AppRadius.xl),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.title,
                          style: AppTypography.h2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(
                              color: AppColors.divider,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(
                            coupon.code,
                            style: AppTypography.labelLarge.copyWith(
                              letterSpacing: 2,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (coupon.description != null)
                          Text(
                            coupon.description!,
                            style: AppTypography.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          coupon.expiresAt != null
                              ? 'Expires ${coupon.expiryLabel}'
                              : 'No expiry',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (coupon.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'Active',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
