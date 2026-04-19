import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// ORDERS SCREEN
// ═══════════════════════════════════════════════
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Processing'),
            Tab(text: 'Shipped'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          4,
          (i) => ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: 5,
            itemBuilder: (_, j) => OrderItemCard(
              status: ['Processing', 'Shipped', 'Delivered', 'Cancelled'][j % 4],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String status;

  const OrderItemCard({super.key, required this.status});

  Color get _statusColor => switch (status) {
        'Processing' => AppColors.warning,
        'Shipped' => AppColors.info,
        'Delivered' => AppColors.success,
        'Cancelled' => AppColors.error,
        _ => AppColors.textHint,
      };

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
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Text('#ORD-2025-0042', style: AppTypography.labelLarge),
                const Spacer(),
                AppBadge(
                  label: status,
                  backgroundColor: _statusColor.withOpacity(0.12),
                  textColor: _statusColor,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Product Preview
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Product images
                SizedBox(
                  width: 120,
                  height: 60,
                  child: Stack(
                    children: List.generate(
                      3,
                      (i) => Positioned(
                        left: i * 22.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                            child: const Icon(Icons.image_outlined, size: 22, color: AppColors.textHint),
                          ),
                        ),
                      ),
                    ).reversed.toList(),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('3 Items', style: AppTypography.labelLarge),
                      Text('Ordered Jan 14, 2025', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$409.96', style: AppTypography.priceMedium),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {},
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
          // Action row
          if (status == 'Shipped') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.info),
                  const SizedBox(width: 6),
                  Text(
                    'Out for delivery · Est. Jan 17',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.info),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
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
          if (status == 'Delivered') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Return'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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