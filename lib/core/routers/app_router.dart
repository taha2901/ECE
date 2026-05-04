import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/features/auth/view/forgot_password_screen.dart';
import 'package:real_ecommerce/features/auth/view/login.dart';
import 'package:real_ecommerce/features/auth/view/otp_screen.dart';
import 'package:real_ecommerce/features/auth/view/register_screen.dart';
import 'package:real_ecommerce/features/checkout/view/cart_total_screen.dart';
import 'package:real_ecommerce/features/checkout/view/enhanced_checkout_screen.dart';
import 'package:real_ecommerce/features/checkout/view/checkout_screen.dart';
import 'package:real_ecommerce/features/checkout/view/add_address_screen.dart';
import 'package:real_ecommerce/features/home/view/product_detail_screen.dart';
import 'package:real_ecommerce/features/layout/layout_screen.dart';
import 'package:real_ecommerce/features/offers/view/offers_screen.dart';
import 'package:real_ecommerce/features/onboarding/onboarding_screen.dart';
import 'package:real_ecommerce/features/orders/view/orders_screen.dart';
import 'package:real_ecommerce/features/cart/view/cart_screens.dart';
import 'package:real_ecommerce/features/payment/view/payment_screen.dart';
import 'package:real_ecommerce/features/splash/splash_screen.dart';
import 'package:real_ecommerce/features/profile/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Route Names ───────────────────────────────
abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPass = '/forgot-password';
  static const otp = '/otp';
  static const home = '/home';
  static const categories = '/categories';
  static const orders = '/orders';
  static const offers = '/offers';
  static const cartTotal = '/cart-total';
  static const checkout = '/checkout';
  static const enhancedCheckout = '/enhanced-checkout';
  static const addAddress = '/add-address';
  static const payment = '/payment';
  static const paymentSuccess = '/payment-success';
  static const productDetail = '/product-detail';
  static const cart = '/cart';
  static const notifications = '/notifications';
  static const myAddresses = '/my-addresses';
  static const profile = '/profile';
  static const adminDashboard = '/admin-dashboard';
}

// ─── Router Config ─────────────────────────────

final appRouter = GoRouter(
  // ✅ البداية مباشرة بالهوم — لا splash ولا redirect إجباري للـ login
  initialLocation: AppRoutes.home,

  redirect: (context, state) async {
    // ✅ Splash يوجّه للهوم مباشرة (لو حابب تبقي السبلاش فقط كـ intro قصير)
    if (state.matchedLocation == AppRoutes.splash) {
      return AppRoutes.home;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final isLoggedIn = token != null && token.isNotEmpty;

    // ✅ صفحات محتاجة توكن على مستوى الراوتر (مش الـ layout tabs)
    // يعني لو دخل /cart-total أو /enhanced-checkout مباشرة من الـ URL
    final hardProtectedRoutes = [
      AppRoutes.cartTotal,
      AppRoutes.enhancedCheckout,
      AppRoutes.checkout,
      AppRoutes.payment,
      AppRoutes.paymentSuccess,
      AppRoutes.orders,
      AppRoutes.addAddress,
      AppRoutes.myAddresses,
      AppRoutes.offers,
      AppRoutes.notifications,
      AppRoutes.adminDashboard,
    ];

    final isHardProtected = hardProtectedRoutes.any(
      (r) => state.matchedLocation == r || state.matchedLocation.startsWith(r),
    );

    if (!isLoggedIn && isHardProtected) {
      return AppRoutes.login;
    }

    // ✅ لو مسجّل دخول وعلى صفحة auth → روح الهوم
    final authRoutes = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPass,
      AppRoutes.otp,
    ];

    final isAuthRoute = authRoutes.any(
      (r) => state.matchedLocation == r || state.matchedLocation.startsWith(r),
    );

    if (isLoggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    return null;
  },

  routes: [
    // Splash — ما هيُعرضش لأن الـ redirect فوق بيحوّله لـ home فوراً
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),

    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),

    // ✅ الهوم (LayoutScreen) — متاح للجميع
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const LayoutScreen(),
    ),

    // Auth screens
    GoRoute(path: AppRoutes.login, builder: (_, __) => LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (_, __) => RegisterScreen()),
    GoRoute(
      path: AppRoutes.forgotPass,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) =>
          OtpVerificationScreen(phoneOrEmail: state.extra as String? ?? ''),
    ),

    GoRoute(path: AppRoutes.orders, builder: (_, __) => const OrdersScreen()),
    GoRoute(path: AppRoutes.offers, builder: (_, __) => const OffersScreen()),

    GoRoute(
      path: AppRoutes.cartTotal,
      builder: (_, __) => const CartTotalScreen(),
    ),

    GoRoute(
      path: AppRoutes.checkout,
      builder: (_, __) => const CheckoutScreen(),
    ),

    GoRoute(
      path: AppRoutes.enhancedCheckout,
      builder: (_, __) => const EnhancedCheckoutScreen(),
    ),

    GoRoute(
      path: AppRoutes.addAddress,
      builder: (_, __) => const AddressScreen(),
    ),

    GoRoute(path: AppRoutes.payment, builder: (_, __) => const PaymentScreen()),

    GoRoute(
      path: AppRoutes.paymentSuccess,
      builder: (_, __) => const PaymentSuccessScreen(),
    ),

    GoRoute(
      path: AppRoutes.productDetail,
      builder: (_, state) => ProductDetailScreen(
        product: state.extra as dynamic,
      ),
    ),

    GoRoute(
      path: AppRoutes.cart,
      builder: (_, __) => const CartScreen(),
    ),

    GoRoute(
      path: AppRoutes.notifications,
      builder: (_, __) => const _PlaceholderScreen(title: 'Notifications'),
    ),

    GoRoute(
      path: AppRoutes.myAddresses,
      builder: (_, __) => const AddressScreen(),
    ),

    GoRoute(
      path: AppRoutes.profile,
      builder: (_, __) => const ProfileScreen(),
    ),

    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (_, __) => const _PlaceholderScreen(title: 'Admin Dashboard'),
    ),
  ],
);

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