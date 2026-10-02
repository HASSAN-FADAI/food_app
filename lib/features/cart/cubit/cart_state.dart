abstract class CartState {}

class CartInitial extends CartState {}

// Get Cart
class GetCartLodaing extends CartState {}

class GetCartSuccess extends CartState {}

class GetCartError extends CartState {
  final String message;
  GetCartError(this.message);
}

// Remove Cart Item
class RemoveCartLodaing extends CartState {}

class RemoveCartSuccess extends CartState {}

class RemoveCartError extends CartState {
  final String message;
  RemoveCartError(this.message);
}
