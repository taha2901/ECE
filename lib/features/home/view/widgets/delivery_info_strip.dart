import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class DeliveryInfoStrip extends StatelessWidget {
  const DeliveryInfoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          _DeliveryItem(
            icon: Icons.local_shipping_outlined,
            label: 'Free Delivery',
            sub: 'Above \$50',
            color: AppColors.info,
          ),
          Container(width: 1, height: 36, color: AppColors.divider),
          _DeliveryItem(
            icon: Icons.replay_outlined,
            label: 'Easy Return',
            sub: '30 days',
            color: AppColors.success,
          ),
          Container(width: 1, height: 36, color: AppColors.divider),
          _DeliveryItem(
            icon: Icons.verified_outlined,
            label: 'Authentic',
            sub: '100% genuine',
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _DeliveryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;

  const _DeliveryItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            sub,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
