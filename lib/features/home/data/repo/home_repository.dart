import 'package:real_ecommerce/core/network/api_error_handler.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/core/network/api_services.dart';
import 'package:real_ecommerce/features/home/data/models/category_model.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<ApiResult<ProductResponseModel>> getProducts({int page = 1}) async {
    try {
      final response = await _apiService.getProducts(page: page);
      final data = Map<String, dynamic>.from(response.data as Map);
      final productResponse = ProductResponseModel.fromJson(data);
      return ApiResult.success(productResponse);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _apiService.getCategories();
      final data = List<dynamic>.from(response.data as List<dynamic>);
      final categories = data
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return ApiResult.success(categories);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<CategoryModel>> getCategoryById(int id) async {
    try {
      final response = await _apiService.getCategoryById(id);
      final data = Map<String, dynamic>.from(response.data as Map<String, dynamic>);
      final category = CategoryModel.fromJson(data);
      return ApiResult.success(category);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}