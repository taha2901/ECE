import 'package:flutter/foundation.dart';
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

      if (response.data is List) {
        final ordersResponse = OrdersListResponse.fromList(
          List<dynamic>.from(response.data as List<dynamic>),
        );
        return ApiResult.success(ordersResponse);
      }

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = Map<String, dynamic>.from(response.data as Map);
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      final ordersResponse = OrdersListResponse.fromJson(data);
      return ApiResult.success(ordersResponse);
    } catch (error, stackTrace) {
      debugPrint('❌ OrdersRepository.getOrders error: $error');
      debugPrint('❌ OrdersRepository.getOrders stackTrace: $stackTrace');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// Get specific order details
  Future<ApiResult<OrderModel>> getOrderDetails(int orderId) async {
    try {
      final response = await _apiService.getOrderDetails(orderId);

      Map<String, dynamic> data;
      if (response.data is Map) {
        data = Map<String, dynamic>.from(response.data as Map);
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      final order = OrderModel.fromJson(data);
      return ApiResult.success(order);
    } catch (error) {
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
          return ApiResult.success(filtered);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
