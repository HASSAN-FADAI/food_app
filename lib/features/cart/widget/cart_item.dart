import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    this.onAdd,
    this.onRemove,
    this.onMinus,
    required this.number,
  });
  final String image, text, desc;
  final Function()? onAdd;
  final Function()? onRemove;
  final Function()? onMinus;
  final int number;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.fastfood, size: 50),
                    )
                  : Image.asset(
                      image,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.fastfood, size: 50),
                    ),
            ),
            const Gap(12),
            // Expanded(
            //   child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       CustomText(text: text, weight: FontWeight.bold),
            //       const Gap(4),
            //       CustomText(text: desc,),

            //     ],
            //   ),
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: text, weight: FontWeight.bold, size: 16),
                  const Gap(4),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const Gap(8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onAdd,
                      child: CircleAvatar(
                        backgroundColor: AppColor.primary,
                        child: const Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Gap(8),
                    CustomText(
                      text: number.toString(),
                      weight: FontWeight.w400,
                      size: 20,
                    ),
                    Gap(8),
                    GestureDetector(
                      onTap: onMinus,
                      child: CircleAvatar(
                        backgroundColor: AppColor.primary,
                        child: const Icon(
                          CupertinoIcons.minus,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(15),
                InkWell(
                  onTap: onRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: 120,
                    height: 45,

                    child: Center(child: const CustomButtom(text: 'Remove')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
