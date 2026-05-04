// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/features/layout/layout_cubit.dart';
// import 'package:real_ecommerce/features/layout/layout_states.dart';

// class LayoutScreen extends StatelessWidget {
//   const LayoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LayoutCubit(),
//       child: BlocBuilder<LayoutCubit, LayoutState>(
//         builder: (context, state) {
//           final cubit = context.read<LayoutCubit>();
//           final bottomPadding = MediaQuery.of(context).padding.bottom;

//           return PersistentTabView.custom(
//             context,
//             controller: cubit.controller,
//             itemCount: 4, // غيّرها لو شيلت Categories خليها 4
//             screens: cubit.getScreens(context),
//             backgroundColor: Colors.transparent,
//             resizeToAvoidBottomInset: false,
//             handleAndroidBackButtonPress: true,
//             stateManagement: true,
//             hideNavigationBarWhenKeyboardAppears: true,
//             margin: EdgeInsets.fromLTRB(
//               24,
//               0,
//               24,
//               bottomPadding > 0 ? bottomPadding : 20,
//             ),
//             navBarHeight: 65,
//             customWidget: _CustomBottomNavBar(
//               selectedIndex: state.currentIndex,
//               onTap: (index) {
//                 cubit.changeIndex(index);
//                 cubit.controller.index = index;
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CUSTOM BOTTOM NAV BAR
// // ─────────────────────────────────────────────
// class _CustomBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onTap;

//   const _CustomBottomNavBar({
//     required this.selectedIndex,
//     required this.onTap,
//   });

//   static const _items = [
//     _NavItem(icon: Icons.home_rounded, inactiveIcon: Icons.home_outlined, label: 'Home'),
//     _NavItem(icon: Icons.shopping_bag_rounded, inactiveIcon: Icons.shopping_bag_outlined, label: 'Cart'),
//     _NavItem(icon: Icons.favorite_rounded, inactiveIcon: Icons.favorite_outline_rounded, label: 'Wishlist'),
//     _NavItem(icon: Icons.person_rounded, inactiveIcon: Icons.person_outline_rounded, label: 'Profile'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         height: 65,
//         decoration: BoxDecoration(
//           color: AppColors.surface, // أبيض ناصع متناسق مع الـ theme
//           borderRadius: BorderRadius.circular(32),
//           boxShadow: AppColors.floatShadow,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(_items.length, (i) {
//             final isSelected = i == selectedIndex;
//             final item = _items[i];

//             return GestureDetector(
//               onTap: () => onTap(i),
//               behavior: HitTestBehavior.opaque,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isSelected ? 14 : 10,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.accent.withOpacity(0.12)
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(32),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Icon
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       width: isSelected ? 32 : 24,
//                       height: isSelected ? 32 : 24,
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? AppColors.accent
//                             : Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                       padding: EdgeInsets.all(isSelected ? 6 : 0),
//                       child: Icon(
//                         isSelected ? item.icon : item.inactiveIcon,
//                         color: isSelected
//                             ? AppColors.white
//                             : AppColors.textHint,
//                         size: isSelected ? 18 : 22,
//                       ),
//                     ),
//                     // Label
//                     AnimatedSize(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       child: isSelected
//                           ? Padding(
//                               padding: const EdgeInsets.only(left: 8),
//                               child: Text(
//                                 item.label,
//                                 style: const TextStyle(
//                                   color: AppColors.accent,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w700,
//                                   decoration: TextDecoration.none,
//                                 ),
//                               ),
//                             )
//                           : const SizedBox.shrink(),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem {
//   final IconData icon;
//   final IconData inactiveIcon;
//   final String label;
//   const _NavItem({
//     required this.icon,
//     required this.inactiveIcon,
//     required this.label,
//   });
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/guest_guard_screen.dart';
import 'package:real_ecommerce/features/cart/view/cart_screens.dart';
import 'package:real_ecommerce/features/home/view/home_screen.dart';
import 'package:real_ecommerce/features/layout/layout_cubit.dart';
import 'package:real_ecommerce/features/layout/layout_desktop.dart';
import 'package:real_ecommerce/features/layout/layout_states.dart';
import 'package:real_ecommerce/features/profile/view/profile_screen.dart';
import 'package:real_ecommerce/features/wishlist/view/wishlist_screen.dart';

// ══════════════════════════════════════════════════════════
//  LAYOUT SCREEN  —  entry point, picks shell by screen size
// ══════════════════════════════════════════════════════════

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  // Screens shared between mobile & desktop
  static List<Widget> get _screens => [
    const HomeScreen(),
    const GuestGuardScreen(featureName: 'Cart',     child: CartScreen()),
    const GuestGuardScreen(featureName: 'Wishlist', child: WishlistScreen()),
    const GuestGuardScreen(featureName: 'Profile',  child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          final cubit = context.read<LayoutCubit>();

          return Responsive(
            // ── Mobile ──────────────────────────────────
            mobile: _MobileShell(
              screens: _screens,
              cubit: cubit,
              state: state,
            ),
            // ── Desktop (& tablet fallback) ──────────────
            desktop: LayoutDesktop(
              screens: _screens,
              selectedIndex: state.currentIndex,
              onTap: (i) {
                cubit.changeIndex(i);
                cubit.controller.index = i;
              },
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  MOBILE SHELL  —  your existing PersistentTabView + bottom nav
//  (extracted here so layout_screen stays clean)
// ══════════════════════════════════════════════════════════

class _MobileShell extends StatelessWidget {
  final List<Widget> screens;
  final LayoutCubit cubit;
  final LayoutState state;

  const _MobileShell({
    required this.screens,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return PersistentTabView.custom(
      context,
      controller: cubit.controller,
      itemCount: 4,
      screens: screens
          .map((s) => CustomNavBarScreen(screen: s))
          .toList(),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      margin: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding > 0 ? bottomPadding : 20),
      navBarHeight: 65,
      customWidget: _MobileBottomNav(
        selectedIndex: state.currentIndex,
        onTap: (i) {
          cubit.changeIndex(i);
          cubit.controller.index = i;
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  MOBILE BOTTOM NAV  —  unchanged from your original
// ══════════════════════════════════════════════════════════

class _MobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _MobileBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded,         inactiveIcon: Icons.home_outlined,            label: 'Home'),
    _NavItem(icon: Icons.shopping_bag_rounded,  inactiveIcon: Icons.shopping_bag_outlined,    label: 'Cart'),
    _NavItem(icon: Icons.favorite_rounded,      inactiveIcon: Icons.favorite_outline_rounded, label: 'Wishlist'),
    _NavItem(icon: Icons.person_rounded,        inactiveIcon: Icons.person_outline_rounded,   label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppColors.floatShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final isSelected = i == selectedIndex;
            final item = _items[i];
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 32 : 24,
                      height: isSelected ? 32 : 24,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(isSelected ? 6 : 0),
                      child: Icon(
                        isSelected ? item.icon : item.inactiveIcon,
                        color: isSelected ? AppColors.white : AppColors.textHint,
                        size: isSelected ? 18 : 22,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: isSelected
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  const _NavItem({required this.icon, required this.inactiveIcon, required this.label});
}