import 'package:real_ecommerce/features/home/data/models/product_model.dart';

// ══════════════════════════════════════════════════════════
//  CART RESPONSE MODEL
// ══════════════════════════════════════════════════════════

class CartResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<CartItemModel> results;

  CartResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  CART ITEM MODEL
// ══════════════════════════════════════════════════════════

class CartItemModel {
  final int id;
  final ProductModel product;
  final int quantity;
  final String size;
  final String color;
  final double lineTotal;
  final DateTime addedAt;
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
    required this.color,
    required this.lineTotal,
    required this.addedAt,
    required this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      size: json['size'] as String,
      color: json['color'] as String,
      lineTotal: (json['line_total'] as num).toDouble(),
      addedAt: DateTime.parse(json['added_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// حساب السعر الإجمالي للعنصر
  double get itemTotal => product.priceValue * quantity;

  /// تحديث الـ quantity
  CartItemModel copyWith({
    int? quantity,
    String? size,
    String? color,
  }) {
    return CartItemModel(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
      lineTotal: lineTotal,
      addedAt: addedAt,
      updatedAt: updatedAt,
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ADD TO CART REQUEST MODEL
// ══════════════════════════════════════════════════════════

class AddToCartRequest {
  final int productId;
  final int quantity;
  final String size;
  final String color;

  AddToCartRequest({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
    'size': size,
    'color': color,
  };
}

// ══════════════════════════════════════════════════════════
//  ADD TO CART RESPONSE MODEL
// ══════════════════════════════════════════════════════════

class AddToCartResponseModel {
  final int id;
  final int quantity;
  final String size;
  final String color;

  AddToCartResponseModel({
    required this.id,
    required this.quantity,
    required this.size,
    required this.color,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResponseModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      size: json['size'] as String,
      color: json['color'] as String,
    );
  }
}
