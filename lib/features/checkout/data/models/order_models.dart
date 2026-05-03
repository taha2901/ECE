// ══════════════════════════════════════════════════════════
//  CART TOTAL MODEL
// ══════════════════════════════════════════════════════════

class CartTotalModel {
  final int count;
  final String total;
  final List<CartItemTotalModel> items;

  CartTotalModel({
    required this.count,
    required this.total,
    required this.items,
  });

  factory CartTotalModel.fromJson(Map<String, dynamic> json) {
    return CartTotalModel(
      count: json['count'] as int,
      total: json['total'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemTotalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  double get totalAsDouble => double.tryParse(total) ?? 0.0;
}

// ══════════════════════════════════════════════════════════
//  CART ITEM TOTAL MODEL
// ══════════════════════════════════════════════════════════

class CartItemTotalModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String size;
  final String color;
  final double lineTotal;

  CartItemTotalModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
    required this.lineTotal,
  });

  factory CartItemTotalModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>;
    return CartItemTotalModel(
      id: json['id'] as int,
      productId: product['id'] as int,
      productName: product['name'] as String,
      productImage: product['image'] as String? ?? '',
      price: double.tryParse(product['price'].toString()) ?? 0.0,
      quantity: json['quantity'] as int,
      size: json['size'] as String,
      color: json['color'] as String,
      lineTotal: double.tryParse(json['line_total'].toString()) ?? 0.0,
    );
  }
}

// ══════════════════════════════════════════════════════════
//  CREATE ORDER REQUEST MODEL
// ══════════════════════════════════════════════════════════

class CreateOrderRequest {
  final int user;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String zipCode;
  final String subtotal;
  final String shippingFee;
  final String tax;
  final String total;
  final String discountAmount;
  final String? coupon;
  final String status;
  final String paymentMethod;
  final List<OrderItemRequest> items;

  CreateOrderRequest({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
    this.discountAmount = '0',
    this.coupon,
    this.status = 'processing',
    required this.paymentMethod,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'zip_code': zipCode,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'tax': tax,
      'total': total,
      'discount_amount': discountAmount,
      'coupon': coupon,
      'status': status,
      'payment_method': paymentMethod,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

// ══════════════════════════════════════════════════════════
//  ORDER ITEM REQUEST MODEL
// ══════════════════════════════════════════════════════════

class OrderItemRequest {
  final int productId;
  final String name;
  final String price;
  final int quantity;
  final String size;
  final String color;

  OrderItemRequest({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}

// ══════════════════════════════════════════════════════════
//  ORDER RESPONSE MODEL
// ══════════════════════════════════════════════════════════

class OrderResponseModel {
  final int id;
  final int user;
  final String customerName;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String zipCode;
  final String subtotal;
  final String shippingFee;
  final String tax;
  final String total;
  final String discountAmount;
  final String? coupon;
  final String status;
  final String statusDisplay;
  final String paymentMethod;
  final String paymentDisplay;
  final List<OrderItemResponse> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderResponseModel({
    required this.id,
    required this.user,
    required this.customerName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.discountAmount,
    this.coupon,
    required this.status,
    required this.statusDisplay,
    required this.paymentMethod,
    required this.paymentDisplay,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      id: json['id'] as int,
      user: json['user'] as int,
      customerName: json['customer_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      zipCode: json['zip_code'] as String,
      subtotal: json['subtotal'] as String,
      shippingFee: json['shipping_fee'] as String,
      tax: json['tax'] as String,
      total: json['total'] as String,
      discountAmount: json['discount_amount'] as String,
      coupon: json['coupon'] as String?,
      status: json['status'] as String,
      statusDisplay: json['status_display'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentDisplay: json['payment_display'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ORDER ITEM RESPONSE MODEL
// ══════════════════════════════════════════════════════════

class OrderItemResponse {
  final int id;
  final int product;
  final String name;
  final String price;
  final int quantity;
  final String size;
  final String color;
  final String image;
  final double lineTotal;

  OrderItemResponse({
    required this.id,
    required this.product,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
    required this.image,
    required this.lineTotal,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      id: json['id'] as int,
      product: json['product'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      quantity: json['quantity'] as int,
      size: json['size'] as String,
      color: json['color'] as String,
      image: json['image'] as String? ?? '',
      lineTotal: double.tryParse(json['line_total'].toString()) ?? 0.0,
    );
  }
}
