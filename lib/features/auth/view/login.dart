import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart'
    hide DividerWithText;
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  // ── Form ──────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
                vertical: AppSpacing.xl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    // ── Headline ────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome\nBack 👋',
                          style: AppTypography.displayMedium.copyWith(
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Sign in to continue shopping',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // ── Fields ──────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: 'Email Address',
                          hint: 'your@email.com',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              v?.isEmpty == true ? 'Please enter email' : null,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Password
                        AppTextField(
                          label: 'Password',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          controller: _passCtrl,

                          validator: (v) => v?.isEmpty == true
                              ? 'Please enter password'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push(AppRoutes.forgotPass),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              AppStrings.forgotPassword,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Bottom section ──────────────────
                    Column(
                      children: [
                        GradientButton(
                          label: AppStrings.signIn,
                          onTap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              // محاكاة تسجيل الدخول
                              await Future.delayed(const Duration(seconds: 1));
                              if (context.mounted) {
                                context.go(AppRoutes.home);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        const DividerWithText(text: 'or continue with'),
                        const SizedBox(height: AppSpacing.xxl),
                        const SocialLoginButtons(),
                        const SizedBox(height: AppSpacing.xxxl),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTypography.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.register),
                              child: Text(
                                'Sign Up',
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
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
