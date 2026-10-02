import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_buttom.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColor.primary,
              child: const Icon(
                CupertinoIcons.check_mark,
                size: 30,
                color: Colors.white,
              ),
            ),
            const Gap(10),
            CustomText(
              text: 'Success',
              color: AppColor.primary,
              size: 20,
              weight: FontWeight.bold,
            ),
            const Gap(10),
            CustomButtom(
              text: 'Close',
              width: 200,
              onTap: () {
                Navigator.pop(context); // إغلاق Dialog
                Navigator.pop(context); // العودة للصفحة السابقة
              },
            ),
          ],
        ),
      ),
    );
  }
}
