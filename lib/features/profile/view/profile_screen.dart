// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:real_ecommerce/core/routers/app_router.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/themes/app_typography.dart';
// import 'package:real_ecommerce/features/address/view/my_addresses_page.dart';
// import 'package:real_ecommerce/features/auth/logic/cubit.dart';
// import 'package:real_ecommerce/features/auth/logic/states.dart';
// import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
// import 'package:real_ecommerce/features/wishlist/logic/states.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../../core/widgets/common_widgets.dart';

// // ═══════════════════════════════════════════════
// // PROFILE SCREEN
// // ═══════════════════════════════════════════════
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authState = context.read<AuthCubit>().state;
//       final wishlistState = context.read<WishlistCubit>().state;
//       if (authState.isSuccess &&
//           wishlistState is! WishlistLoaded &&
//           wishlistState is! WishlistLoading) {
//         context.read<WishlistCubit>().loadWishlist();
//       }
//     });
//   }

//   void _showLoginDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Sign In Required'),
//         content: const Text('You need to sign in to access this feature.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               context.go(AppRoutes.login);
//             },
//             child: const Text('Sign In'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, authState) {
//         if (authState.status == AuthStatus.loggedOut) {
//           context.go(AppRoutes.login);
//         }
//       },
//       child: BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, authState) {
//           final user = authState.authData?.user;
//           final isLoggedIn = authState.status == AuthStatus.success;
//           final displayName = user != null
//               ? '${user.firstName} ${user.lastName}'
//               : isLoggedIn
//               ? 'Signed In'
//               : 'Guest User';
//           final subtitle = user != null
//               ? user.email
//               : isLoggedIn
//               ? 'You are signed in'
//               : 'Please sign in to view your profile';

//           return Scaffold(
//             backgroundColor: AppColors.background,
//             appBar: AppBar(
//               title: const Text('My Profile'),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.settings_outlined),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // ── Profile Header ──────────────────
//                   Container(
//                     color: AppColors.white,
//                     padding: const EdgeInsets.all(AppSpacing.pagePadding),
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: [
//                             Container(
//                               width: 88,
//                               height: 88,
//                               decoration: BoxDecoration(
//                                 gradient: AppColors.primaryGradient,
//                                 shape: BoxShape.circle,
//                                 boxShadow: AppColors.cardShadow,
//                               ),
//                               child: const Icon(
//                                 Icons.person_rounded,
//                                 size: 44,
//                                 color: AppColors.white,
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 26,
//                                 height: 26,
//                                 decoration: const BoxDecoration(
//                                   color: AppColors.accent,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.camera_alt_rounded,
//                                   size: 14,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: AppSpacing.lg),
//                         Text(displayName, style: AppTypography.h2),
//                         Text(subtitle, style: AppTypography.bodyMedium),
//                         if (user != null && user.username.isNotEmpty) ...[
//                           const SizedBox(height: AppSpacing.xs),
//                           Text(
//                             'Username: ${user.username}',
//                             style: AppTypography.bodySmall,
//                           ),
//                         ],
//                         const SizedBox(height: AppSpacing.xl),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             GestureDetector(
//                               onTap: () => isLoggedIn
//                                   ? context.push(AppRoutes.orders)
//                                   : _showLoginDialog(context),
//                               child: _StatItem(
//                                 value: isLoggedIn ? '12' : '0',
//                                 label: 'Orders',
//                               ),
//                             ),
//                             Container(
//                               width: 1,
//                               height: 40,
//                               color: AppColors.divider,
//                             ),
//                             BlocBuilder<WishlistCubit, WishlistState>(
//                               builder: (context, wishlistState) {
//                                 final wishlistCount =
//                                     wishlistState is WishlistLoaded
//                                     ? wishlistState.items.length
//                                     : isLoggedIn
//                                     ? 0
//                                     : 0;

//                                 return _StatItem(
//                                   value: isLoggedIn
//                                       ? wishlistCount.toString()
//                                       : '0',
//                                   label: 'Wishlist',
//                                 );
//                               },
//                             ),
//                             Container(
//                               width: 1,
//                               height: 40,
//                               color: AppColors.divider,
//                             ),
//                             GestureDetector(
//                               onTap: () => isLoggedIn
//                                   ? context.push(AppRoutes.myAddresses)
//                                   : _showLoginDialog(context),
//                               child: _StatItem(
//                                 value: isLoggedIn ? '2' : '0',
//                                 label: 'Addresses',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.lg),

//                   // ── Main Menu ───────────────────────
//                   Container(
//                     color: AppColors.white,
//                     child: Column(
//                       children: [
//                         _ProfileMenuItem(
//                           icon: Icons.shopping_bag_outlined,
//                           label: 'My Orders',
//                           iconColor: const Color(0xFF6366F1),
//                           onTap: () => isLoggedIn
//                               ? context.push(AppRoutes.orders)
//                               : _showLoginDialog(context),
//                         ),
//                         _ProfileMenuItem(
//                           icon: Icons.location_on_outlined,
//                           label: 'My Addresses',
//                           iconColor: const Color(0xFF10B981),
//                           onTap: () => isLoggedIn
//                               ? Navigator.of(context, rootNavigator: true).push(
//                                   MaterialPageRoute(
//                                     builder: (_) => const MyAddressesPage(),
//                                   ),
//                                 )
//                               : _showLoginDialog(context),
//                         ),
//                         _ProfileMenuItem(
//                           icon: Icons.local_offer_outlined,
//                           label: 'Offers & Coupons',
//                           iconColor: const Color(0xFFE94560),
//                           onTap: () => isLoggedIn
//                               ? context.push(AppRoutes.offers)
//                               : _showLoginDialog(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.lg),

//                   // ── Support Menu ────────────────────
//                   Container(
//                     color: AppColors.white,
//                     child: Column(
//                       children: [
//                         _ProfileMenuItem(
//                           icon: Icons.help_outline_rounded,
//                           label: 'Help & Support',
//                           onTap: () {},
//                         ),
//                         _ProfileMenuItem(
//                           icon: Icons.privacy_tip_outlined,
//                           label: 'Privacy Policy',
//                           onTap: () {},
//                         ),
//                         _ProfileMenuItem(
//                           icon: Icons.info_outline_rounded,
//                           label: 'About Us',
//                           onTap: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.lg),
//                   // ── Sign Out ────────────────────────
//                   if (isLoggedIn)
//                     Padding(
//                       padding: const EdgeInsets.all(AppSpacing.pagePadding),
//                       child: AppButton(
//                         label: 'Sign Out',
//                         isOutlined: true,
//                         onTap: () => context.read<AuthCubit>().logout(),
//                         backgroundColor: AppColors.error.withOpacity(0.05),
//                       ),
//                     ),
//                   if (!isLoggedIn)
//                     Padding(
//                       padding: const EdgeInsets.all(AppSpacing.pagePadding),
//                       child: AppButton(
//                         label: 'Sign In',
//                         onTap: () => context.go(AppRoutes.login),
//                       ),
//                     ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String value;
//   final String label;

//   const _StatItem({required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(value, style: AppTypography.h2),
//         Text(label, style: AppTypography.bodySmall),
//       ],
//     );
//   }
// }

// class _ProfileMenuItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final String? badge;
//   final Color? iconColor;

//   const _ProfileMenuItem({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.badge,
//     this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = iconColor ?? AppColors.textSecondary;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.pagePadding,
//           vertical: AppSpacing.lg,
//         ),
//         decoration: const BoxDecoration(
//           border: Border(bottom: BorderSide(color: AppColors.divider)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: iconColor != null
//                     ? iconColor!.withOpacity(0.1)
//                     : AppColors.surfaceVariant,
//                 borderRadius: BorderRadius.circular(AppRadius.sm),
//               ),
//               child: Icon(icon, size: 20, color: color),
//             ),
//             const SizedBox(width: AppSpacing.lg),
//             Expanded(child: Text(label, style: AppTypography.labelLarge)),
//             if (badge != null)
//               Container(
//                 width: 20,
//                 height: 20,
//                 decoration: const BoxDecoration(
//                   color: AppColors.accent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     badge!,
//                     style: AppTypography.labelSmall.copyWith(
//                       color: AppColors.white,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(width: AppSpacing.sm),
//             const Icon(
//               Icons.chevron_right_rounded,
//               color: AppColors.textHint,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'profile_screen_mobile.dart';
import 'profile_screen_desktop.dart';

// ═══════════════════════════════════════════════
// PROFILE SCREEN — entry point
// منفصل تماماً عن الـ layout
// ═══════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      final wishlistState = context.read<WishlistCubit>().state;
      if (authState.isSuccess &&
          wishlistState is! WishlistLoaded &&
          wishlistState is! WishlistLoading) {
        context.read<WishlistCubit>().loadWishlist();
      }
    });
  }

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.status == AuthStatus.loggedOut) {
          context.go(AppRoutes.login);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final user = authState.authData?.user;
          final isLoggedIn = authState.status == AuthStatus.success;

          final displayName = user != null
              ? '${user.firstName} ${user.lastName}'
              : isLoggedIn
                  ? 'Signed In'
                  : 'Guest User';

          final subtitle = user != null
              ? user.email
              : isLoggedIn
                  ? 'You are signed in'
                  : 'Please sign in to view your profile';

          // الـ props المشتركة بين الـ layouts
          final sharedProps = (
            displayName: displayName,
            subtitle: subtitle,
            username: user?.username,
            isLoggedIn: isLoggedIn,
            onShowLoginDialog: () => _showLoginDialog(context),
          );

          return Responsive(
            mobile: ProfileMobile(
              displayName: sharedProps.displayName,
              subtitle: sharedProps.subtitle,
              username: sharedProps.username,
              isLoggedIn: sharedProps.isLoggedIn,
              onShowLoginDialog: sharedProps.onShowLoginDialog,
            ),
            desktop: ProfileDesktop(
              displayName: sharedProps.displayName,
              subtitle: sharedProps.subtitle,
              username: sharedProps.username,
              isLoggedIn: sharedProps.isLoggedIn,
              onShowLoginDialog: sharedProps.onShowLoginDialog,
            ),
          );
        },
      ),
    );
  }
}