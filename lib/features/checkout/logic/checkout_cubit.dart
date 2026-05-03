import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/checkout/data/models/order_models.dart';
import 'package:real_ecommerce/features/checkout/data/repo/checkout_repository.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepository _repository;
  final AuthCubit _authCubit;

  CheckoutCubit(this._repository, this._authCubit)
      : super(const CheckoutState());

  /// احصل على إجمالي السلة
  Future<void> loadCartTotal() async {
    emit(state.copyWith(status: CheckoutStatus.loadingCartTotal));
    
    final result = await _repository.getCartTotal();

    result.when(
      success: (data) {
        emit(state.copyWith(
          status: CheckoutStatus.cartTotalLoaded,
          cartTotal: data,
          errorMessage: null,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: error.apiErrorModel.readableMessage,
        ));
      },
    );
  }

  /// حدّث بيانات المستخدم في الـ checkout
  void updateUserData({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? zipCode,
  }) {
    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      city: city,
      zipCode: zipCode,
    ));
  }

  /// حدّث طريقة الدفع والرسوم
  void updatePaymentInfo({
    String? paymentMethod,
    double? shippingFee,
    double? tax,
  }) {
    emit(state.copyWith(
      paymentMethod: paymentMethod,
      shippingFee: shippingFee,
      tax: tax,
    ));
  }

  /// جلب بيانات المستخدم من الـ auth إذا كان مسجل دخول
  void loadUserDataFromAuth() {
    final authState = _authCubit.state;
    if (authState.status == AuthStatus.success &&
        authState.authData != null &&
        authState.authData!.user != null) {
      final userData = authState.authData!.user!;
      updateUserData(
        firstName: userData.firstName,
        lastName: userData.lastName,
        email: userData.email,
        phone: userData.phone,
        address: userData.address,
        city: userData.city,
      );
    }
  }

  /// إنشاء أوردر
  Future<void> createOrder() async {
    if (state.cartTotal == null) {
      emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: 'Cart is empty',
      ));
      return;
    }

    if (state.firstName == null ||
        state.lastName == null ||
        state.email == null ||
        state.phone == null ||
        state.address == null ||
        state.city == null) {
      emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: 'Please fill in all required fields',
      ));
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.creatingOrder));

    // حساب الإجمالي
    final cartItems = state.cartTotal!.items;
    final subtotal = state.cartTotal!.totalAsDouble;
    final shippingFee = state.shippingFee ?? 0.0;
    final tax = state.tax ?? 0.0;
    final total = subtotal + shippingFee + tax;

    // تحويل عناصر السلة إلى عناصر الأوردر
    final orderItems = cartItems
        .map((item) => OrderItemRequest(
              productId: item.productId,
              name: item.productName,
              price: item.price.toString(),
              quantity: item.quantity,
              size: item.size,
              color: item.color,
            ))
        .toList();

    // الحصول على ID المستخدم من الـ auth
    final authState = _authCubit.state;
    final userId =
        authState.authData?.user?.id ?? 1;

    final request = CreateOrderRequest(
      user: userId,
      firstName: state.firstName!,
      lastName: state.lastName!,
      email: state.email!,
      phone: state.phone!,
      address: state.address!,
      city: state.city!,
      zipCode: state.zipCode ?? '',
      subtotal: subtotal.toStringAsFixed(2),
      shippingFee: shippingFee.toStringAsFixed(2),
      tax: tax.toStringAsFixed(2),
      total: total.toStringAsFixed(2),
      paymentMethod: state.paymentMethod ?? 'deposit',
      items: orderItems,
    );

    final result = await _repository.createOrder(request);

    result.when(
      success: (data) {
        emit(state.copyWith(
          status: CheckoutStatus.orderCreated,
          createdOrder: data,
          successMessage: 'Order created successfully!',
          errorMessage: null,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: error.apiErrorModel.readableMessage,
        ));
      },
    );
  }

  /// مسح الرسالة
  void clearMessage() {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }

  /// إعادة تعيين الحالة
  void reset() {
    emit(const CheckoutState());
  }
}
