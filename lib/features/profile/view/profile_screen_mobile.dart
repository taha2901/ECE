import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/address/view/my_addresses_page.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_avatar.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_menu_item.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_stats_row.dart';

/// Layout الموبايل: Scaffold عادي مع SingleChildScrollView
class ProfileMobile extends StatelessWidget {
  final String displayName;
  final String subtitle;
  final String? username;
  final String phone;
  final String location;
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const ProfileMobile({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.username,
    required this.phone,
    required this.location,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  ProfileAvatar(
                    displayName: displayName,
                    subtitle: subtitle,
                    username: username,
                    phone: phone,
                    location: location,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ProfileStatsRow(
                    isLoggedIn: isLoggedIn,
                    onShowLoginDialog: onShowLoginDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              color: AppColors.white,
              child: Column(
                children: [
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
                    onTap: () => isLoggedIn
                        ? context.push(AppRoutes.offers)
                        : onShowLoginDialog(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              color: AppColors.white,
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
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: isLoggedIn
                  ? AppButton(
                      label: 'Sign Out',
                      isOutlined: true,
                      onTap: () => context.read<AuthCubit>().logout(),
                      backgroundColor: AppColors.error.withValues(alpha: 0.05),
                    )
                  : AppButton(
                      label: 'Sign In',
                      onTap: () => context.go(AppRoutes.login),
                    ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
