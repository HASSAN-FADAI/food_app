import 'package:flutter/material.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    this.onTap,
    required this.text,
    this.color,
    this.textColor,
    this.widget,
  });
  final Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: CustomText(
            text: text,
            color: textColor ?? AppColor.primary,
            size: 17,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
