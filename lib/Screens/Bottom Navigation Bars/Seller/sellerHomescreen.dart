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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController
    _pageController = PageController(initialPage: myIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Method to navigate to a page
  void _navigateBottomNavBar(int index) {
    setState(() {
      myIndex = index;
    });
    // Animate the page change
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = <Widget>[
      const SellerDashboardHome(),
      const SellerChatnavbar(),
      const SellerPostcreatenavbar(),
      const SellerCartNavbar(),
      const SellerProfilenavbar(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // PageView for swiping between pages
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                myIndex = index; // Update the bottom navigation index on swipe
              });
            },
            children: pageList,
          ),
          // Bottom Navigation Bar
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
