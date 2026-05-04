
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/guest_guard_screen.dart'; // ✅ الجديد

import 'package:real_ecommerce/features/home/view/home_screen.dart';
import 'package:real_ecommerce/features/cart/view/cart_screens.dart';
import 'package:real_ecommerce/features/layout/layout_states.dart';
import 'package:real_ecommerce/features/wishlist/view/wishlist_screen.dart';
import 'package:real_ecommerce/features/profile/view/profile_screen.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutInitial());

  int currentIndex = 0;
  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  void changeIndex(int index) {
    currentIndex = index;
    emit(LayoutChangeIndexState(currentIndex: index));
  }

  List<PersistentBottomNavBarItem> navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded, size: 24),
        inactiveIcon: const Icon(Icons.home_outlined, size: 24),
        title: "Home",
        activeColorPrimary: AppColors.accent,
        inactiveColorPrimary: AppColors.textHint,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_bag_rounded, size: 24),
        inactiveIcon: const Icon(Icons.shopping_bag_outlined, size: 24),
        title: "Cart",
        activeColorPrimary: AppColors.accent,
        inactiveColorPrimary: AppColors.textHint,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite_rounded, size: 24),
        inactiveIcon: const Icon(Icons.favorite_outline_rounded, size: 24),
        title: "Wishlist",
        activeColorPrimary: AppColors.accent,
        inactiveColorPrimary: AppColors.textHint,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_rounded, size: 24),
        inactiveIcon: const Icon(Icons.person_outline_rounded, size: 24),
        title: "Profile",
        activeColorPrimary: AppColors.accent,
        inactiveColorPrimary: AppColors.textHint,
      ),
    ];
  }

  List<CustomNavBarScreen> getScreens(BuildContext context) {
    return [
      // ✅ Home — مفتوح للجميع
      const CustomNavBarScreen(screen: HomeScreen()),

      // ✅ Cart — محمي بـ GuestGuard
      const CustomNavBarScreen(
        screen: GuestGuardScreen(
          featureName: 'Cart',
          child: CartScreen(),
        ),
      ),

      // ✅ Wishlist — محمي بـ GuestGuard
      const CustomNavBarScreen(
        screen: GuestGuardScreen(
          featureName: 'Wishlist',
          child: WishlistScreen(),
        ),
      ),

      // ✅ Profile — محمي بـ GuestGuard
      const CustomNavBarScreen(
        screen: GuestGuardScreen(
          featureName: 'Profile',
          child: ProfileScreen(),
        ),
      ),
    ];
  }
}