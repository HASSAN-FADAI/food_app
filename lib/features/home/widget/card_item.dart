import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    required this.rate,
  });
  final String image, text, desc, rate;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image.trim().isNotEmpty
                ? Image.network(
                    image,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/test/humberger.png'),
                  )
                : Image.asset('assets/test/humberger.png'),
            Gap(5),
            CustomText(
              text: text,
              color: Colors.black,
              size: 12,
              weight: FontWeight.bold,
            ),
            CustomText(
              text: desc,
              color: Colors.black,
              size: 12,
              weight: FontWeight.normal,
            ),
            Row(
              children: [
                CustomText(
                  text: '⭐$rate',
                  color: Colors.black,
                  size: 12,
                  weight: FontWeight.w600,
                ),
                Spacer(),
                Icon(CupertinoIcons.heart, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
