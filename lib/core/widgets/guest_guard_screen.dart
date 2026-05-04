// lib/core/widgets/guest_guard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';

/// يُلف أي شاشة محتاجة توكن.
/// لو المستخدم مسجّل دخول → يعرض [child] عادي.
/// لو مش مسجّل → يعرض شاشة "تسجيل الدخول مطلوب" بديزاين لطيف.
class GuestGuardScreen extends StatelessWidget {
  final Widget child;
  final String featureName; // اسم الميزة المحجوبة  e.g. "Cart"

  const GuestGuardScreen({
    super.key,
    required this.child,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoggedIn = state.status == AuthStatus.success;
        if (isLoggedIn) return child;
        return _LoginPromptScreen(featureName: featureName);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// PRIVATE: Beautiful Login Prompt UI
// ─────────────────────────────────────────────────────────

class _LoginPromptScreen extends StatefulWidget {
  final String featureName;
  const _LoginPromptScreen({required this.featureName});

  @override
  State<_LoginPromptScreen> createState() => _LoginPromptScreenState();
}

class _LoginPromptScreenState extends State<_LoginPromptScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // أيقونة مناسبة لكل ميزة
  IconData _iconFor(String feature) {
    switch (feature.toLowerCase()) {
      case 'cart':
        return Icons.shopping_bag_outlined;
      case 'wishlist':
        return Icons.favorite_outline_rounded;
      case 'profile':
        return Icons.person_outline_rounded;
      case 'orders':
        return Icons.receipt_long_outlined;
      default:
        return Icons.lock_outline_rounded;
    }
  }

  String _subtitleFor(String feature) {
    switch (feature.toLowerCase()) {
      case 'cart':
        return 'Sign in to add items to your cart\nand complete your purchase.';
      case 'wishlist':
        return 'Sign in to save your favourite\nitems and shop later.';
      case 'profile':
        return 'Sign in to manage your account,\norders, and preferences.';
      default:
        return 'Sign in to access this feature.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(widget.featureName);
    final subtitle = _subtitleFor(widget.featureName);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Animated illustration ──────────────────
              ScaleTransition(
                scale: _scaleAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: _IllustrationCircle(icon: icon),
                ),
              ),

              const SizedBox(height: 36),

              // ── Text block ────────────────────────────
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      Text(
                        'Sign in Required',
                        style: AppTypography.h2.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textHint,
                          height: 1.6,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // ── Buttons ───────────────────────────────
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      // Primary CTA
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.push(AppRoutes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Secondary: Create account
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => context.push(AppRoutes.register),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: BorderSide(
                              color: AppColors.accent.withOpacity(0.4),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.accent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Decorative icon circle ──────────────────────────────

class _IllustrationCircle extends StatelessWidget {
  final IconData icon;
  const _IllustrationCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer soft ring
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withOpacity(0.06),
          ),
        ),
        // Mid ring
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withOpacity(0.10),
          ),
        ),
        // Inner filled circle
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 44,
            color: Colors.white,
          ),
        ),

        // Small lock badge on top-right
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.lock_rounded,
              size: 16,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}