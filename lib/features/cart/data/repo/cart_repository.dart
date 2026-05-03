import 'package:dio/dio.dart';
import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/features/cart/data/models/cart_models.dart';

class CartRepository {
  final Dio _dio;
  static const String _baseUrl = 'https://midoghanam.pythonanywhere.com/api/cart/';

  CartRepository(this._dio);

  /// الحصول على محتويات العربة
  Future<ApiResult<CartResponseModel>> getCart() async {
    try {
      final response = await _dio.get(_baseUrl);
      return ApiResult.success(
        CartResponseModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  /// إضافة منتج للعربة
  Future<ApiResult<AddToCartResponseModel>> addToCart(
    AddToCartRequest request,
  ) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: request.toJson(),
      );
      return ApiResult.success(
        AddToCartResponseModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  /// تحديث عنصر في العربة
  Future<ApiResult<CartItemModel>> updateCartItem(
    int itemId,
    int quantity,
    String size,
    String color,
  ) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl$itemId/',
        data: {
          'quantity': quantity,
          'size': size,
          'color': color,
        },
      );
      return ApiResult.success(
        CartItemModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  /// حذف عنصر من العربة
  Future<ApiResult<void>> removeFromCart(int itemId) async {
    try {
      await _dio.delete('$_baseUrl$itemId/');
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  /// مسح العربة بالكامل
  Future<ApiResult<void>> clearCart() async {
    try {
      final cart = await getCart();
      await cart.when(
        success: (data) async {
          for (final item in data.results) {
            await removeFromCart(item.id);
          }
        },
        failure: (_) {},
      );
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
