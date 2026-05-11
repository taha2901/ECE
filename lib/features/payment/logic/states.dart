abstract class PaymentState {}

/// Initial — screen just opened, nothing started yet
class PaymentInitial extends PaymentState {}

/// Phase 1: calling your backend /orders/
class CheckoutLoading extends PaymentState {}

/// Phase 1 done — we hold the client_secret; show card form
class CheckoutSuccess extends PaymentState {
  final String clientSecret;
  CheckoutSuccess(this.clientSecret);
}

/// Phase 1 failed — show error, never reached Stripe
class CheckoutFailure extends PaymentState {
  final String message;
  CheckoutFailure(this.message);
}

/// Phase 2: Stripe.confirmPayment() in flight
class PaymentLoading extends PaymentState {}

/// Phase 2 done — navigate to success screen
class PaymentSuccess extends PaymentState {}

/// Phase 2 failed — allow retry WITHOUT re-calling backend
class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}