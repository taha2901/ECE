import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ═══════════════════════════════════════════════
// OTP VERIFICATION SCREEN
// ═══════════════════════════════════════════════
class OtpVerificationScreen extends StatelessWidget {
  final String phoneOrEmail;

  const OtpVerificationScreen({
    super.key,
    required this.phoneOrEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Text('Verification\nCode 🔐', style: AppTypography.displayMedium),
            const SizedBox(height: AppSpacing.md),
            RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium,
                children: [
                  const TextSpan(text: 'We sent a 6-digit code to\n'),
                  TextSpan(
                    text: phoneOrEmail,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            OtpInput(onCompleted: (otp) {}),
            const SizedBox(height: AppSpacing.xxxl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Code expires in', style: AppTypography.bodyMedium),
                  Text(
                    '02:30',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium,
                    children: [
                      const TextSpan(text: "Didn't receive code? "),
                      TextSpan(
                        text: 'Resend',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppColors.accentShadow,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Verify',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// OTP INPUT WIDGET
// ═══════════════════════════════════════════════
class OtpInput extends StatelessWidget {
  final int length;
  final Function(String) onCompleted;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        length,
        (i) => SizedBox(
          width: 48,
          height: 56,
          child: TextFormField(
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTypography.h2,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < length - 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}