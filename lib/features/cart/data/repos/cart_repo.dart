import 'package:hunhry_food/core/errors/failure.dart';
import 'package:hunhry_food/core/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepo {
  Stream<({Failure? failure, List<Map<String, dynamic>>? cartItems})>
  streamGetCartItems() async* {
    final userId = SupabaseServices.currentUserId;

    if (userId == null) {
      yield (
        failure: const ServerFailure('المستخدم غير مسجل دخول'),
        cartItems: null,
      );
      return;
    }

    try {
      //  الاستماع للتغيرات اللحظية في جدول السلة
      final stream = SupabaseServices.client
          .from('cart_items')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId);

      //  معالجة البيانات القادمة من الـ Stream وجلب تفاصيل المنتجات لها
      await for (final items in stream) {
        if (items.isEmpty) {
          yield (failure: null, cartItems: []);
          continue;
        }

        // جلب جميع IDs الخاصة بالمنتجات الموجودة في السلة
        final productIds = items.map((e) => e['product_id']).toList();

        // جلب بيانات المنتجات المرتبطة بها دفعة واحدة من جدول products
        final productsData = await SupabaseServices.client
            .from('products')
            .select()
            .filter('id', 'in', productIds);

        // دمج بيانات المنتج داخل عنصر السلة المخصص له
        final fullCartItems = items.map((item) {
          final product = productsData.firstWhere(
            (p) => p['id'] == item['product_id'],
            orElse: () => {},
          );
          return {...item, 'products': product};
        }).toList();

        yield (failure: null, cartItems: fullCartItems);
      }
    } on PostgrestException catch (e) {
      yield (failure: ServerFailure.fromPostgrest(e), cartItems: null);
    } on AuthException catch (e) {
      yield (failure: ServerFailure.fromAuth(e), cartItems: null);
    } catch (e) {
      yield (
        failure: const ServerFailure('حدث خطأ أثناء جلب سلة المشتريات'),
        cartItems: null,
      );
    }
  }

  // تحديث كمية منتج
  Future<({Failure? failure, bool isSuccess})> updateQuantity({
    required int cartItemId,
    required int newQuantity,
  }) async {
    try {
      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }
      await SupabaseServices.client
          .from('cart_items')
          .update({'quantity': newQuantity})
          .eq('id', cartItemId);
      return (failure: null, isSuccess: true);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), isSuccess: false);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), isSuccess: false);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء تعديل الكمية'),
        isSuccess: false,
      );
    }
  }

  // حذف منتج من السلة
  Future<({Failure? failure, bool isSuccess})> removeFromCart(
    int cartItemId,
  ) async {
    try {
      await SupabaseServices.client
          .from('cart_items')
          .delete()
          .eq('id', cartItemId);

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
