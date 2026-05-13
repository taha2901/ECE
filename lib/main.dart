import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/di/service_locator.dart';
import 'package:real_ecommerce/core/helpers/location_service.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_theme.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart' as cart;
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/coupons/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart' as orders;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
  if (stripePublishableKey == null || stripePublishableKey.isEmpty) {
    throw StateError('Missing STRIPE_PUBLISHABLE_KEY in .env');
  }

  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await initDependencies();
  await LocationService().requestLocationPermission();
  runApp(const LuxeStoreApp());
}

class LuxeStoreApp extends StatefulWidget {
  const LuxeStoreApp({super.key});

  @override
  State<LuxeStoreApp> createState() => _LuxeStoreAppState();
}

class _LuxeStoreAppState extends State<LuxeStoreApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ✅ إعادة تحميل البيانات عند العودة للتطبيق
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          _refreshAllData();
        }
      });
    }
  }

  void _refreshAllData() {
    try {
      final authState = context.read<AuthCubit>().state;
      if (authState.status == AuthStatus.success) {
        context.read<AuthCubit>().refreshUserProfile();
        context.read<AddressCubit>().loadAddresses();
        context.read<orders.OrdersCubit>().loadOrders();
        context.read<CouponCubit>().loadCoupons();
        context.read<WishlistCubit>().loadWishlist();
      }
    } catch (e) {
      // Ignore errors if context not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<cart.CartCubit>(create: (_) => sl<cart.CartCubit>()),
        BlocProvider<WishlistCubit>(create: (_) => sl<WishlistCubit>()),
        BlocProvider<CouponCubit>(create: (_) => sl<CouponCubit>()),
        BlocProvider<AddressCubit>(create: (_) => sl<AddressCubit>()),
        BlocProvider<CheckoutCubit>(create: (_) => sl<CheckoutCubit>()),
        BlocProvider<orders.OrdersCubit>(
          create: (_) => sl<orders.OrdersCubit>(),
        ),
      ],
      child: _AppContent(),
    );
  }
}

/// ✅ واجهة التطبيق الداخلية — لديها وصول إلى جميع الـ providers
class _AppContent extends StatefulWidget {
  const _AppContent();

  @override
  State<_AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<_AppContent> {
  @override
  void initState() {
    super.initState();
    // تحميل البيانات عند بدء التطبيق لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    try {
      final authState = context.read<AuthCubit>().state;
      if (authState.status == AuthStatus.success) {
        context.read<AuthCubit>().refreshUserProfile();
        context.read<AddressCubit>().loadAddresses();
        context.read<orders.OrdersCubit>().loadOrders();
        context.read<CouponCubit>().loadCoupons();
        context.read<WishlistCubit>().loadWishlist();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      scaffoldMessengerKey: appScaffoldMessengerKey,
    );
  }
}
