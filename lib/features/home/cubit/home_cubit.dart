import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hunhry_food/core/services/supabase_services.dart'
    show SupabaseServices;
import 'package:hunhry_food/features/home/cubit/home_state.dart';
import 'package:hunhry_food/features/home/data/repos/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  HomeRepo homeRepo = HomeRepo();
  List products = [];
  List _allProducts = [];

  List<Map> toppings = [
    {'title': 'tomato', 'image': 'assets/icon/tomato.png'},
    {'title': 'Red Onion', 'image': 'assets/icon/red_onion.png'},
    {'title': 'Pickles', 'image': 'assets/icon/pickles.png'},
    {'title': 'Bacons', 'image': 'assets/icon/bacons.png'},
  ];
  List option = [
    {'title': 'Fries', 'image': 'assets/icon/fries.png'},
    {'title': 'Onion', 'image': 'assets/icon/onion.png'},
    {'title': 'Salad', 'image': 'assets/icon/salad.png'},
    {'title': 'Bacons', 'image': 'assets/icon/bacons.png'},
  ];
  // get products function
  Future getProducts() async {
    emit(HomeLoading());
    try {
      final result = await homeRepo.getProducts();

      if (result.failure != null) {
        emit(HomeError(result.failure!.messages));
      } else {
        final response = await SupabaseServices.client
            .from('products')
            .select();
        _allProducts = List<Map<String, dynamic>>.from(response);
        products = List.from(_allProducts);
        emit(HomeSuccess());
      }
    } catch (e) {
      emit(HomeError('أحيانا تحدث أخطاء'));
    }
  }

  Future getProductsByCategory(String category) async {
    emit(HomeLoading());
    try {
      final result = category == 'All'
          ? await homeRepo.getProducts()
          : await homeRepo.getProductsByCategory(category.toLowerCase());
      if (result.failure != null) {
        emit(HomeError(result.failure!.messages));
      } else {
        products = result.products ?? [];
        emit(HomeSuccess());
      }
    } catch (e) {
      emit(HomeError('حدث أخطاء أثناء تصفية المنتجات'));
    }
  }

  Future searchProducts(String query) async {
    if (query.trim().isEmpty) {
      products = List.from(_allProducts);
    } else {
      products = _allProducts.where((product) {
        final title = product['title']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase().trim();
        return title.contains(searchLower);
      }).toList();
    }
    emit(HomeSuccess());
  }

  //Add To Cart
  Future<void> addToCart({
    required int productId,
    int quantity = 1,
    double spicy = 0.0,
    List<String> toppings = const [],
    List<String> sideOptions = const [],
  }) async {
    emit(AddToCartLoading());
    try {
      final result = await homeRepo.addToCart(
        productId: productId,
        quantity: quantity,
        spicy: spicy,
        topping: toppings,
        sideOption: sideOptions,
      );
      if (result.isSuccess) {
        emit(AddToCartSuccess());
      } else {
        emit(
          AddToCartError(
            result.failure?.messages ?? 'حدث خطأ أثناء إضافة المنتج للسلة',
          ),
        );
      }
    } catch (e) {
      emit(AddToCartError('حدث خطاغير متوقع '));
    }
  }
}
