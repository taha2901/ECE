import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/address/view/my_addresses_page.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text('You need to sign in to access this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.login);
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loggedOut) {
          context.go(AppRoutes.login);
        }
      },
      builder: (context, authState) {
        final user = authState.authData?.user;
        final isLoggedIn = user != null;

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
                            child: const Icon(
                              Icons.person_rounded,
                              size: 44,
                              color: AppColors.white,
                            ),
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
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        isLoggedIn
                            ? '${user.firstName} ${user.lastName}'
                            : 'Guest User',
                        style: AppTypography.h2,
                      ),
                      Text(
                        isLoggedIn
                            ? user.email
                            : 'Please sign in to view your profile',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => isLoggedIn
                                ? context.push(AppRoutes.orders)
                                : _showLoginDialog(context),
                            child: _StatItem(
                              value: isLoggedIn ? '12' : '0',
                              label: 'Orders',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.divider,
                          ),
                          _StatItem(
                            value: isLoggedIn ? '8' : '0',
                            label: 'Wishlist',
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.divider,
                          ),
                          GestureDetector(
                            onTap: () => isLoggedIn
                                ? context.push(AppRoutes.myAddresses)
                                : _showLoginDialog(context),
                            child: _StatItem(
                              value: isLoggedIn ? '2' : '0',
                              label: 'Addresses',
                            ),
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
                        onTap: () => isLoggedIn
                            ? context.push(AppRoutes.orders)
                            : _showLoginDialog(context),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        label: 'My Addresses',
                        iconColor: const Color(0xFF10B981),
                        onTap: () => isLoggedIn
                            ? Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (_) => const MyAddressesPage(),
                                ),
                              )
                            : _showLoginDialog(context),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.credit_card_rounded,
                        label: 'Payment Methods',
                        iconColor: const Color(0xFF3B82F6),
                        onTap: () => isLoggedIn
                            ? context.push(AppRoutes.payment)
                            : _showLoginDialog(context),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.local_offer_outlined,
                        label: 'Offers & Coupons',
                        iconColor: const Color(0xFFE94560),
                        onTap: () => isLoggedIn
                            ? context.push(AppRoutes.offers)
                            : _showLoginDialog(context),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        iconColor: const Color(0xFFF59E0B),
                        onTap: () => isLoggedIn
                            ? context.push(AppRoutes.notifications)
                            : _showLoginDialog(context),
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
                if (isLoggedIn && user.isAdmin)
                  Container(
                    color: AppColors.white,
                    child: _ProfileMenuItem(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Admin Dashboard',
                      iconColor: const Color(0xFF4F46E5),
                      onTap: () => context.push(AppRoutes.adminDashboard),
                    ),
                  ),
                if (isLoggedIn && user.isAdmin)
                  const SizedBox(height: AppSpacing.lg),

                // ── Sign Out ────────────────────────
                if (isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: AppButton(
                      label: 'Sign Out',
                      isOutlined: true,
                      onTap: () => context.read<AuthCubit>().logout(),
                      backgroundColor: AppColors.error.withOpacity(0.05),
                    ),
                  ),
                if (!isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: AppButton(
                      label: 'Sign In',
                      onTap: () => context.go(AppRoutes.login),
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
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
            Expanded(child: Text(label, style: AppTypography.labelLarge)),
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
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
