import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/cart/cubit/cart_cubit.dart';
import 'package:hunhry_food/features/cart/cubit/cart_state.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_cubit.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_state.dart';
import 'package:hunhry_food/features/oreders/widget/order_details_widget.dart';
import 'package:hunhry_food/features/oreders/widget/success_dialog.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedMethod = 'Cash';
  bool selectedCheckBox = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (BuildContext context, state) {
        context.read<CartCubit>().getCartItems();
        if (state is OrdersCreateSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return SuccessDialog();
            },
          );
        }
        if (state is OrdersCreateError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final cartCubit = context.read<CartCubit>();
        final items = cartCubit.cartItems;
        final total = cartCubit.claculateTotal(items);
        final totals = total + 1.5;
        final emptyItems = items.isEmpty;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Oredr summary',
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                  OrderDetailsWidget(
                    order: '\$ ${total.toStringAsFixed(2)}',
                    taxas: "0.0",
                    fees: "1.5",
                    total: emptyItems
                        ? "\$ 0.00"
                        : '\$ ${totals.toStringAsFixed(2)}',
                  ),
                  Gap(30),
                  CustomText(
                    text: 'Payment methods',
                    weight: FontWeight.w500,
                    size: 20,
                  ),
                  Gap(20),

                  RadioGroup(
                    groupValue: selectedMethod,
                    onChanged: (v) {
                      setState(() {
                        selectedMethod = v!;
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              selectedMethod = 'Cash';
                            });
                          },
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Color(0xff3C2F2F),
                          leading: Image.asset(
                            "assets/icon/dollar Background Removed 1.png",
                            width: 50,
                          ),
                          title: CustomText(
                            text: 'Cash On Delivery',
                            color: Colors.white,
                          ),
                          trailing: Radio<String>(
                            activeColor: Colors.white,
                            value: 'Cash',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(20),
                  RadioGroup(
                    groupValue: selectedMethod,
                    onChanged: (v) {
                      setState(() {
                        selectedMethod = v!;
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              selectedMethod = 'Visa';
                            });
                          },
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: Colors.blue.shade900,
                          leading: Image.asset(
                            "assets/icon/Visa.png",
                            width: 50,
                          ),
                          title: CustomText(
                            text: 'Debbit On Card',
                            color: Colors.white,
                          ),
                          subtitle: CustomText(
                            text: '**** ****** 2435',
                            color: Colors.white,
                          ),
                          trailing: Radio<String>(
                            activeColor: Colors.white,
                            value: 'Visa',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(5),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xffEF2A39),
                        value: selectedCheckBox,
                        onChanged: (v) {
                          setState(() {
                            selectedCheckBox = v!;
                          });
                        },
                      ),
                      CustomText(text: 'Save card details for future payments'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          bottomSheet: Container(
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
            height: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Total',
                        color: Colors.black,
                        size: 15,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: emptyItems
                            ? "\$ 0.00"
                            : '\$ ${totals.toStringAsFixed(2)}',
                        color: Colors.black,
                        size: 27,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),

                  state is OrdersCreateLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : CustomButtom(
                          text: 'Pay Now',
                          onTap: () {
                            if (items.isEmpty) {
                              CustomSnackBar.showError(
                                context,
                                message: 'سلة المشتريات فارغة',
                              );
                              return;
                            }
                            cubit.createOrder(
                              totalPrice: total,
                              deliveryAddress: 'Home Address',
                              cartItems: items,
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
