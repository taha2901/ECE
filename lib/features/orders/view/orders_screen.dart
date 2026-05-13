import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/data/models/orders_model.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart';
import 'package:real_ecommerce/features/orders/logic/states.dart';
import 'package:real_ecommerce/features/orders/view/widgets/order_item_card.dart';
import 'package:real_ecommerce/features/orders/view/widgets/orders_placeholder_views.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthenticationAndLoadOrders();
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  void _checkAuthenticationAndLoadOrders() {
    final isLoggedIn = context.read<AuthCubit>().state.isSuccess;
    if (!isLoggedIn) {
      context.go(AppRoutes.login);
      return;
    }
    _ordersCubit.loadOrders();
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
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersError) {
            return OrdersErrorView(
              message: state.message,
              onRetry: () => _ordersCubit.retry(),
            );
          }
          if (state is OrdersLoaded || state is OrdersFiltered) {
            final orders = state is OrdersLoaded
                ? state.orders
                : (state as OrdersFiltered).orders;

            if (orders.isEmpty) {
              return const OrdersEmptyView(title: 'No orders found');
            }

            return TabBarView(
              controller: _tabController,
              children: List.generate(4, (i) {
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
                  return const OrdersEmptyView(
                    title: 'No orders in this category',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  itemCount: filteredOrders.length,
                  itemBuilder: (_, index) =>
                      OrderItemCard(order: filteredOrders[index]),
                );
              }),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
