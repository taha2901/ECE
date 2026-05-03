import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/orders/data/models/orders_model.dart';
import 'package:real_ecommerce/features/orders/data/repo/orders_repository.dart';
import 'package:real_ecommerce/features/orders/logic/states.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersInitial());

  List<OrderModel> _allOrders = [];

  // ══════════════════════════════════════════════════════════
  //  LOAD ALL ORDERS
  // ══════════════════════════════════════════════════════════
  Future<void> loadOrders() async {
    try {
      emit(const OrdersLoading());

      final result = await _repository.getOrders();

      result.when(
        success: (response) {
          _allOrders = response.results;
          print('✅ Orders loaded: ${response.results.length} orders');
          emit(OrdersLoaded(
            orders: response.results,
            allOrders: response.results,
          ));
        },
        failure: (error) {
          print('❌ Error loading orders: ${error.apiErrorModel.readableMessage}');
          emit(OrdersError(error.apiErrorModel.readableMessage));
        },
      );
    } catch (e) {
      print('❌ Exception in loadOrders: $e');
      emit(OrdersError(e.toString()));
    }
  }

  // ══════════════════════════════════════════════════════════
  //  FILTER ORDERS BY STATUS
  // ══════════════════════════════════════════════════════════
  void filterByStatus(String status) {
    try {
      if (status == 'all') {
        print('🔄 Showing all orders: ${_allOrders.length}');
        emit(OrdersFiltered(
          orders: _allOrders,
          filterStatus: 'all',
        ));
      } else {
        final filtered = _allOrders
            .where((order) => order.status == status)
            .toList();
        print('🔄 Filtering by status "$status": ${filtered.length} orders found');
        emit(OrdersFiltered(
          orders: filtered,
          filterStatus: status,
        ));
      }
    } catch (e) {
      print('❌ Error filtering orders: $e');
      emit(OrdersError(e.toString()));
    }
  }

  // ══════════════════════════════════════════════════════════
  //  GET ORDER DETAILS
  // ══════════════════════════════════════════════════════════
  Future<void> getOrderDetails(int orderId) async {
    try {
      emit(const OrderDetailsLoading());

      final result = await _repository.getOrderDetails(orderId);

      result.when(
        success: (order) {
          print('✅ Order details loaded: Order #$orderId');
          emit(OrderDetailsLoaded(order));
        },
        failure: (error) {
          print('❌ Error loading order details: ${error.apiErrorModel.readableMessage}');
          emit(OrderDetailsError(error.apiErrorModel.readableMessage));
        },
      );
    } catch (e) {
      print('❌ Exception in getOrderDetails: $e');
      emit(OrderDetailsError(e.toString()));
    }
  }

  // ══════════════════════════════════════════════════════════
  //  RETRY LOADING ORDERS
  // ══════════════════════════════════════════════════════════
  Future<void> retry() async {
    print('🔄 Retrying to load orders...');
    await loadOrders();
  }
}
