import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> login(Map<String, dynamic> body) async {
    return await _dio.post(
      ApiConstants.login,
      data: body,
    );
  }
  Future<Response> logout() async {
  return await _dio.post(ApiConstants.logout);
}

  Future<Response> register(Map<String, dynamic> body) async {
    return await _dio.post(
      ApiConstants.register,
      data: body,
    );
  }

  Future<Response> getProducts({int page = 1, String? search}) async {
    final queryParameters = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    return await _dio.get(
      ApiConstants.getAllProducts,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getCategories() async {
    return await _dio.get(ApiConstants.getAllCategories);
  }

  Future<Response> getActiveCoupons() async {
    return await _dio.get(ApiConstants.activeCoupons);
  }

  Future<Response> getCategoryById(int id) async {
    return await _dio.get(ApiConstants.getCategoryDetails(id));
  }

  // =================== Cart ===================
  Future<Response> getCartTotal() async {
    return await _dio.get(ApiConstants.cartTotal);
  }

  // =================== Orders ===================
  Future<Response> createOrder(Map<String, dynamic> body) async {
    return await _dio.post(
      ApiConstants.orders,
      data: body,
    );
  }

  Future<Response> getOrders() async {
    return await _dio.get(ApiConstants.myOrders);
  }

  Future<Response> getOrderDetails(int id) async {
    return await _dio.get(ApiConstants.orderDetails(id));
  }

  Future<Response> getProfile() async {
    return await _dio.get(ApiConstants.me);
  }
}
