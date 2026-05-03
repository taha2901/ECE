// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import 'package:real_ecommerce/core/network/dio_factory.dart';
import 'package:real_ecommerce/features/auth/data/repositories/auth_repository.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/data/repo/cart_repository.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart' as cart;
import 'package:real_ecommerce/features/home/data/repo/home_repository.dart';
import 'package:real_ecommerce/features/home/logic/category_cubit.dart';
import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
import 'package:real_ecommerce/features/wishlist/data/repo/wishlist_repository.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() => DioFactory.getDio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  // Auth
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(sl<ApiService>()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  // Home
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepository(sl<ApiService>()));
  sl.registerFactory<ProductCubit>(() => ProductCubit(sl<HomeRepository>()));
  sl.registerFactory<CategoryCubit>(
      () => CategoryCubit(sl<HomeRepository>()));

  // Cart
  sl.registerLazySingleton<CartRepository>(
      () => CartRepository(sl<Dio>()));
  sl.registerFactory<cart.CartCubit>(
      () => cart.CartCubit(sl<CartRepository>()));

  // ✅ Wishlist
  sl.registerLazySingleton<WishlistRepository>(
      () => WishlistRepository(sl<Dio>()));
  sl.registerFactory<WishlistCubit>(
      () => WishlistCubit(sl<WishlistRepository>()));
}