import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ═══════════════════════════════════════════════
// SOCIAL LOGIN BUTTONS — Simplified version
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
            icon: Icons.g_mobiledata, // ✅ أيقونة جوجل جاهزة
            color: const Color(0xFFEA4335),
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _SocialBtn(
            label: 'Apple',
            icon: Icons.apple_rounded, // ✅ أيقونة آبل جاهزة
            color: AppColors.primary,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

// ✅ Stateless Widget - بدون AnimationController غير الضروري
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider, width: 1.5),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22), // ✅ مباشر بدون تعقيد
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// DIVIDER WITH TEXT
// ═══════════════════════════════════════════════
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppColors.divider),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textHint,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.divider),
        ),
      ],
    );
  }
}