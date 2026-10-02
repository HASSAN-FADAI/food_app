import 'package:hunhry_food/core/errors/failure.dart';
import 'package:hunhry_food/core/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersRepo {
  //  إنشاء طلب جديد
  Future<({Failure? failure, Map<String, dynamic>? order})> createOrder({
    required double totalPrice,
    required String deliveryAddress,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    try {
      final userId = SupabaseServices.client.auth.currentUser?.id;
      if (userId == null) {
        return (
          failure: const ServerFailure('المستخدم غير مسجل دخول'),
          order: null,
        );
      }

      //  إنشاء سجل الطلب في جدول orders
      final orderResponse = await SupabaseServices.client
          .from('orders')
          .insert({
            'user_id': userId,
            'total_price': totalPrice,
            'status': 'pending',
            'delivery_address': deliveryAddress,
            'items': cartItems,
          })
          .select()
          .single();
      final orderId = orderResponse['id'];
      final orderItemsData = cartItems.map((item) {
        return {
          'order_id': orderId,
          'product_id': item['product_id'],
          'quantity': item['quantity'] ?? 1,
          'price': item['products']?['price'] ?? 0,
        };
      }).toList();
      await SupabaseServices.client.from('order_items').insert(orderItemsData);
      // تنظيف سلة المشتريات بعد إتمام الطلب بنجاح
      await SupabaseServices.client
          .from('cart_items')
          .delete()
          .eq('user_id', userId);

      return (failure: null, order: orderResponse);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), order: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), order: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء إتمام الطلب'),
        order: null,
      );
    }
  }

  // جلب سجل طلبات المستخدم
  Stream<({Failure? failure, List<Map<String, dynamic>>? orders})>
  streamMyOrders() async* {
    final userId = SupabaseServices.client.auth.currentUser?.id;

    if (userId == null) {
      yield (
        failure: const ServerFailure('المستخدم غير مسجل دخول'),
        orders: null,
      );
      return;
    }

    try {
      final stream = SupabaseServices.client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      await for (final ordersList in stream) {
        final List<Map<String, dynamic>> enrichedOrders = [];
        for (var order in ordersList) {
          final itemsResponse = await SupabaseServices.client
              .from('order_items')
              .select('*,products(*)')
              .eq('order_id', order['id']);

          final mutableOrder = Map<String, dynamic>.from(order);
          mutableOrder['order_items'] = itemsResponse;
          enrichedOrders.add(mutableOrder);
        }
        yield (failure: null, orders: enrichedOrders);
      }
    } on PostgrestException catch (e) {
      yield (failure: ServerFailure.fromPostgrest(e), orders: null);
    } on AuthException catch (e) {
      yield (failure: ServerFailure.fromAuth(e), orders: null);
    } catch (e) {
      yield (
        failure: const ServerFailure('حدث خطأ أثناء جلب الطلبات'),
        orders: null,
      );
    }
  }

  // حذف منتج من السلة
  Future<({Failure? failure, bool isSuccess})> removeFromOrders(
    int orderItemId,
  ) async {
    try {
      await SupabaseServices.client
          .from('orders')
          .delete()
          .eq('id', orderItemId);

      return (failure: null, isSuccess: true);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), isSuccess: false);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), isSuccess: false);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء حذف المنتج'),
        isSuccess: false,
      );
    }
  }
}
