import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rice_application/Screens/OnBoarding/onboarding.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const On_Boarding_Screen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 403, left: 128),
            child: Text(
              "HARBOR",
              style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 7,
                  fontFamily: 'Quicksand',
                  color: Color.fromARGB(255, 2, 2, 1)),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rice.",
                  style: TextStyle(
                      fontSize: 70,
                      letterSpacing: -0.1,
                      fontFamily: 'League',
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF171810)),
                ),

                SizedBox(height: 44), // Space between text and loader
                CircularProgressIndicator(
                  color: Colors.black, // Set loader color to black
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
