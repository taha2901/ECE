import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentRepository {
  PaymentRepository()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.stripe.com/v1/',
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY'] ?? ''}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        )) {
    final secretKey = dotenv.env['STRIPE_SECRET_KEY'];
    if (secretKey == null || secretKey.isEmpty) {
      throw StateError('Missing STRIPE_SECRET_KEY in .env');
    }
  }

  final Dio _dio;

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