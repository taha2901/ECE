import 'package:equatable/equatable.dart';
import '../data/models/orders_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

// ══════════════════════════════════════════════════════════
//  INITIAL STATE
// ══════════════════════════════════════════════════════════
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

// ══════════════════════════════════════════════════════════
//  LOADING STATE
// ══════════════════════════════════════════════════════════
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

// ══════════════════════════════════════════════════════════
//  SUCCESS STATE
// ══════════════════════════════════════════════════════════
class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final List<OrderModel> allOrders; // Keep original for filtering

  const OrdersLoaded({
    required this.orders,
    required this.allOrders,
  });

  @override
  List<Object?> get props => [orders, allOrders];
}

// ══════════════════════════════════════════════════════════
//  FILTERED STATE
// ══════════════════════════════════════════════════════════
class OrdersFiltered extends OrdersState {
  final List<OrderModel> orders;
  final String filterStatus;

  const OrdersFiltered({
    required this.orders,
    required this.filterStatus,
  });

  @override
  List<Object?> get props => [orders, filterStatus];
}

// ══════════════════════════════════════════════════════════
//  ERROR STATE
// ══════════════════════════════════════════════════════════
class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════════════════════
//  ORDER DETAILS LOADING STATE
// ══════════════════════════════════════════════════════════
class OrderDetailsLoading extends OrdersState {
  const OrderDetailsLoading();
}

// ══════════════════════════════════════════════════════════
//  ORDER DETAILS LOADED STATE
// ══════════════════════════════════════════════════════════
class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

// ══════════════════════════════════════════════════════════
//  ORDER DETAILS ERROR STATE
// ══════════════════════════════════════════════════════════
class OrderDetailsError extends OrdersState {
  final String message;

  const OrderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
