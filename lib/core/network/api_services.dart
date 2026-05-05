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

  Future<Response> getProducts({int page = 1}) async {
    return await _dio.get(
      ApiConstants.getAllProducts,
      queryParameters: {'page': page},
    );
  }

  Future<Response> getCategories() async {
    return await _dio.get(ApiConstants.getAllCategories);
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
    return await _dio.get(ApiConstants.orders);
  }

  Future<Response> getOrderDetails(int id) async {
    return await _dio.get(ApiConstants.orderDetails(id));
  }

  Future<Response> getProfile() async {
    return await _dio.get(ApiConstants.me);
  }
}
