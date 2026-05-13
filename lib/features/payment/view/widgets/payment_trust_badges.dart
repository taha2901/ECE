import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';

/// صف صغير (أيقونة + نص) لشارات الثقة تحت الفورم.
class PaymentTrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const PaymentTrustBadge({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textHint, fontSize: 10),
        ),
      ],
    );
  }
}

class PaymentTrustBadgesRow extends StatelessWidget {
  const PaymentTrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        PaymentTrustBadge(
          icon: Icons.verified_user_outlined,
          label: 'PCI DSS',
        ),
        SizedBox(width: AppSpacing.md),
        PaymentTrustBadge(
          icon: Icons.lock_outline_rounded,
          label: 'Encrypted',
        ),
        SizedBox(width: AppSpacing.md),
        PaymentTrustBadge(
          icon: Icons.replay_rounded,
          label: '3D Secure',
        ),
      ],
    );
  }
}
