import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rice_application/Screens/Authentication/Email/login-email.dart';
import 'package:rice_application/Screens/Authentication/Google/google_auth.dart';
import 'package:rice_application/Screens/Authentication/phone_authentication.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({super.key});

//Static-ID of Welcome Screen........
  static const String id = 'login-screen';
  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  //Alert Loading Dialogue........
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
            style: TextStyle(fontFamily: 'Inter', fontSize: 15),
          )
        ],
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed by user
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//for phone authentication............
  bool _isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Lottie Animation............
                Lottie.asset(
                  "assets/Animations/Welcome1.json",
                ),
                const SizedBox(
                  height: 33,
                ),
                const Center(
                  child: Text(
                    "Explore the app",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      letterSpacing:
                          -1.0, // Adjust this value to reduce the spacing
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                const Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Now you're in the right place",
                      style: TextStyle(
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color.fromARGB(255, 128, 124, 124),
                      ),
                      children: [
                        TextSpan(
                          text: '\n      Discover the features',
                          style: TextStyle(
                            letterSpacing: -0.5,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color.fromARGB(255, 128, 124, 124),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                //Continue with Google.....................
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 214, 216, 220), // Set border color to grey
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 26,
                        ),
                        Image.asset(
                          'assets/images/Icons/G.png',
                          height: 22,
                          width: 22,
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        Center(
                          child: TouchableOpacity(
                            activeOpacity: 0.3,
                            child: GestureDetector(
                              onTap: () async {
                                showAlertDialog(context);

                                await Future.delayed(const Duration(
                                    seconds: 2)); // Wait for 2 seconds

                                await FirebaseServices().signUpWithGoogle();

                                Navigator.pop(
                                    context); // Dismiss the alert dialog
                                Navigator.pushNamed(
                                    context,
                                    Home_Screen
                                        .id); // Navigate to the next screen
                              },
                              child: const Text(
                                'Continue With Google',
                                style: TextStyle(
                                  fontSize: 15.8,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                //Continue with Phone.....................
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 214, 216, 220), // Set border color to grey
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 26,
                        ),
                        Image.asset(
                          'assets/images/Icons/P2.png',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        Center(
                          child: TouchableOpacity(
                            activeOpacity: 0.3,
                            child: GestureDetector(
                              onTap: () async {
                                if (_isFirstTime) {
                                  showAlertDialog(context);

                                  await Future.delayed(const Duration(
                                      seconds: 2)); // Wait for 2 seconds

                                  Navigator.pop(
                                      context); // Dismiss the alert dialog

                                  setState(() {
                                    _isFirstTime =
                                        false; // Ensure the dialog is not shown again when returning to this screen
                                  });
                                }
                                Navigator.pushNamed(
                                    context,
                                    Phone_Authentication
                                        .id); // Navigate to the next screen
                              },
                              child: const Text(
                                'Continue With Phone',
                                style: TextStyle(
                                  fontSize: 15.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                //Continue with Email.....................
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 214, 216, 220), // Set border color to grey
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 26,
                        ),
                        Image.asset(
                          'assets/images/Icons/Mail.png',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        Center(
                          child: TouchableOpacity(
                            activeOpacity: 0.3,
                            child: GestureDetector(
                              onTap: () async {
                                if (!_isFirstTime) {
                                  showAlertDialog(context);

                                  await Future.delayed(const Duration(
                                      seconds: 2)); // Wait for 2 seconds

                                  Navigator.of(context)
                                      .pop(); // Dismiss the alert dialog

                                  setState(() {
                                    _isFirstTime =
                                        true; // Update the flag to prevent dialog from showing again
                                  });
                                }
                                Navigator.pushNamed(
                                    context,
                                    EmailLogin
                                        .id); // Navigate to the next screen
                              },
                              child: const Text(
                                'Continue With Email',
                                style: TextStyle(
                                  fontSize: 15.8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 9, 9, 9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TouchableOpacity(
                      activeOpacity: 0.3,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context,
                              EmailLogin.id); // Navigate to the next screen
                        },
                        child: const Text(
                          'Check Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.4,
                            fontFamily: ('Inter'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
