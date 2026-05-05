import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/address/view/my_addresses_page.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_avatar.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_menu_item.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_stat_item.dart';

/// Layout الديسكتوب:
///   ┌────────────────┬──────────────────────────┐
///   │  Sidebar       │  Content                 │
///   │  Avatar        │  Main Menu               │
///   │  Stats         │  Support Menu            │
///   │  Sign Out      │                          │
///   └────────────────┴──────────────────────────┘
class ProfileDesktop extends StatelessWidget {
  final String displayName;
  final String subtitle;
  final String? username;
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const ProfileDesktop({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.username,
    required this.isLoggedIn,
    required this.onShowLoginDialog,
  });

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Sidebar ────────────────────────────
                SizedBox(
                  width: 280,
                  child: _ProfileSidebar(
                    displayName: displayName,
                    subtitle: subtitle,
                    username: username,
                    isLoggedIn: isLoggedIn,
                    onShowLoginDialog: onShowLoginDialog,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),

                // ── Main Content ───────────────────────
                Expanded(
                  child: _ProfileContent(
                    isLoggedIn: isLoggedIn,
                    onShowLoginDialog: onShowLoginDialog,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// SIDEBAR — avatar + stats + sign out
// ══════════════════════════════════════════════
class _ProfileSidebar extends StatelessWidget {
  final String displayName;
  final String subtitle;
  final String? username;
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const _ProfileSidebar({
    required this.displayName,
    required this.subtitle,
    this.username,
    required this.isLoggedIn,
    required this.onShowLoginDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              ProfileAvatar(
                displayName: displayName,
                subtitle: subtitle,
                username: username,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildStats(context),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Sign Out Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: isLoggedIn
              ? AppButton(
                  label: 'Sign Out',
                  isOutlined: true,
                  onTap: () => context.read<AuthCubit>().logout(),
                  backgroundColor: AppColors.error.withOpacity(0.05),
                )
              : AppButton(
                  label: 'Sign In',
                  onTap: () => context.go(AppRoutes.login),
                ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatItem(
          value: isLoggedIn ? '12' : '0',
          label: 'Orders',
          onTap: () => isLoggedIn
              ? context.push(AppRoutes.orders)
              : onShowLoginDialog(),
        ),
        const ProfileStatDivider(),
        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, wishlistState) {
            final count = wishlistState is WishlistLoaded
                ? wishlistState.items.length
                : 0;
            return ProfileStatItem(
              value: isLoggedIn ? count.toString() : '0',
              label: 'Wishlist',
            );
          },
        ),
        const ProfileStatDivider(),
        ProfileStatItem(
          value: isLoggedIn ? '2' : '0',
          label: 'Addresses',
          onTap: () => isLoggedIn
              ? context.push(AppRoutes.myAddresses)
              : onShowLoginDialog(),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// CONTENT — menus على اليمين
// ══════════════════════════════════════════════
class _ProfileContent extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const _ProfileContent({
    required this.isLoggedIn,
    required this.onShowLoginDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Menu Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.lg,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: Text(
                  'Account',
                  style: AppColors.textSecondary != null
                      ? null
                      : null, // placeholder — استخدم AppTypography.labelLarge لو حابب
                ),
              ),
              ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                label: 'My Orders',
                iconColor: const Color(0xFF6366F1),
                onTap: () => isLoggedIn
                    ? context.push(AppRoutes.orders)
                    : onShowLoginDialog(),
              ),
              ProfileMenuItem(
                icon: Icons.location_on_outlined,
                label: 'My Addresses',
                iconColor: const Color(0xFF10B981),
                onTap: () => isLoggedIn
                    ? Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => const MyAddressesPage(),
                        ),
                      )
                    : onShowLoginDialog(),
              ),
              ProfileMenuItem(
                icon: Icons.local_offer_outlined,
                label: 'Offers & Coupons',
                iconColor: const Color(0xFFE94560),
                showDivider: false,
                onTap: () => isLoggedIn
                    ? context.push(AppRoutes.offers)
                    : onShowLoginDialog(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Support Menu Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: () {},
              ),
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                label: 'About Us',
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}