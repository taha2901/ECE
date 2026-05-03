// lib/features/wishlist/data/repo/wishlist_repository.dart

import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/wishlist_model.dart';

class WishlistRepository {
  final Dio _dio;

  WishlistRepository(this._dio);

  Future<List<WishlistModel>> getWishlist() async {
    final response = await _dio.get(ApiConstants.wishlist);
    final List data = response.data;
    return data.map((e) => WishlistModel.fromJson(e)).toList();
  }

  Future<WishlistModel> addToWishlist(int productId) async {
    final response = await _dio.post(
      ApiConstants.addToWishlist,
      data: {'product_id': productId},
    );
    return WishlistModel.fromJson(response.data);
  }

  Future<void> removeFromWishlist(int productId) async {
    await _dio.delete(ApiConstants.removeFromWishlist(productId));
  }
}