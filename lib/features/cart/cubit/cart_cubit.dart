import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hunhry_food/features/cart/cubit/cart_state.dart';
import 'package:hunhry_food/features/cart/data/repos/cart_repo.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartRepo cartRepo = CartRepo();
  //  Description Details [toppings,sideOptions,spicy]
  String buildDescription(Map<String, dynamic> item) {
    List<String> details = [];
    final List toppings = item['topping'] ?? [];
    final List sideOptions = item['side_option'] ?? [];
    final double spicy = (item['spicy'] ?? 0.0).toDouble();

    if (spicy > 0) {
      details.add('Spicy: ${(spicy * 100).toInt()}%');
    }
    if (toppings.isNotEmpty) {
      details.add('Toppings: ${toppings.join(', ')}');
    }
    if (sideOptions.isNotEmpty) {
      details.add('Sides: ${sideOptions.join(', ')}');
    }

    return details.isEmpty ? 'No extra options' : details.join(' | ');
  }

  // Total price for whole items
  double claculateTotal(List<Map<String, dynamic>> items) {
    double total = 0.0;
    for (var item in items) {
      final product = item['products'] ?? {};
      final double price = (product['price'] ?? 0).toDouble();
      final int quantity = (item['quantity'] ?? 1) as int;
      total += price * quantity;
    }
    return total;
  }

  List<Map<String, dynamic>> cartItems = [];
  // Get Cart

  void getCartItems() {
    emit(GetCartLodaing());
    try {
      cartRepo.streamGetCartItems().listen((result) {
        if (result.failure != null) {
          emit(GetCartError(result.failure!.messages));
        } else {
          cartItems = result.cartItems ?? [];
          emit(GetCartSuccess());
        }
      });
    } catch (e) {
      emit(GetCartError('حدث خطأ أثناء جلب سلة المشتريات'));
    }
  }

  Future<void> updateQuantity({
    required int cartItemId,
    required int newQuantity,
  }) async {
    final result = await cartRepo.updateQuantity(
      cartItemId: cartItemId,
      newQuantity: newQuantity,
    );
    if (result.failure != null) {
      emit(GetCartError(result.failure!.messages));
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    emit(RemoveCartLodaing());
    try {
      final result = await cartRepo.removeFromCart(cartItemId);
      if (result.failure != null) {
        emit(RemoveCartError(result.failure!.messages));
      } else {
        emit(RemoveCartSuccess());
      }
    } catch (e) {
      emit(RemoveCartError('حدث خطأ غير متوقع أثناء الحذف'));
    }
  }
}
