abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersCreateLoading extends OrdersState {}

class OrdersCreateSuccess extends OrdersState {}

class OrdersCreateError extends OrdersState {
  final String message;
  OrdersCreateError(this.message);
}

class OrdersLoding extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<Map<String, dynamic>> orders;
  OrdersSuccess(this.orders);
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}

// Remove Order Item
class RemoveOrderLodaing extends OrdersState {}

class RemoveOrderSuccess extends OrdersState {}

class RemoveOrderError extends OrdersState {
  final String message;
  RemoveOrderError(this.message);
}
