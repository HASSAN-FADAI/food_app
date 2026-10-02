import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunhry_food/features/auth/view/profile_view.dart';
import 'package:hunhry_food/features/cart/views/cart_view.dart';
import 'package:hunhry_food/features/home/views/home_view.dart';
import 'package:hunhry_food/features/oreders/views/order_history_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController controller;
  late List<Widget> screens;
  int currentScreen = 0;
  @override
  void initState() {
    screens = [HomeView(), CartView(), OrderHistoryView(), ProfileView()];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white.withValues(alpha: 0.98),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.85),
              Colors.grey.shade700.withValues(alpha: 0.85),
              Colors.black.withValues(alpha: 0.85),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Center(
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey.shade600,
            currentIndex: currentScreen,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 11,
            unselectedFontSize: 10,
            iconSize: 21,
            onTap: (index) {
              setState(() {
                currentScreen = index;
              });
              controller.jumpToPage(currentScreen);
            },

            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(CupertinoIcons.home),
                ),
              ),
              BottomNavigationBarItem(
                label: ' Cart',
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(CupertinoIcons.cart),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Oreder History',
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(Icons.local_restaurant_sharp),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(CupertinoIcons.profile_circled),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
