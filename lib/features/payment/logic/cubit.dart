// lib/features/payment/logic/payment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:real_ecommerce/features/payment/data/repo/repo.dart';
import 'package:real_ecommerce/features/payment/logic/states.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _repo;
  String? _clientSecret;

  PaymentCubit(this._repo) : super(PaymentInitial());

  // ── Step 1: Stripe تعمل PaymentIntent ──────────────
  Future<void> createIntent({required double totalAmount}) async {
    emit(CheckoutLoading());
    try {
      _clientSecret = await _repo.createPaymentIntent(
        amountInCents: (totalAmount * 100).toInt(),
      );
      emit(CheckoutSuccess(_clientSecret!));
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
  }

  Future<void> confirmPayment({
    required String name,
    required String email,
  }) async {
    if (_clientSecret == null) return;
    emit(PaymentLoading());

    try {
      final result = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: _clientSecret!,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(name: name, email: email),
          ),
        ),
      );

      result.status == PaymentIntentsStatus.Succeeded
          ? emit(PaymentSuccess())
          : emit(PaymentFailure('Status: ${result.status.name}'));
    } on StripeException catch (e) {
      emit(PaymentFailure(e.error.localizedMessage ?? 'فشل الدفع'));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  void reset() {
    _clientSecret = null;
    emit(PaymentInitial());
  }
}
