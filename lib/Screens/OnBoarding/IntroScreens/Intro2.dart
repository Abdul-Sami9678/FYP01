import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Intro_Screen2 extends StatefulWidget {
  const Intro_Screen2({super.key});

  @override
  State<Intro_Screen2> createState() => _Intro_Screen2State();
}

class _Intro_Screen2State extends State<Intro_Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 190,
            ),
            Center(
              child: Lottie.asset(
                "assets/Animations/Trends.json",
                height: 320, // Adjust the height as needed
                width: 320, // Adjust the width as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                height: 80,
                width: 260,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Frame_2.png"))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
