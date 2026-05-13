import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';

/// تأكيد إلغاء الـ checkout والرجوع لملخص العربة.
Future<void> showCheckoutCancelDialog(BuildContext parentContext) {
  return showDialog<void>(
    context: parentContext,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Cancel Checkout?'),
      content: const Text(
        'Your progress will be lost.\nAre you sure you want to exit?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Stay'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            parentContext.go(AppRoutes.cartTotal);
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Yes, Exit'),
        ),
      ],
    ),
  );
}
