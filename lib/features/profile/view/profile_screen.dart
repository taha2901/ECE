import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/coupons/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart' as orders;
import 'package:real_ecommerce/features/orders/logic/states.dart' as orders_state;
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'profile_screen_mobile.dart';
import 'profile_screen_desktop.dart';


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
      final ordersState = context.read<orders.OrdersCubit>().state;
      if (authState.isSuccess &&
          wishlistState is! WishlistLoaded &&
          wishlistState is! WishlistLoading) {
        context.read<WishlistCubit>().loadWishlist();
      }
      if (authState.status == AuthStatus.success) {
        context.read<CouponCubit>().loadCoupons();
        if (ordersState is orders_state.OrdersInitial) {
          context.read<orders.OrdersCubit>().loadOrders();
        }
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
        if (authState.status == AuthStatus.success) {
          context.read<CouponCubit>().loadCoupons();
          context.read<orders.OrdersCubit>().loadOrders();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final user = authState.authData?.user;
          final isLoggedIn = authState.status == AuthStatus.success;

          final displayName = user != null && user.firstName.isNotEmpty
              ? '${user.firstName} ${user.lastName}'
              : isLoggedIn
                  ? 'Signed In'
                  : 'Guest User';

          final subtitle = user != null
              ? user.email
              : isLoggedIn
                  ? 'You are signed in'
                  : 'Please sign in to view your profile';

          final phone = user?.phone ?? '';
          final location = user != null && (user.city.isNotEmpty || user.country.isNotEmpty)
              ? [user.city, user.country].where((part) => part.isNotEmpty).join(', ')
              : '';

          // الـ props المشتركة بين الـ layouts
          final sharedProps = (
            displayName: displayName,
            subtitle: subtitle,
            username: user?.username,
            phone: phone,
            location: location,
            isLoggedIn: isLoggedIn,
            onShowLoginDialog: () => _showLoginDialog(context),
          );

          return Responsive(
            mobile: ProfileMobile(
              displayName: sharedProps.displayName,
              subtitle: sharedProps.subtitle,
              username: sharedProps.username,
              phone: sharedProps.phone,
              location: sharedProps.location,
              isLoggedIn: sharedProps.isLoggedIn,
              onShowLoginDialog: sharedProps.onShowLoginDialog,
            ),
            desktop: ProfileDesktop(
              displayName: sharedProps.displayName,
              subtitle: sharedProps.subtitle,
              username: sharedProps.username,
              phone: sharedProps.phone,
              location: sharedProps.location,
              isLoggedIn: sharedProps.isLoggedIn,
              onShowLoginDialog: sharedProps.onShowLoginDialog,
            ),
          );
        },
      ),
    );
  }
}