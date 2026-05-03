import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/di/service_locator.dart';
import 'package:real_ecommerce/core/helpers/location_service.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_theme.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart' as cart;
import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await LocationService().requestLocationPermission();
  runApp(const LuxeStoreApp());
}

class LuxeStoreApp extends StatelessWidget {
  const LuxeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<ProductCubit>(create: (_) => sl<ProductCubit>()),
        BlocProvider<cart.CartCubit>(create: (_) => sl<cart.CartCubit>()),
        BlocProvider<WishlistCubit>(
          create: (_) => sl<WishlistCubit>()..loadWishlist(),
        ),
        BlocProvider<AddressCubit>(create: (_) => AddressCubit()),

      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
