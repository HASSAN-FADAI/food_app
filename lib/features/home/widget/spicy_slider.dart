import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.imageUrl,
  });
  final double value;
  final ValueChanged<double> onChanged;
  final String imageUrl;
  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.imageUrl.trim().isNotEmpty
            ? Image.network(
                widget.imageUrl,
                height: 153,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/details/product detail.png',
                  height: 200,
                ),
              )
            : Image.asset('assets/details/product detail.png', height: 200),
        Spacer(),
        Column(
          children: [
            CustomText(
              text:
                  'Customize Your Burger\n to Your Tastes.\n Ultimate Experience',
              color: Colors.black,
              size: 12,
              weight: FontWeight.normal,
            ),

            Slider(
              min: 0,
              max: 1,
              value: widget.value,
              onChanged: widget.onChanged,
              activeColor: AppColor.primary,
            ),

            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomText(
                  text: '🥶',
                  color: Colors.black,
                  size: 12,
                  weight: FontWeight.normal,
                ),
                Gap(100),
                CustomText(
                  text: '🌶️',
                  color: Colors.black,
                  size: 12,
                  weight: FontWeight.normal,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
