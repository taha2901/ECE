import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import '../models/orders_model.dart';

class OrdersRepository {
  final ApiService _apiService;

  OrdersRepository(this._apiService);

  /// Get all orders for the current user
  Future<ApiResult<OrdersListResponse>> getOrders({int page = 1}) async {
    try {
      final response = await _apiService.getOrders();
      print('📦 Orders API Response: ${response.data.runtimeType}');

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = Map<String, dynamic>.from(response.data as Map);
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      final ordersResponse = OrdersListResponse.fromJson(data);
      print('✅ Parsed orders: ${ordersResponse.results.length}');
      return ApiResult.success(ordersResponse);
    } catch (error) {
      print('❌ Error fetching orders: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// Get specific order details
  Future<ApiResult<OrderModel>> getOrderDetails(int orderId) async {
    try {
      final response = await _apiService.getOrderDetails(orderId);
      print('📦 Order Details API Response: ${response.data.runtimeType}');

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = Map<String, dynamic>.from(response.data as Map);
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      final order = OrderModel.fromJson(data);
      print('✅ Parsed order details: Order #${order.id}');
      return ApiResult.success(order);
    } catch (error) {
      print('❌ Error fetching order details: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// Filter orders by status
  Future<ApiResult<List<OrderModel>>> getOrdersByStatus(String status) async {
    try {
      final result = await getOrders();
      return result.when(
        success: (response) {
          final filtered = response.results
              .where((order) => order.status == status)
              .toList();
          print('✅ Filtered orders by status "$status": ${filtered.length}');
          return ApiResult.success(filtered);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (error) {
      print('❌ Error filtering orders: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
