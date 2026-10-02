import 'package:hunhry_food/core/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failure.dart';

class HomeRepo {
  Future<({Failure? failure, List<Map<String, dynamic>>? products})>
  getProducts() async {
    try {
      final response = await SupabaseServices.client
          .from('products')
          .select()
          .order('created_at', ascending: false);
      return (failure: null, products: response);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure(e.message), products: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), products: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطا أثناء جلب المنتجات'),
        products: null,
      );
    }
  }

  // (Category)
  Future<({Failure? failure, List<Map<String, dynamic>>? products})>
  getProductsByCategory(String category) async {
    try {
      final response = await SupabaseServices.client
          .from('products')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      return (failure: null, products: response);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), products: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), products: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطا أثناء تصفية المنتجات'),
        products: null,
      );
    }
  }

  // البحث عن منتج بواسطة الاسم
  Future<({Failure? failure, List<Map<String, dynamic>>? products})>
  searchProducts(String query) async {
    try {
      final response = await SupabaseServices.client
          .from('products')
          .select()
          .ilike('title', '%$query%');
      return (failure: null, products: response);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), products: null);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), products: null);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء البحث عن المنتج'),
        products: null,
      );
    }
  }

  //اضافة منتحات للسلة
  Future<({Failure? failure, bool isSuccess})> addToCart({
    required int productId,
    int quantity = 1,
    double spicy = 0.0,
    List<String> topping = const [],
    List<String> sideOption = const [],
  }) async {
    try {
      final userId = SupabaseServices.client.auth.currentUser?.id;
      if (userId == null) {
        return (
          failure: const ServerFailure('المستخدم غير مسجل دخول'),
          isSuccess: false,
        );
      }
      final existingItem = await SupabaseServices.client
          .from('cart_items')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();
      if (existingItem != null) {
        final currentQuantity = existingItem['quantity'] as int;
        await SupabaseServices.client
            .from('cart_items')
            .update({'quantity': currentQuantity + quantity})
            .eq('id', existingItem['id']);
      } else {
        await SupabaseServices.client.from('cart_items').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
          'spicy': spicy,
          'topping': topping,
          'side_option': sideOption,
        });
      }

      return (failure: null, isSuccess: true);
    } on PostgrestException catch (e) {
      return (failure: ServerFailure.fromPostgrest(e), isSuccess: false);
    } on AuthException catch (e) {
      return (failure: ServerFailure.fromAuth(e), isSuccess: false);
    } catch (e) {
      return (
        failure: const ServerFailure('حدث خطأ أثناء إضافة المنتج للسلة'),
        isSuccess: false,
      );
    }
  }

  // Future<({Failure? failure, String? imageUrl})> uploadProductImage(File imageFile) async {
  //   try {
  //     final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final path = 'products/$fileName';

  //     // رفع الصورة إلى الباكت (Bucket) الخاص بالمنتجات
  //     await SupabaseServices.client.storage
  //         .from('products_images')
  //         .upload(path, imageFile);

  //     // جلب الرابط العام للصورة
  //     final imageUrl = SupabaseServices.client.storage
  //         .from('products_images')
  //         .getPublicUrl(path);

  //     return (failure: null, imageUrl: imageUrl);
  //   } on StorageException catch (e) {
  //     return (failure: ServerFailure(e.message), imageUrl: null);
  //   } catch (e) {
  //     return (failure: const ServerFailure('حدث خطأ أثناء رفع الصورة'), imageUrl: null);
  //   }
  // }

  // // 2. إضافة منتج جديد إلى جدول products
  // Future<({Failure? failure, bool isSuccess})> addProduct({
  //   required String title,
  //   required String description,
  //   required double price,
  //   required String category,
  //   required String imageUrl,
  // }) async {
  //   try {
  //     await SupabaseServices.client.from('products').insert({
  //       'title': title,
  //       'description': description,
  //       'price': price,
  //       'category': category,
  //       'image_url': imageUrl,
  //       'rating': 5.0, // تقييم افتراضي للمنتج الجديد
  //     });

  //     return (failure: null, isSuccess: true);
  //   } on PostgrestException catch (e) {
  //     return (failure: ServerFailure(e.message), isSuccess: false);
  //   } catch (e) {
  //     return (failure: const ServerFailure('حدث خطأ أثناء إضافة المنتج'), isSuccess: false);
  //   }
  // }
}
