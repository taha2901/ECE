import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

/// إجمالي المبلغ المرسل لـ Stripe `PaymentIntent` (بدون أي UI).
/// يعاد استخدامه من أي شاشة دفع أو من تطبيق آخر يستورد نفس الـ checkout state.
double checkoutGrandTotalForStripe(CheckoutState state) {
  final subtotal = state.cartTotal?.totalAsDouble ?? 0.0;
  final shipping = state.shippingFee ?? 10.0;
  final tax = state.tax ?? 0.0;
  return subtotal + shipping + tax;
}
