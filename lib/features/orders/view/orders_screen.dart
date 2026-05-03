import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/orders/data/models/orders_model.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/logic/states.dart';
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
  late OrdersCubit _ordersCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _ordersCubit = context.read<OrdersCubit>();
    
    // Load orders on init
    _ordersCubit.loadOrders();
    
    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        _ordersCubit.filterByStatus('all');
        break;
      case 1:
        _ordersCubit.filterByStatus('processing');
        break;
      case 2:
        _ordersCubit.filterByStatus('shipped');
        break;
      case 3:
        _ordersCubit.filterByStatus('delivered');
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrdersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Error loading orders',
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    state.message,
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => _ordersCubit.retry(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is OrdersLoaded || state is OrdersFiltered) {
            final orders = state is OrdersLoaded
                ? state.orders
                : (state as OrdersFiltered).orders;

            if (orders.isEmpty) {
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
                    Text(
                      'No orders found',
                      style: AppTypography.h3,
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: List.generate(4, (i) {
                // Get filtered orders for each tab
                List<OrderModel> filteredOrders;
                if (state is OrdersFiltered) {
                  filteredOrders = state.orders;
                } else if (state is OrdersLoaded) {
                  if (i == 0) {
                    filteredOrders = state.allOrders;
                  } else {
                    const statuses = ['processing', 'shipped', 'delivered'];
                    filteredOrders = state.allOrders
                        .where((o) => o.status == statuses[i - 1])
                        .toList();
                  }
                } else {
                  filteredOrders = [];
                }

                if (filteredOrders.isEmpty) {
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
                        Text(
                          'No orders in this category',
                          style: AppTypography.h3,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  itemCount: filteredOrders.length,
                  itemBuilder: (_, index) => OrderItemCard(
                    order: filteredOrders[index],
                  ),
                );
              }),
            );
          }

          return const Center(
            child: Text('Unknown state'),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// ORDER ITEM CARD
// ═══════════════════════════════════════════════
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

  String _getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

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
                Text(
                  '#ORD-${order.id}',
                  style: AppTypography.labelLarge,
                ),
                const Spacer(),
                AppBadge(
                  label: order.statusDisplay,
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
                // Product images stack
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
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                              child: order.items[i].image.isNotEmpty
                                  ? Image.network(
                                      order.items[i].image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
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
                        'Ordered ${_getFormattedDate(order.createdAt)}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.total}',
                      style: AppTypography.priceMedium,
                    ),
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
          // Action row based on status
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
                    style: AppTypography.bodySmall.copyWith(color: AppColors.info),
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