import 'package:real_ecommerce/features/checkout/data/models/order_models.dart';

enum CheckoutStatus {
  initial,
  loadingCartTotal,
  cartTotalLoaded,
  creatingOrder,
  orderCreated,
  error,
}

class CheckoutState {
  final CheckoutStatus status;
  final CartTotalModel? cartTotal;
  final OrderResponseModel? createdOrder;
  final String? errorMessage;
  final String? successMessage;

  // البيانات المجمعة خلال الـ checkout
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? paymentMethod; // 'deposit' or other methods
  final double? shippingFee;
  final double? tax;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.cartTotal,
    this.createdOrder,
    this.errorMessage,
    this.successMessage,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.zipCode,
    this.paymentMethod,
    this.shippingFee,
    this.tax,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    CartTotalModel? cartTotal,
    OrderResponseModel? createdOrder,
    String? errorMessage,
    String? successMessage,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? zipCode,
    String? paymentMethod,
    double? shippingFee,
    double? tax,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      cartTotal: cartTotal ?? this.cartTotal,
      createdOrder: createdOrder ?? this.createdOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingFee: shippingFee ?? this.shippingFee,
      tax: tax ?? this.tax,
    );
  }
}
