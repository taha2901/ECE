// lib/features/wishlist/data/models/wishlist_model.dart

import 'package:real_ecommerce/features/home/data/models/product_model.dart';

class WishlistModel {
  final int id;
  final ProductModel product;
  final String addedAt;

  const WishlistModel({
    required this.id,
    required this.product,
    required this.addedAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      addedAt: json['added_at'],
    );
  }
}