import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database
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

// Variables to store dynamic values
  String postId = ""; // Initialize postId
  String sellerUid = ""; // Initialize sellerUid

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: myIndex);
    // Fetch the post data when the HomeScreen is initialized
    _fetchPostData();
  }

  // Fetch post data dynamically (from Firebase)
  Future<void> _fetchPostData() async {
    // Example Firebase Realtime Database reference
    DatabaseReference postRef =
        FirebaseDatabase.instance.ref().child('Post List');

    // Fetch the first post (or implement your filtering logic to get the correct post)
    postRef.once().then((DataSnapshot snapshot) {
          if (snapshot.exists) {
            // Assuming the first post in the list (you can filter this based on your requirements)
            Map<dynamic, dynamic> postData =
                snapshot.value as Map<dynamic, dynamic>;

            // Get the first postId from the keys and fetch corresponding sellerUid
            String firstPostId = postData.keys.first;
            String firstSellerUid =
                postData[firstPostId]['sellerUid'] ?? 'UnknownSellerUid';

            setState(() {
              postId = firstPostId; // Set the postId dynamically
              sellerUid = firstSellerUid; // Set the sellerUid dynamically
            });
          }
        } as FutureOr Function(DatabaseEvent value));
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String buyerUid = FirebaseAuth.instance.currentUser!.uid;
    final List<Widget> pageList = <Widget>[
      const SellerDashboardHome(),
      SellerChatNavbar(
        buyerUid: buyerUid,
        postId: postId, // Pass the dynamically set postId
        sellerUid: sellerUid, // Pass the dynamically set sellerUid
      ),
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
