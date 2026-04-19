import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ──────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Icon(Icons.person_rounded, size: 44, color: AppColors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Ahmed Mohamed', style: AppTypography.h2),
                  Text('ahmed@example.com', style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.orders),
                        child: _StatItem(value: '12', label: 'Orders'),
                      ),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      _StatItem(value: '8', label: 'Wishlist'),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.myAddresses),
                        child: _StatItem(value: '2', label: 'Addresses'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Main Menu ───────────────────────
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Orders',
                    iconColor: const Color(0xFF6366F1),
                    onTap: () => context.push(AppRoutes.orders),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'My Addresses',
                    iconColor: const Color(0xFF10B981),
                    onTap: () => context.push(AppRoutes.myAddresses),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.credit_card_rounded,
                    label: 'Payment Methods',
                    iconColor: const Color(0xFF3B82F6),
                    onTap: () => context.push(AppRoutes.payment),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.local_offer_outlined,
                    label: 'Offers & Coupons',
                    iconColor: const Color(0xFFE94560),
                    onTap: () => context.push(AppRoutes.offers),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    iconColor: const Color(0xFFF59E0B),
                    onTap: () => context.push(AppRoutes.notifications),
                    badge: '3',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Support Menu ────────────────────
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Admin Panel ─────────────────────
            Container(
              color: AppColors.white,
              child: _ProfileMenuItem(
                icon: Icons.admin_panel_settings_outlined,
                label: 'Admin Dashboard',
                iconColor: const Color(0xFF4F46E5),
                onTap: () => context.push(AppRoutes.adminDashboard),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Sign Out ────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: AppButton(
                label: 'Sign Out',
                isOutlined: true,
                onTap: () => context.go(AppRoutes.login),
                backgroundColor: AppColors.error.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.h2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final Color? iconColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor != null
                    ? iconColor!.withOpacity(0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(label, style: AppTypography.labelLarge),
            ),
            if (badge != null)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}