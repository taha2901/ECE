import 'package:dio/dio.dart';

class PaymentRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.stripe.com/v1/',
    headers: {
      'Authorization': 'Bearer REDACTED', // ← هنا
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  ));

  Future<String> createPaymentIntent({
    required int amountInCents, // 1000 = $10.00
    String currency = 'usd',
  }) async {
    final response = await _dio.post(
      'payment_intents',
      data: {
        'amount': amountInCents,
        'currency': currency,
        'payment_method_types[]': 'card',
      },
    );
    return response.data['client_secret'] as String;
  }
}