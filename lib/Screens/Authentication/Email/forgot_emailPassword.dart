import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rice_application/Screens/Authentication/Email/login-email.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class ForegetEmailpassword extends StatefulWidget {
  const ForegetEmailpassword({super.key});

  // Static-ID of Forget email password screen
  static const String id = 'forgot-emailPassword screen';

  @override
  State<ForegetEmailpassword> createState() => _ForegetEmailpasswordState();
}

class _ForegetEmailpasswordState extends State<ForegetEmailpassword> {
  String email = "";
  final emailController = TextEditingController();
  bool isValidEmail = false;
  final _formkey = GlobalKey<FormState>();

  // Email validation logic
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    } else if (!(value.endsWith('.com') ||
        value.endsWith('.pk') ||
        value.endsWith('.org'))) {
      return 'Email must end with .com, .pk, or .org';
    }
    return null;
  }

  void _checkEmail(String value) {
    final isValid = _validateEmail(value) == null;
    setState(() {
      isValidEmail = isValid;
    });
  }

  // Reset password logic
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        backgroundColor: Colors.green.withOpacity(0.4),
        "Successfully reset",
        "Check your email!",
        titleText: const Center(
          child: Text(
            "Successfully reset",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: -0.4,
                color: Colors.white,
                fontFamily: 'Rubik'),
          ),
        ),
        messageText: const SizedBox(
          height: 20, // Reduce height
          child: Center(
            child: Text(
              "Check your email!",
              style: TextStyle(
                fontSize: 14.3,
                // fontWeight: FontWeight.bold,
                fontFamily: 'Rubik',
                letterSpacing: -0.4,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Center text alignment
            ),
          ),
        ),
        margin: const EdgeInsets.all(4),
        borderRadius: 10,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.snackbar(
          "Sorry!",
          "No user found",
          titleText: const Center(
            child: Text(
              "Sorry!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.2,
                  color: Colors.black,
                  fontFamily: 'Rubik'),
            ),
          ),
          messageText: const SizedBox(
            height: 18, // Reduce height
            child: Center(
              child: Text(
                "No user found",
                style: TextStyle(
                  fontSize: 14.2,
                  fontFamily: 'Rubik',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center, // Center text alignment
              ),
            ),
          ),
          margin: const EdgeInsets.all(4),
          borderRadius: 10,
        );
      }
    }
  }

  // Show loading dialog
  void showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.black),
              SizedBox(width: 20),
              Text(
                'Please wait...',
                style: TextStyle(fontFamily: 'Inter', fontSize: 15),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Container(
                      alignment: Alignment.center,
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: const Color(0XFFD8DADC)),
                      ),
                      child: TouchableOpacity(
                        activeOpacity: 0.3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Icons/Back.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Reset password",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        letterSpacing:
                            -1.0, // Adjust this value to reduce the spacing
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Please type your registered email',
                      style: TextStyle(
                        letterSpacing: -0.5,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color.fromARGB(255, 128, 124, 124),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w200,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        }
                        return null;
                      },
                      controller: emailController,
                      onChanged: _checkEmail,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidEmail
                                ? Colors.green
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidEmail ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidEmail
                                ? Colors.green
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Your email',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                          letterSpacing: -0.4,
                          fontFamily: 'Inter',
                        ),
                        suffixIcon: Icon(
                          isValidEmail ? Icons.check_circle : Icons.error,
                          color: isValidEmail ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      alignment: Alignment.center,
                      height: 58,
                      width: 342,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 9, 9, 9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TouchableOpacity(
                        activeOpacity: 0.3,
                        child: GestureDetector(
                          onTap: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                              });

                              // Show the AlertDialog
                              showAlertDialog(context);

                              // Wait for 2 seconds before dismissing the dialog
                              await Future.delayed(const Duration(seconds: 2));

                              // Dismiss the AlertDialog
                              Navigator.of(context, rootNavigator: true).pop();

                              // Call resetPassword() after the dialog is dismissed
                              await resetPassword();
                            }
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.4,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 290),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Remember password?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0XFF000000),
                            fontFamily: 'Inter',
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 3.5),
                        TouchableOpacity(
                          activeOpacity: 0.3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, EmailLogin.id);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                letterSpacing: -0.4,
                                color: Color.fromARGB(255, 37, 37, 37),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
