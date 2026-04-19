import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ═══════════════════════════════════════════════
// SOCIAL LOGIN BUTTONS
// ═══════════════════════════════════════════════
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialBtn(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            color: const Color(0xFFEA4335),
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _SocialBtn(
            label: 'Apple',
            icon: Icons.apple_rounded,
            color: AppColors.primary,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppTypography.labelLarge),
          ],
        ),
      ),
    );
  }
}