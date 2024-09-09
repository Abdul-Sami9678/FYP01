import 'package:flutter/material.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/GetStarted/welcome.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/Intro1.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/Intro2.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/Intro3.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/Intro4.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/Intro5.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

// ignore: camel_case_types
class On_Boarding_Screen extends StatefulWidget {
  const On_Boarding_Screen({super.key});

  @override
  State<On_Boarding_Screen> createState() => _On_Boarding_ScreenState();
}

// ignore: camel_case_types
class _On_Boarding_ScreenState extends State<On_Boarding_Screen> {
  // Controller of Page Indicators........
  final PageController _controller = PageController();

  bool onLastPage = false;
  bool onFirstPage = true;

  // Alert Loading Dialogue........
  void showAlertDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Colors.black,
          ),
          SizedBox(
            width: 33,
          ),
          Text(
            "Please wait",
            style: TextStyle(
                fontFamily: 'Inter', fontSize: 15, letterSpacing: -0.4),
          )
        ],
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed by user
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Dismiss the dialog
          Navigator.pushNamed(
              context, Welcome_Screen.id); // Navigate to the next screen
        });
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4);
                onFirstPage = (index == 0);
              });
            },
            children: const [
              Intro_Screen1(),
              Intro_Screen2(),
              Intro_Screen3(),
              Intro_Screen4(),
              Intro_Screen5(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 165),
            child: Container(
              alignment: const Alignment(0, 0.84),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotColor: Color.fromARGB(255, 228, 226, 226),
                  dotHeight: 12,
                  dotWidth: 12,
                ),
              ),
            ),
          ),
          if (!onLastPage)
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                height: 42,
                width: 78,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    _controller.animateToPage(
                      4,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16.7,
                      letterSpacing: -0.4,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          if (onLastPage)
            GestureDetector(
              onTap: () {
                showAlertDialog(context);
              },
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 703, left: 235),
                  child: Image.asset(
                    'assets/images/Start.png',
                    height: 46,
                    width: 155,
                  ),
                ),
              ),
            )
          else
            TouchableOpacity(
              activeOpacity: 0.3,
              child: GestureDetector(
                onTap: () {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 697, left: 292),
                    child: Image.asset(
                      'assets/images/forward_arrow1.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
