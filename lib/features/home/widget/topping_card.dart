import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ToppingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onAdd;
  final bool isSelected;

  const ToppingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onAdd,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF383232),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Center(child: Image.asset(imageUrl, height: 70)),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Color(0xFFFF334B),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isSelected ? Icons.check : Icons.add,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
