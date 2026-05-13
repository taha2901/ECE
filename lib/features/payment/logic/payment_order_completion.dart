import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

/// بعد نجاح الدفع (كارت أو محفظة): إنشاء الطلب ثم التوجيه أو رسالة خطأ.
/// يقلل التكرار بين `CardPaymentScreen` و Google Pay.
Future<void> finalizePaidCheckoutAndNavigate(BuildContext context) async {
  final checkoutCubit = context.read<CheckoutCubit>();
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);

  await checkoutCubit.createOrder();
  if (!context.mounted) return;

  if (checkoutCubit.state.status == CheckoutStatus.orderCreated) {
    router.go(AppRoutes.paymentSuccess);
  } else {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          checkoutCubit.state.errorMessage ??
              'Order failed. Please try again.',
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
