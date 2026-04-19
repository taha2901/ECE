import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/auth/view/widgets/auth_widgets.dart';

// ═══════════════════════════════════════════════
// LOGIN SCREEN
// ═══════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxxl),
                // Logo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text('Welcome\nBack 👋', style: AppTypography.displayMedium),
                const SizedBox(height: AppSpacing.sm),
                Text('Sign in to continue shopping', style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xxxl),

                AppTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v?.isEmpty == true ? 'Please enter email' : null,
                ),
                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: (v) =>
                      v?.isEmpty == true ? 'Please enter password' : null,
                ),
                const SizedBox(height: AppSpacing.md),

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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                GradientButton(
                  label: AppStrings.signIn,
                  isLoading: _isLoading,
                  onTap: () {
                    if (_formKey.currentState?.validate() == true) {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                const DividerWithText(text: 'or continue with'),
                const SizedBox(height: AppSpacing.xxl),

                const SocialLoginButtons(),
                const SizedBox(height: AppSpacing.xxxl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTypography.bodyMedium),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.register),
                      child: Text(
                        'Sign Up',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
