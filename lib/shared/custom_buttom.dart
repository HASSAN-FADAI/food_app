import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.icon,
    this.widget,
    this.color,
  });

  final String text;
  final Function()? onTap;
  final double? width;
  final double? height;
  final Icon? icon;
  final Widget? widget;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height ?? 50,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: color ?? AppColor.primary,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget != null) ...[
              widget!,
              const Gap(8),
            ] else if (icon != null) ...[
              icon!,
              const Gap(8),
            ],
            CustomText(
              text: text,
              color: Colors.white,
              size: 12,
              weight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
