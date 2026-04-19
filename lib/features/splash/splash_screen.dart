import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// SPLASH SCREEN
// ═══════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 44,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.appName,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.tagline,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
