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
    final results = json['results'];
    return OrdersListResponse(
      count: _parseInt(json['count']),
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: results is List
          ? results
              .map((e) => OrderModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : [],
    );
  }

  factory OrdersListResponse.fromList(List<dynamic> jsonList) {
    return OrdersListResponse(
      count: jsonList.length,
      next: null,
      previous: null,
      results: jsonList
          .map((e) => OrderModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
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
    return OrderModel(
      id: _parseInt(json['id']),
      user: _parseInt(json['user']),
      customerName: _parseString(json['customer_name']),
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      address: _parseString(json['address']),
      city: _parseString(json['city']),
      zipCode: _parseString(json['zip_code']),
      subtotal: _parseString(json['subtotal'], '0'),
      shippingFee: _parseString(json['shipping_fee'], '0'),
      tax: _parseString(json['tax'], '0'),
      total: _parseString(json['total'], '0'),
      discountAmount: _parseString(json['discount_amount'], '0'),
      coupon: json['coupon'] != null ? _parseString(json['coupon']) : null,
      status: _parseString(json['status'], 'pending'),
      statusDisplay: _parseString(json['status_display']),
      paymentMethod: _parseString(json['payment_method']),
      paymentDisplay: _parseString(json['payment_display']),
      items: _parseOrderItems(json['items']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
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
      id: _parseInt(json['id']),
      product: _parseInt(json['product']),
      name: _parseString(json['name']),
      price: _parseString(json['price'], '0'),
      quantity: _parseInt(json['quantity'], 1),
      size: _parseString(json['size']),
      color: _parseString(json['color']),
      image: _parseString(json['image']),
      lineTotal: _parseDouble(json['line_total']),
    );
  }

  double get priceAsDouble => double.tryParse(price) ?? 0.0;
}

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

String _parseString(dynamic value, [String defaultValue = '']) {
  if (value == null) return defaultValue;
  if (value is String) return value;
  return value.toString();
}

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

DateTime _parseDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
    final millis = int.tryParse(value);
    if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
  }
  return DateTime.now();
}

List<OrderItemModel> _parseOrderItems(dynamic value) {
  if (value is List) {
    return value
        .map((item) => OrderItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }
  return [];
}
