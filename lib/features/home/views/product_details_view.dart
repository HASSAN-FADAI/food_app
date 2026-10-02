import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/home/cubit/home_cubit.dart';
import 'package:hunhry_food/features/home/cubit/home_state.dart';
import 'package:hunhry_food/features/home/widget/spicy_slider.dart';
import 'package:hunhry_food/features/home/widget/topping_card.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.product});
  final Map<String, dynamic> product;
  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = 0.4;
  List<String> selectedToppings = [];
  List<String> selectedSideOptions = [];
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.toppings;
    cubit.option;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is AddToCartSuccess) {
          CustomSnackBar.showSuccess(context, message: 'المنتج مضاف بنجاح');
        } else if (state is AddToCartError) {
          CustomSnackBar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
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
                  SpicySlider(
                    value: value,
                    onChanged: (double v) {
                      setState(() {
                        value = v;
                      });
                    },
                    imageUrl: widget.product['image_url'] ?? '',
                  ),

                  Gap(40),
                  CustomText(
                    text: 'Toppings',
                    color: Colors.black,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(cubit.toppings.length, (index) {
                        final item = cubit.toppings[index];
                        final isSelected = selectedToppings.contains(
                          item['title'],
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ToppingCard(
                            imageUrl: '${item['image']}',
                            title: '${item['title']}',
                            isSelected: isSelected,
                            onAdd: () {
                              setState(() {
                                if (isSelected) {
                                  selectedToppings.remove(item['title']);
                                } else {
                                  selectedToppings.add(item['title']);
                                }
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  Gap(20),
                  CustomText(
                    text: 'Side Options',
                    color: Colors.black,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(cubit.option.length, (index) {
                        final item = cubit.option[index];
                        final isSelected = selectedSideOptions.contains(
                          item['title'],
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ToppingCard(
                            imageUrl: '${item['image']}',
                            title: '${item['title']}',
                            isSelected: isSelected,
                            onAdd: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSideOptions.remove(item['title']);
                                } else {
                                  selectedSideOptions.add(item['title']);
                                }
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  Gap(40),
                  Row(
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
                            text: '\$ ${widget.product['price'] ?? '18.9'} ',
                            color: Colors.black,
                            size: 27,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),

                      CustomButtom(
                        color: state is AddToCartSuccess
                            ? Colors.grey.shade600
                            : AppColor.primary,
                        text: state is AddToCartSuccess
                            ? 'Added to Cart'
                            : 'Add To Cart',
                        widget: state is AddToCartLoading
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Icon(
                                state is AddToCartSuccess
                                    ? CupertinoIcons.checkmark_circle
                                    : CupertinoIcons.cart_badge_plus,
                              ),
                        onTap:
                            state is AddToCartLoading ||
                                state is AddToCartSuccess
                            ? null
                            : () async {
                                cubit.addToCart(
                                  productId: widget.product['id'],
                                  quantity: 1,
                                  spicy: value,
                                  toppings: selectedToppings,
                                  sideOptions: selectedSideOptions,
                                );
                              },
                      ),
                    ],
                  ),
                  Gap(200),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
