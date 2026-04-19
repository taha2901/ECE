import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';



class RegisterScreen extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  RegisterScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: _BackBtn(),
        title: Text(
          'Create Account',
          style: AppTypography.h3.copyWith(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Headline ──────────────────────────
              Text(
                'Join LuxeStore ✨',
                style: AppTypography.displayMedium.copyWith(height: 1.2),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fill in your details to get started',
                style: AppTypography.bodyMedium.copyWith(fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.xxl),

              const SizedBox(height: AppSpacing.xxl),

              // ── Full Name ─────────────────────────
              const _FieldLabel(label: 'Full Name'),
              AppTextField(
                label: '',
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameCtrl,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Email ─────────────────────────────
              const _FieldLabel(label: 'Email Address'),
              AppTextField(
                label: '',
                hint: 'your@email.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Phone ─────────────────────────────
              const _FieldLabel(label: 'Phone Number'),
              AppTextField(
                label: '',
                hint: '+20 1XX XXX XXXX',
                prefixIcon: Icons.phone_outlined,
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Password ──────────────────────────
              const _FieldLabel(label: 'Password'),
              AppTextField(
                label: '',
                hint: 'Minimum 8 characters',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _passCtrl,

                validator: (v) =>
                    (v?.length ?? 0) < 8 ? 'Minimum 8 characters' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Confirm Password ──────────────────
              const _FieldLabel(label: 'Confirm Password'),
              AppTextField(
                label: '',
                hint: 'Repeat your password',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _confirmPassCtrl,

                validator: (v) =>
                    v != _passCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Terms ─────────────────────────────
              _TermsRow(value: true, onChanged: (v) {}),
              const SizedBox(height: AppSpacing.xxl),

              // ── Submit ────────────────────────────
              GradientButton(label: AppStrings.signUp),
              const SizedBox(height: AppSpacing.xl),

              // ── Login link ────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Sign In',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  PRIVATE WIDGETS
// ══════════════════════════════════════════════════════════

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const BackButton(color: AppColors.textPrimary),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? AppColors.accent : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.accent : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 14,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodySmall.copyWith(fontSize: 13),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 13,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 13,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
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
