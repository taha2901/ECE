// ══════════════════════════════════════════════════════════
//  ORDERS LIST RESPONSE MODEL
// ══════════════════════════════════════════════════════════

class OrdersListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<OrderModel> results;

  OrdersListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) {
    return OrdersListResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ORDER MODEL
// ══════════════════════════════════════════════════════════

class OrderModel {
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
  final List<OrderItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: json['id'] as int,
        user: json['user'] as int,
        customerName: json['customer_name'] as String? ?? '',
        firstName: json['first_name'] as String? ?? '',
        lastName: json['last_name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        city: json['city'] as String? ?? '',
        zipCode: json['zip_code'] as String? ?? '',
        subtotal: json['subtotal'] as String? ?? '0',
        shippingFee: json['shipping_fee'] as String? ?? '0',
        tax: json['tax'] as String? ?? '0',
        total: json['total'] as String? ?? '0',
        discountAmount: json['discount_amount'] as String? ?? '0',
        coupon: json['coupon'] as String?,
        status: json['status'] as String? ?? 'pending',
        statusDisplay: json['status_display'] as String? ?? '',
        paymentMethod: json['payment_method'] as String? ?? '',
        paymentDisplay: json['payment_display'] as String? ?? '',
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );
    } catch (e) {
      print('❌ Error parsing order: $e');
      rethrow;
    }
  }

  // Getters for computed values
  double get totalAsDouble => double.tryParse(total) ?? 0.0;
  double get subtotalAsDouble => double.tryParse(subtotal) ?? 0.0;
  double get shippingFeeAsDouble => double.tryParse(shippingFee) ?? 0.0;
  double get taxAsDouble => double.tryParse(tax) ?? 0.0;

  // Status helpers
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
}

// ══════════════════════════════════════════════════════════
//  ORDER ITEM MODEL
// ══════════════════════════════════════════════════════════

class OrderItemModel {
  final int id;
  final int product;
  final String name;
  final String price;
  final int quantity;
  final String size;
  final String color;
  final String image;
  final double lineTotal;

  OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      product: json['product'] as int,
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      quantity: json['quantity'] as int? ?? 1,
      size: json['size'] as String? ?? '',
      color: json['color'] as String? ?? '',
      image: json['image'] as String? ?? '',
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get priceAsDouble => double.tryParse(price) ?? 0.0;
}
