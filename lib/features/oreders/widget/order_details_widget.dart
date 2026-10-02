import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxas,
    required this.fees,
    required this.total,
  });
  final String order, taxas, fees, total;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkoutWidget("Order", order, false, false),
        Gap(5),
        checkoutWidget("Taxas", taxas, false, false),
        Gap(5),
        checkoutWidget("Delivery fees", fees, false, false),
        Divider(),
        Gap(10),
        checkoutWidget("Total", total, true, false),
        Gap(10),
        checkoutWidget("Estimated delivery time:", "15 - 30 mins", true, true),
      ],
    );
  }
}

// ignore: strict_top_level_inference
Widget checkoutWidget(title, price, isBold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        size: isSmall ? 12 : 15,
        color: isBold ? Colors.black : Colors.grey.shade600,
      ),
      CustomText(
        text: '$price\$',
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        size: isSmall ? 12 : 15,
        color: isBold ? Colors.black : Colors.grey.shade600,
      ),
    ],
  );
}
