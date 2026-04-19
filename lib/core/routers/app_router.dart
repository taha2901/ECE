import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/features/auth/view/forgot_password_screen.dart';
import 'package:real_ecommerce/features/auth/view/login.dart';
import 'package:real_ecommerce/features/auth/view/otp_screen.dart';
import 'package:real_ecommerce/features/auth/view/register_screen.dart';
import 'package:real_ecommerce/features/categories/view/categories_screen.dart';
import 'package:real_ecommerce/features/checkout/view/add_address_screen.dart';
import 'package:real_ecommerce/features/checkout/view/checkout_screen.dart';
import 'package:real_ecommerce/features/home/view/product_detail_screen.dart';
import 'package:real_ecommerce/features/offers/view/offers_screen.dart';
import 'package:real_ecommerce/features/onboarding/onboarding_screen.dart';
import 'package:real_ecommerce/features/orders/view/orders_screen.dart';
import 'package:real_ecommerce/features/payment/view/payment_screen.dart';
import 'package:real_ecommerce/features/splash/splash_screen.dart';
import 'package:real_ecommerce/main.dart';

// ─── Route Names ───────────────────────────────
abstract class AppRoutes {
  static const splash          = '/';
  static const onboarding      = '/onboarding';
  static const login           = '/login';
  static const register        = '/register';
  static const forgotPass      = '/forgot-password';
  static const otp             = '/otp';
  static const home            = '/home';
  static const categories      = '/categories';
  static const orders          = '/orders';
  static const offers          = '/offers';
  static const checkout        = '/checkout';
  static const addAddress      = '/add-address';
  static const payment         = '/payment';
  static const paymentSuccess  = '/payment-success';
  static const productDetail   = '/product-detail';
  static const notifications   = '/notifications';
  static const myAddresses     = '/my-addresses';
  static const adminDashboard  = '/admin-dashboard';
}

// ─── Router Config ─────────────────────────────
final appRouter = GoRouter(
  // initialLocation: AppRoutes.splash,
  initialLocation: AppRoutes.login,
  routes: [

    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),

    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (_, __) => const RegisterScreen(),
    ),

    GoRoute(
      path: AppRoutes.forgotPass,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) => OtpVerificationScreen(
        phoneOrEmail: state.extra as String? ?? '',
      ),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const MainNavigationShell(),
    ),

    GoRoute(
      path: AppRoutes.categories,
      builder: (_, __) => const CategoriesScreen(),
    ),

    GoRoute(
      path: AppRoutes.orders,
      builder: (_, __) => const OrdersScreen(),
    ),

    GoRoute(
      path: AppRoutes.offers,
      builder: (_, __) => const OffersScreen(),
    ),

    GoRoute(
      path: AppRoutes.checkout,
      builder: (_, __) => const CheckoutScreen(),
    ),

    GoRoute(
      path: AppRoutes.addAddress,
      builder: (_, __) => const AddressScreen(),
    ),

    GoRoute(
      path: AppRoutes.payment,
      builder: (_, __) => const PaymentScreen(),
    ),

    GoRoute(
      path: AppRoutes.paymentSuccess,
      builder: (_, __) => const PaymentSuccessScreen(),
    ),

    GoRoute(
      path: AppRoutes.productDetail,
      builder: (_, __) => const ProductDetailScreen(),
    ),

    GoRoute(
      path: AppRoutes.notifications,
      builder: (_, __) => const _PlaceholderScreen(title: 'Notifications'),
    ),

    GoRoute(
      path: AppRoutes.myAddresses,
      builder: (_, __) => const AddressScreen(),
    ),

    // ── Admin ──────────────────────────────────


  ],
);

// placeholder لأي صفحة لسا متعملتش
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}