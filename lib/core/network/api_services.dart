import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // =================== Auth ===================

  // Future<LoginResponseBody> login(LoginRequestBody loginRequestBody) async {
  //   final response = await _dio.post(
  //     ApiConstants.login,
  //     data: loginRequestBody.toJson(),
  //   );
  //   return LoginResponseBody.fromJson(response.data);
  // }

  // Future<RegisterResponseBody> register(
  //     RegisterRequestBody registerRequestBody) async {
  //   final response = await _dio.post(
  //     ApiConstants.register,
  //     data: registerRequestBody.toJson(),
  //   );
  //   return RegisterResponseBody.fromJson(response.data);
  // }

  // Future<Map<String, dynamic>> logout({String? refreshToken}) async {
  //   final response = await _dio.post(
  //     ApiConstants.logout,
  //     data: refreshToken != null && refreshToken.isNotEmpty
  //         ? {"refresh": refreshToken}
  //         : null,
  //   );
  //   return response.data;
  // }

}
