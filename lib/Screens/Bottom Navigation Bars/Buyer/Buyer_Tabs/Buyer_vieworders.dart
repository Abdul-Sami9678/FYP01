import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuyerCartNavbar extends StatefulWidget {
  const BuyerCartNavbar({super.key});

  @override
  State<BuyerCartNavbar> createState() => _BuyerCartNavbarState();
}

class _BuyerCartNavbarState extends State<BuyerCartNavbar> {
  @override
  Widget build(BuildContext context) {
    // This is where you define the content of your Column
    final List<Widget> columnChildren = [
      // Uncomment this line to simulate content in the Column
      // const SafeArea(child: Center(child: Text("This is some content in the chat"))),
    ];

    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Center(
        child: columnChildren.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: columnChildren,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Lottie.asset(
                      'assets/Animations/Check.json',
                      fit: BoxFit.contain, // Adjust fit as needed
                    ),
                  ),
                  const Text(
                    "Check all your orders here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: -0.2,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Keep an eye out to check order!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: -0.1,
                      fontFamily: 'Inter',
                      color: Color.fromARGB(255, 157, 156, 156),
                    ),
                  ),
                ],
              ), // Show animation and text if no content
      ),
    );
  }
}
