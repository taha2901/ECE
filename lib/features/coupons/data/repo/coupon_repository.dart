import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import 'package:real_ecommerce/features/coupons/data/models/coupon_model.dart';

class CouponRepository {
  final ApiService _apiService;

  CouponRepository(this._apiService);

  Future<ApiResult<List<CouponModel>>> getActiveCoupons() async {
    try {
      final response = await _apiService.getActiveCoupons();
      final rawData = response.data;
      final items = <dynamic>[];

      if (rawData is List) {
        items.addAll(rawData);
      } else if (rawData is Map<String, dynamic>) {
        if (rawData['results'] is List) {
          items.addAll(rawData['results'] as List);
        } else if (rawData['data'] is List) {
          items.addAll(rawData['data'] as List);
        } else if (rawData['coupons'] is List) {
          items.addAll(rawData['coupons'] as List);
        } else {
          items.addAll(rawData.values);
        }
      }

      final coupons = items
          .whereType<Map<String, dynamic>>()
          .map((item) => CouponModel.fromJson(item))
          .toList();

      return ApiResult.success(coupons);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
