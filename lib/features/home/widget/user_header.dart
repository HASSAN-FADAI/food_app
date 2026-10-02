import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hunhry_food/core/constants/app_color.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/text_logo/Hungry_.svg', height: 30),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColor.primary,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }
}
