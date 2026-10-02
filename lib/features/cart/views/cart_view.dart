import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/features/cart/cubit/cart_cubit.dart';
import 'package:hunhry_food/features/cart/cubit/cart_state.dart';
import 'package:hunhry_food/features/cart/widget/cart_item.dart';
import 'package:hunhry_food/features/oreders/views/checkout_view.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late List<int> quantities;
  final int itemCount = 10;
  @override
  void initState() {
    context.read<CartCubit>().getCartItems();
    quantities = List.generate(itemCount, (_) => 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (BuildContext context, state) {
          if (state is GetCartError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (BuildContext context, state) {
          final cubit = context.read<CartCubit>();
          if (state is GetCartLodaing && cubit.cartItems.isEmpty) {
            return const Center(child: CupertinoActivityIndicator(radius: 15));
          }
          if (cubit.cartItems.isEmpty) {
            return const Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -40,
                    child: Icon(CupertinoIcons.cart, color: Colors.green),
                  ),
                  Gap(10),
                  CustomText(
                    text: 'Your cart is empty',
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15, 80, 15, 120),
            itemCount: cubit.cartItems.length,
            itemBuilder: (context, index) {
              final item = cubit.cartItems[index];
              final product = item['products'] ?? {};
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CartItem(
                  image: product['imlage_url'] ?? '',
                  text: product['title'] ?? 'Item',
                  desc: cubit.buildDescription(item),
                  number: item['quantity'] ?? 1,
                  onRemove: () {
                    cubit.removeFromCart(item['id']);
                  },
                  onAdd: () {
                    cubit.updateQuantity(
                      cartItemId: item['id'],
                      newQuantity: (item['quantity'] ?? 1) + 1,
                    );
                  },
                  onMinus: () {
                    final int currentQuantity = item['quantity'] ?? 1;
                    if (currentQuantity > 1) {
                      cubit.updateQuantity(
                        cartItemId: item['id'],
                        newQuantity: (item['quantity'] ?? 1) - 1,
                      );
                    } else {
                      cubit.removeFromCart(item['id']);
                    }
                  },
                ),
              );
            },
          );
        },
      ),

      bottomSheet: BlocBuilder<CartCubit, CartState>(
        builder: (BuildContext context, state) {
          final cubit = context.read<CartCubit>();
          final total = cubit.claculateTotal(cubit.cartItems);
          return Material(
            elevation: 46,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Total',
                        color: Colors.black,
                        size: 15,
                      ),
                      CustomText(
                        text: '\$ ${total.toStringAsFixed(2)}',
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),

                  CustomButtom(
                    text: 'Check Out',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return CheckoutView();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
