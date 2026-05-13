import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/orders/data/models/orders_model.dart';

/// بطاقة طلب واحد في قائمة الطلبات.
class OrderItemCard extends StatelessWidget {
  final OrderModel order;

  const OrderItemCard({super.key, required this.order});

  Color get _statusColor => switch (order.status) {
        'processing' => AppColors.warning,
        'shipped' => AppColors.info,
        'delivered' => AppColors.success,
        'cancelled' => AppColors.error,
        _ => AppColors.textHint,
      };

  String _formattedDate(DateTime date) =>
      DateFormat('MMM dd, yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Text('#ORD-${order.id}', style: AppTypography.labelLarge),
                const Spacer(),
                AppBadge(
                  label: order.statusDisplay,
                  backgroundColor: _statusColor.withValues(alpha: 0.12),
                  textColor: _statusColor,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                if (order.items.isNotEmpty)
                  SizedBox(
                    width: 120,
                    height: 60,
                    child: Stack(
                      children: List.generate(
                        order.items.length.clamp(0, 3),
                        (i) => Positioned(
                          left: i * 22.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                              child: order.items[i].image.isNotEmpty
                                  ? Image.network(
                                      order.items[i].image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(
                                        Icons.image_outlined,
                                        size: 22,
                                        color: AppColors.textHint,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image_outlined,
                                      size: 22,
                                      color: AppColors.textHint,
                                    ),
                            ),
                          ),
                        ),
                      ).reversed.toList(),
                    ),
                  )
                else
                  const SizedBox(width: 120, height: 60),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.items.length} Item${order.items.length > 1 ? 's' : ''}',
                        style: AppTypography.labelLarge,
                      ),
                      Text(
                        'Ordered ${_formattedDate(order.createdAt)}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${order.total}',
                        style: AppTypography.priceMedium),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to order details
                      },
                      child: Text(
                        'Details',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (order.status == 'shipped') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Out for delivery',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.info),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement tracking
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Track'),
                  ),
                ],
              ),
            ),
          ],
          if (order.status == 'delivered') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement return
                      },
                      child: const Text('Return'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to review
                      },
                      child: const Text('Review'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
