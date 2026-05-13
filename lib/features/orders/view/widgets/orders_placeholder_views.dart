import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

/// خطأ تحميل الطلبات + زر إعادة المحاولة.
class OrdersErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const OrdersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSpacing.lg),
          Text('Error loading orders', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

/// لا توجد طلبات (كل القائمة أو تبويب معيّن).
class OrdersEmptyView extends StatelessWidget {
  final String title;

  const OrdersEmptyView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTypography.h3),
        ],
      ),
    );
  }
}
