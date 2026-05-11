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
import 'package:real_ecommerce/features/payment/data/repo/repo.dart';
import 'package:real_ecommerce/features/payment/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/data/repo/wishlist_repository.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/coupons/data/repo/coupon_repository.dart';
import 'package:real_ecommerce/features/coupons/logic/cubit.dart';
import 'package:real_ecommerce/features/checkout/data/repo/checkout_repository.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/orders/data/repo/orders_repository.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart' as orders;
import 'package:real_ecommerce/features/address/data/repo/address_repository.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'package:real_ecommerce/features/search/logic/search_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() => DioFactory.getDio());
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<ApiService>()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  // Home
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepository(sl<ApiService>()),
  );
  sl.registerFactory<ProductCubit>(() => ProductCubit(sl<HomeRepository>()));
  sl.registerFactory<CategoryCubit>(() => CategoryCubit(sl<HomeRepository>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<HomeRepository>()));

  // Cart
  sl.registerLazySingleton<CartRepository>(() => CartRepository(sl<Dio>()));
  sl.registerFactory<cart.CartCubit>(
    () => cart.CartCubit(sl<CartRepository>()),
  );

  // ✅ Wishlist
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepository(sl<Dio>()),
  );
  sl.registerFactory<WishlistCubit>(
    () => WishlistCubit(sl<WishlistRepository>()),
  );

  // ✅ Coupons
  sl.registerLazySingleton<CouponRepository>(
    () => CouponRepository(sl<ApiService>()),
  );
  sl.registerFactory<CouponCubit>(
    () => CouponCubit(sl<CouponRepository>()),
  );

  // ✅ Addresses persisted locally in SQLite (MUST BE BEFORE CHECKOUT)
  // ⭐ SINGLETON - ensures same instance across app
  sl.registerLazySingleton<AddressRepository>(() => AddressRepository());
  sl.registerLazySingleton<AddressCubit>(() => AddressCubit(sl<AddressRepository>()));

  // ✅ Checkout
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepository(sl<ApiService>()),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(
      sl<CheckoutRepository>(),
      sl<AuthCubit>(),
      sl<AddressCubit>(),
    ),
  );

  // ✅ Orders
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepository(sl<ApiService>()),
  );
  sl.registerFactory<orders.OrdersCubit>(
    () => orders.OrdersCubit(sl<OrdersRepository>()),
  );

  sl.registerLazySingleton<PaymentRepository>(() => PaymentRepository());
  sl.registerFactory<PaymentCubit>(() => PaymentCubit(sl<PaymentRepository>()));
}

