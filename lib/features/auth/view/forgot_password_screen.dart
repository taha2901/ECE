import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

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
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: _emailSent
            ? _SuccessView(email: _emailCtrl.text)
            : _FormView(
                controller: _emailCtrl,
                onSend: () => setState(() => _emailSent = true),
              ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _FormView({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            size: 36,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text('Forgot\nPassword?', style: AppTypography.displayMedium),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Enter your registered email address. We'll send you a link to reset your password.",
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        AppTextField(
          label: 'Email Address',
          hint: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.xxl),
        GradientButton(label: 'Send Reset Link', onTap: onSend),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;

  const _SuccessView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 50,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Check your email', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.md),
          Text(
            "We've sent a password reset link to\n$email",
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          AppButton(label: 'Open Email App', onTap: () {}),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Sign In',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}