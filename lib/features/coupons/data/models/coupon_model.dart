import 'package:intl/intl.dart';

class CouponModel {
  final int? id;
  final String code;
  final String title;
  final String? description;
  final DateTime? expiresAt;
  final bool isActive;

  CouponModel({
    this.id,
    required this.code,
    required this.title,
    this.description,
    this.expiresAt,
    this.isActive = true,
  });

  String get expiryLabel {
    if (expiresAt == null) return 'No expiry date';
    return DateFormat('MMM dd, yyyy').format(expiresAt!);
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final rawCode = json['code'] ?? json['coupon_code'] ?? json['name'] ?? json['title'];
    final rawDiscount = json['discount'] ?? json['amount'] ?? json['percent'] ?? json['value'];
    final title = rawDiscount != null ? rawDiscount.toString() : json['title']?.toString() ?? 'Coupon';
    return CouponModel(
      id: _parseInt(json['id']),
      code: rawCode?.toString() ?? 'UNKNOWN',
      title: title,
      description: json['description']?.toString() ?? json['detail']?.toString(),
      expiresAt: _parseDate(json['expires_at'] ?? json['expiry'] ?? json['valid_until'] ?? json['expires']),
      isActive: _parseBool(json['is_active'] ?? json['active'] ?? json['status']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1' || value.toLowerCase() == 'active';
    }
    return true;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
