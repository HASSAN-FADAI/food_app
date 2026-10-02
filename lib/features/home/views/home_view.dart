import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/features/home/cubit/home_cubit.dart';
import 'package:hunhry_food/features/home/cubit/home_state.dart';
import 'package:hunhry_food/features/home/widget/card_item.dart';
import 'package:hunhry_food/features/home/widget/food_categry.dart';
import 'package:hunhry_food/features/home/widget/search_field.dart';
import 'package:hunhry_food/features/home/widget/user_header.dart';
import 'package:hunhry_food/features/home/views/product_details_view.dart';
import 'package:hunhry_food/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ['All', 'Combo', 'Sliders', 'Classic'];
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Skeletonizer(
              effect: ShimmerEffect(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
              ),
              ignorePointers: true,
              ignoreContainers: true,
              enabled: state is HomeLoading,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 220,
                    toolbarHeight: 200,
                    automaticallyImplyLeading: false,
                    scrolledUnderElevation: 0,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topCenter,
                          end: AlignmentGeometry.bottomCenter,
                          colors: [
                            Color(0xFF1E3A2B),
                            Color(0xFF2D533C),
                            Color(0xFF3F6A50),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 36,
                          right: 20,
                          left: 20,
                        ),
                        child: Column(
                          children: [
                            UserHeader(),
                            Gap(15),
                            SearchField(
                              onChanged: (value) {
                                cubit.searchProducts(value);
                              },
                            ),
                            Gap(5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: FoodCategry(
                        selectedIndex: selectedIndex,
                        category: category,
                        onTap: (int index) {
                          setState(() {
                            selectedIndex = index;
                          });
                          cubit.getProductsByCategory(category[index]);
                        },
                      ),
                    ),
                  ),
                  if (state is HomeError)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: CustomText(
                            text: state.message,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          childCount: state is HomeLoading
                              ? 6
                              : cubit.products.length,
                          (context, index) {
                            final product = state is HomeLoading
                                ? {
                                    'title': 'Loading...',
                                    'descreption': 'Loading...',
                                    'image_url': '',
                                    'rating': '5.0',
                                  }
                                : cubit.products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => BlocProvider.value(
                                      value: cubit,
                                      child: ProductDetailsView(
                                        product: product,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: CardItem(
                                image:
                                    product['image_url'] ??
                                    'assets/test/humberger.png',
                                text: product['title'] ?? 'No Title',
                                desc: product['description'] ?? "",
                                rate: "${product['rating'] ?? 5.0}",
                              ),
                            );
                          },
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.64,
                          mainAxisSpacing: 10,
                        ),
                      ),
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
