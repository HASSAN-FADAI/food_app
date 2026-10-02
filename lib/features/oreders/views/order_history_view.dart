import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_cubit.dart';
import 'package:hunhry_food/features/oreders/cubit/orders_state.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_snackbar.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is RemoveOrderSuccess) {
            CustomSnackBar.showSuccess(context, message: 'تم حذف الطلب بنجاح');
            // إعاده جلب الطلبات لتحديث القائمة فوراً
            context.read<OrdersCubit>().getMyOrders();
          }
          if (state is RemoveOrderError) {
            CustomSnackBar.showError(context, message: state.message);
          }
        },
        builder: (BuildContext context, state) {
          final cubit = context.read<OrdersCubit>();

          if (state is OrdersLoding) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (state is OrdersError) {
            return Center(
              child: CustomText(text: state.message, color: Colors.red),
            );
          }

          final orders = (state is OrdersSuccess)
              ? state.orders
              : <Map<String, dynamic>>[];

          if (orders.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'No order history available',
                color: Colors.grey,
                size: 16,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              final List orderItems = order['order_items'] ?? [];
              final firstProduct = orderItems.isNotEmpty
                  ? orderItems.first['products']
                  : null;
              final String imageUrl = firstProduct?['image_url'] ?? '';

              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl.startsWith('http')
                                  ? Image.network(
                                      imageUrl,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.fastfood,
                                                size: 50,
                                              ),
                                    )
                                  : const Icon(CupertinoIcons.bag_fill),
                            ),
                          ),
                          const Gap(15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Order #${order['id']}',
                                  weight: FontWeight.bold,
                                  size: 16,
                                ),
                                const Gap(4),
                                CustomText(
                                  text:
                                      'Status: ${order['status'] ?? 'Pending'}',
                                  color: Colors.grey,
                                ),
                                const Gap(4),
                                CustomText(
                                  text:
                                      'Total: \$${(order['total_price'] ?? 0).toString()}',
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtom(text: 'Re Order', onTap: () {}),
                          ),
                          const Gap(10),
                          Expanded(
                            child: CustomButtom(
                              text: 'Remove',
                              onTap: () {
                                cubit.removeFromOrders(order['id']);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
