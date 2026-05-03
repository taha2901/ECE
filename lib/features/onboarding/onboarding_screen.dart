import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages =  [
    _OnboardingPage(
      title: 'Discover\nAmazing Products',
      subtitle: 'Explore thousands of curated products from top brands worldwide.',
      icon: Icons.explore_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _OnboardingPage(
      title: 'Fast & Secure\nDelivery',
      subtitle: 'Get your orders delivered to your doorstep safely and on time.',
      icon: Icons.local_shipping_rounded,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      ),
    ),
    _OnboardingPage(
      title: 'Easy & Safe\nPayments',
      subtitle: 'Pay securely with multiple payment options at your fingertips.',
      icon: Icons.payment_rounded,
      gradient: AppColors.accentGradient,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _pages[i],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: AppDurations.normal,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.white
                              : AppColors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (_currentPage == _pages.length - 1)
                    GradientButton(
                      label: 'Get Started',
                      gradient: const LinearGradient(
                        colors: [AppColors.white, AppColors.white],
                      ),
                      onTap: _completeOnboarding,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            'Skip',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _controller.nextPage(
                            duration: AppDurations.normal,
                            curve: Curves.easeInOut,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.huge),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                ),
                child: Icon(icon, size: 50, color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                title,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                subtitle,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}