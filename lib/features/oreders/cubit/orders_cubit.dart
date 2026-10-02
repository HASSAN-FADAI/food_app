import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_state.dart';
import 'package:hunhry_food/features/oreders/data/repos/order_repo.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
  StreamSubscription? _ordersSubscription;
  final OrdersRepo ordersRepo = OrdersRepo();
  // CreatOrders

  Future<void> createOrder({
    required double totalPrice,
    required String deliveryAddress,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    emit(OrdersCreateLoading());

    final result = await ordersRepo.createOrder(
      totalPrice: totalPrice,
      deliveryAddress: deliveryAddress,
      cartItems: cartItems,
    );

    if (result.failure != null) {
      emit(OrdersError(result.failure!.messages));
    } else {
      emit(OrdersCreateSuccess());
    }
  }

  //GetMyOrders
  void getMyOrders() {
    emit(OrdersLoding());
    _ordersSubscription?.cancel();
    _ordersSubscription = ordersRepo.streamMyOrders().listen((result) {
      if (result.failure != null) {
        emit(OrdersError(result.failure!.messages));
      } else {
        emit(OrdersSuccess(result.orders ?? []));
      }
    });
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }

  Future<void> removeFromOrders(int orderItemId) async {
    emit(RemoveOrderLodaing());
    try {
      final result = await ordersRepo.removeFromOrders(orderItemId);
      if (result.failure != null) {
        emit(RemoveOrderError(result.failure!.messages));
      } else {
        emit(RemoveOrderSuccess());
      }
    } catch (e) {
      emit(RemoveOrderError('حدث خطأ غير متوقع أثناء الحذف'));
    }
  }
}
