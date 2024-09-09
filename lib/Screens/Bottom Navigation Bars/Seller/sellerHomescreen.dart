import 'package:flutter/material.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller-Tabs/seller_chatnavbar.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller-Tabs/seller_dashboard.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller-Tabs/seller_postcreatenavbar.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller-Tabs/seller_profilenavbar.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/Seller-Tabs/seller_vieworders.dart';

class Sellerhomescreen extends StatefulWidget {
  const Sellerhomescreen({super.key});

  // Static-ID of Home Screen
  static const String id = 'SellerHome-screen';

  @override
  State<Sellerhomescreen> createState() => _SellerhomescreenState();
}

class _SellerhomescreenState extends State<Sellerhomescreen> {
  int myIndex = 0;

  void _navigateBottomNavBar(int index) {
    setState(() {
      myIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = <Widget>[
      const SellerDashboardHome(),
      const SellerChatnavbar(),
      SellerPostcreatenavbar(
        onBottomSheetClosed: () {
          _navigateBottomNavBar(0); // Navigate to index 0 (home tab)
        },
      ),
      const SellerCartNavbar(),
      SellerProfilenavbar(
        onBackButtonPressed: () {
          _navigateBottomNavBar(0); // Navigate to index 0 (home tab)
        },
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          pageList[myIndex],
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                height: 60,
                color: const Color(0xFF000000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavItem('assets/images/Icons/Home.png', 0),
                    const SizedBox(width: 35), // Adjust the width as needed
                    _buildNavItem('assets/images/Icons/Chat.png', 1),
                    const SizedBox(width: 35), // Adjust the width as needed
                    _buildNavItem('assets/images/Icons/Post.png', 2),
                    const SizedBox(width: 35), // Adjust the width as needed
                    _buildNavItem('assets/images/Icons/Manage.png', 3),
                    const SizedBox(width: 35), // Adjust the width as needed
                    _buildNavItem('assets/images/Icons/Profile.png', 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    return GestureDetector(
      onTap: () => _navigateBottomNavBar(index),
      child: ImageIcon(
        AssetImage(assetPath),
        color: myIndex == index ? Colors.white : Colors.grey,
      ),
    );
  }
}
