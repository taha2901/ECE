import 'package:real_ecommerce/core/helpers/shared_pref_helper.dart';
import 'package:real_ecommerce/core/helpers/constants.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import 'package:real_ecommerce/core/network/dio_factory.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_login_request.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_register_request.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_response_model.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_tokens_model.dart';
import 'package:real_ecommerce/features/auth/data/models/auth_user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<ApiResult<AuthResponseModel>> login(AuthLoginRequest request) async {
    try {
      final response = await _apiService.login(request.toJson());
      final data = Map<String, dynamic>.from(response.data as Map);
      final authResponse = AuthResponseModel.fromJson(data);
      await _storeTokens(authResponse.tokens);
      return ApiResult.success(authResponse);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AuthResponseModel>> register(
      AuthRegisterRequest request) async {
    try {
      final response = await _apiService.register(request.toJson());
      final data = Map<String, dynamic>.from(response.data as Map);
      final authResponse = AuthResponseModel.fromJson(data);
      await _storeTokens(authResponse.tokens);
      return ApiResult.success(authResponse);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _apiService.logout();
      await _clearTokens();
      return const ApiResult.success(null);
    } catch (error) {
      // حتى لو السيرفر رجّع error، امسح البيانات المحلية
      await _clearTokens();
      return const ApiResult.success(null);
    }
  }

  Future<ApiResult<AuthUserModel>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      final data = Map<String, dynamic>.from(response.data as Map);
      final user = AuthUserModel.fromJson(data);
      return ApiResult.success(user);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<void> _storeTokens(AuthTokensModel tokens) async {
    await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userToken, tokens.access);
    await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.refreshToken, tokens.refresh);
    DioFactory.setTokenIntoHeaderAfterLogin(tokens.access);
  }

  Future<void> _clearTokens() async {
    await SharedPrefHelper.clearAllSecuredData();
    DioFactory.clearToken();
  }
}