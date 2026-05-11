import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/address/view/my_addresses_page.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart' as orders;
import 'package:real_ecommerce/features/orders/logic/states.dart' as orders_state;
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_avatar.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_menu_item.dart';
import 'package:real_ecommerce/features/profile/view/widgets/profile_stat_item.dart';

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
            // ── Profile Header ──────────────────────
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
                  _buildStats(context),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Main Menu ───────────────────────────
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

            // ── Support Menu ─────────────────────────
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

            // ── Auth Button ──────────────────────────
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

  Widget _buildStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BlocBuilder<orders.OrdersCubit, orders_state.OrdersState>(
          builder: (context, orderState) {
            final ordersCount = orderState is orders_state.OrdersLoaded
                ? orderState.orders.length
                : 0;
            return ProfileStatItem(
              value: isLoggedIn ? ordersCount.toString() : '0',
              label: 'Orders',
              onTap: () => isLoggedIn
                  ? context.push(AppRoutes.orders)
                  : onShowLoginDialog(),
            );
          },
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
        BlocBuilder<AddressCubit, AddressState>(
          builder: (context, addressState) {
            final addressCount = addressState.addresses.length;
            return ProfileStatItem(
              value: isLoggedIn ? addressCount.toString() : '0',
              label: 'Addresses',
              onTap: () => isLoggedIn
                  ? context.push(AppRoutes.myAddresses)
                  : onShowLoginDialog(),
            );
          },
        ),
      ],
    );
  }
}