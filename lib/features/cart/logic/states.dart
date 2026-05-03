import 'package:equatable/equatable.dart';
import 'package:real_ecommerce/features/cart/data/models/cart_models.dart';

enum CartStatus { initial, loading, loaded, adding, updating, removing, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemModel> items;
  final String? message;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.message,
    this.errorMessage,
  });

  /// حساب العدد الكلي للمنتجات
  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// حساب السعر الإجمالي
  double get totalPrice => items.fold<double>(
    0,
    (sum, item) => sum + item.lineTotal,
  );

  /// التحقق من وجود عناصر في العربة
  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    List<CartItemModel>? items,
    String? message,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, message, errorMessage];
}
