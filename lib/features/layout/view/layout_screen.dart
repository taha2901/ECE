import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/guest_guard_screen.dart';
import 'package:real_ecommerce/features/cart/view/cart_screens.dart';
import 'package:real_ecommerce/features/home/view/home_screen.dart';
import 'package:real_ecommerce/features/layout/logic/layout_cubit.dart';
import 'package:real_ecommerce/features/layout/view/layout_desktop.dart';
import 'package:real_ecommerce/features/layout/logic/layout_states.dart';
import 'package:real_ecommerce/features/profile/view/profile_screen.dart';
import 'package:real_ecommerce/features/wishlist/view/wishlist_screen.dart';

/// نقطة دخول الـ shell: موبايل (Persistent tabs) أو ديسكتوب (`LayoutDesktop`).
class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  static List<Widget> get _screens => [
        const HomeScreen(),
        const GuestGuardScreen(featureName: 'Cart', child: CartScreen()),
        const GuestGuardScreen(featureName: 'Wishlist', child: WishlistScreen()),
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          final cubit = context.read<LayoutCubit>();

          return Responsive(
            mobile: LayoutMobileShell(
              screens: _screens,
              cubit: cubit,
              state: state,
            ),
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

class LayoutMobileShell extends StatelessWidget {
  final List<Widget> screens;
  final LayoutCubit cubit;
  final LayoutState state;

  const LayoutMobileShell({
    super.key,
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
      screens: screens.map((s) => CustomNavBarScreen(screen: s)).toList(),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      margin: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        bottomPadding > 0 ? bottomPadding : 20,
      ),
      navBarHeight: 65,
      customWidget: LayoutMobileBottomNav(
        selectedIndex: state.currentIndex,
        onTap: (i) {
          cubit.changeIndex(i);
          cubit.controller.index = i;
        },
      ),
    );
  }
}

class LayoutMobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const LayoutMobileBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavSpec(
      icon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavSpec(
      icon: Icons.shopping_bag_rounded,
      inactiveIcon: Icons.shopping_bag_outlined,
      label: 'Cart',
    ),
    _NavSpec(
      icon: Icons.favorite_rounded,
      inactiveIcon: Icons.favorite_outline_rounded,
      label: 'Wishlist',
    ),
    _NavSpec(
      icon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
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
                      ? AppColors.accent.withValues(alpha: 0.12)
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

class _NavSpec {
  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  const _NavSpec({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
  });
}
