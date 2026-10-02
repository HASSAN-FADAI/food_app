import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunhry_food/core/constants/app_color.dart';
import 'package:hunhry_food/shared/custom_text.dart';

class FoodCategry extends StatefulWidget {
  const FoodCategry({
    super.key,
    required this.selectedIndex,
    required this.category,
    required this.onTap,
  });
  final int selectedIndex;
  final List category;
  final Function(int index) onTap;
  @override
  State<FoodCategry> createState() => _FoodCategryState();
}

class _FoodCategryState extends State<FoodCategry> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FoodCategry oldWidget) {
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        selectedIndex = widget.selectedIndex;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.category.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? AppColor.primary
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: CustomText(
                text: widget.category[index],
                color: selectedIndex == index ? Colors.white : Colors.black,
                size: 12,
                weight: FontWeight.w800,
              ),
            ),
          );
        }),
      ),
    );
  }
}
