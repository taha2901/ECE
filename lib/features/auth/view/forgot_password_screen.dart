import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// FORGOT PASSWORD SCREEN
// ═══════════════════════════════════════════════
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const BackButton(color: AppColors.textPrimary),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, anim) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
        child: _emailSent
            ? _SuccessView(key: const ValueKey('success'), email: _emailCtrl.text)
            : _FormView(
                key: const ValueKey('form'),
                controller: _emailCtrl,
                onSend: () => setState(() => _emailSent = true),
              ),
      ),
    );
  }
}

// ─── Form View ───────────────────────────────────
class _FormView extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _FormView({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),

          // Icon container
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withOpacity(0.15),
                  AppColors.accent.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 38,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Text(
            'Forgot\nPassword?',
            style: AppTypography.displayMedium.copyWith(height: 1.15),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "No worries! Enter your registered email and we'll send you a reset link.",
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),

          AppTextField(
            label: 'Email Address',
            hint: 'your@email.com',
            prefixIcon: Icons.email_outlined,
            controller: controller,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(label: 'Send Reset Link', onTap: onSend),
        ],
      ),
    );
  }
}

// ─── Success View ────────────────────────────────
class _SuccessView extends StatefulWidget {
  final String email;

  const _SuccessView({super.key, required this.email});

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated success icon
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.success.withOpacity(0.12),
                      AppColors.success.withOpacity(0.06),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 52,
                  color: AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            Text('Check your inbox', style: AppTypography.h1),
            const SizedBox(height: AppSpacing.md),
            Text(
              "We've sent a password reset link to",
              style: AppTypography.bodyMedium.copyWith(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxxl),

            GradientButton(label: 'Open Email App', onTap: () {}),
            const SizedBox(height: AppSpacing.lg),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '← Back to Sign In',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // Didn't receive section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline_rounded,
                      size: 16, color: AppColors.textHint),
                  const SizedBox(width: 8),
                  Text(
                    "Didn't receive it? ",
                    style: AppTypography.bodySmall.copyWith(fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Resend',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}