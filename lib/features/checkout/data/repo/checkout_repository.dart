import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import 'package:real_ecommerce/features/checkout/data/models/order_models.dart';

class CheckoutRepository {
  final ApiService _apiService;

  CheckoutRepository(this._apiService);

  /// احصل على إجمالي السلة
  Future<ApiResult<CartTotalModel>> getCartTotal() async {
    try {
      final response = await _apiService.getCartTotal();
      return ApiResult.success(
        CartTotalModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(
        ErrorHandler.handle(error),
      );
    }
  }

  /// إنشاء أوردر
  Future<ApiResult<OrderResponseModel>> createOrder(
    CreateOrderRequest request,
  ) async {
    try {
      final response = await _apiService.createOrder(request.toJson());
      return ApiResult.success(
        OrderResponseModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(
        ErrorHandler.handle(error),
      );
    }
  }

  /// احصل على الأوامر
  Future<ApiResult<List<OrderResponseModel>>> getOrders() async {
    try {
      final response = await _apiService.getOrders();
      final List<dynamic> data = response.data['results'] ?? response.data;
      return ApiResult.success(
        (data).map((e) => OrderResponseModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return ApiResult.failure(
        ErrorHandler.handle(error),
      );
    }
  }

  /// احصل على تفاصيل أوردر
  Future<ApiResult<OrderResponseModel>> getOrderDetails(int id) async {
    try {
      final response = await _apiService.getOrderDetails(id);
      return ApiResult.success(
        OrderResponseModel.fromJson(response.data as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(
        ErrorHandler.handle(error),
      );
    }
  }
}
