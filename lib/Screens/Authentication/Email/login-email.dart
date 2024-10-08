import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rice_application/Screens/Authentication/Email/forgot_emailPassword.dart';
import 'package:rice_application/Screens/Authentication/Email/signup-email.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});
  static const String id = 'login-email screen';

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  String email = "", password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool isValidEmail = false;
  bool _isPasswordValid = false;
  final bool _isLoading = false;
  String? _passwordError;
  String? _emailError;
  String? _userName;
  String? _userEmail;

  final FirebaseAuth _auth =
      FirebaseAuth.instance; //To check current user info.........

  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User Data')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String username = userDoc['Name'] ?? 'N/A';
        String email = userDoc['Email'] ?? 'N/A';

        // Use the retrieved username and email as needed
        print('Username: $username');
        print('Email: $email');
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
        .hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  void _checkPassword(String value) {
    final isValid = _validatePassword(value) == null;
    setState(() {
      _isPasswordValid = isValid;
    });
  }

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

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      // Show the loading dialog when the login starts

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        // Close the loading dialog since login was successful
        Navigator.of(context).pop();

        // Fetch user data from Firestore
        await fetchUserData(userCredential.user!.uid);

        Get.snackbar(
          backgroundColor: Colors.green.withOpacity(0.4),
          "Successfully",
          "Email Login!",
          titleText: const Center(
            child: Text(
              "Successfully",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: -0.4,
                  color: Colors.white,
                  fontFamily: 'Rubik'),
            ),
          ),
          messageText: const SizedBox(
            height: 20,
            child: Center(
              child: Text(
                "Email Login!",
                style: TextStyle(
                  fontSize: 14.3,
                  fontFamily: 'Rubik',
                  letterSpacing: -0.4,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          margin: const EdgeInsets.all(4),
          borderRadius: 10,
        );

        // Navigate to the home screen or other logic
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      // Close the loading dialog since an error occurred
      Navigator.of(context).pop();

      print(
          'FirebaseAuthException: ${e.code}'); // Log the error code for debugging

      if (e.code == 'user-not-found') {
        Get.snackbar(
          "Error",
          "No user found for that email.",
          backgroundColor: Colors.red.withOpacity(0.7),
          titleText: const Center(
            child: Text(
              "Error",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.2,
                  color: Colors.white,
                  fontFamily: 'Rubik'),
            ),
          ),
          messageText: const SizedBox(
            height: 18,
            child: Center(
              child: Text(
                "No user found for that email.",
                style: TextStyle(
                  fontSize: 14.2,
                  fontFamily: 'Rubik',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          margin: const EdgeInsets.all(4),
          borderRadius: 10,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Error",
          "Wrong password provided for that user.",
          backgroundColor: Colors.red.withOpacity(0.7),
          titleText: const Center(
            child: Text(
              "Error",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.2,
                  color: Colors.white,
                  fontFamily: 'Rubik'),
            ),
          ),
          messageText: const SizedBox(
            height: 18,
            child: Center(
              child: Text(
                "Wrong password provided for that user.",
                style: TextStyle(
                  fontSize: 14.2,
                  fontFamily: 'Rubik',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          margin: const EdgeInsets.all(4),
          borderRadius: 10,
        );
      } else {
        print('Unexpected error code: ${e.code}'); // Log unexpected error codes
        Get.snackbar(
          "Error!",
          "Something's failing.",
          backgroundColor: Colors.red.withOpacity(0.7),
          snackPosition: SnackPosition.TOP,
          titleText: const Center(
            child: Text(
              "Error!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: -0.4,
                  color: Colors.white,
                  fontFamily: 'Rubik'),
            ),
          ),
          messageText: const SizedBox(
            height: 18,
            child: Center(
              child: Text(
                "Something's failing.",
                style: TextStyle(
                  fontSize: 14.3,
                  letterSpacing: -0.4,
                  fontFamily: 'Rubik',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          margin: const EdgeInsets.all(4),
          borderRadius: 10,
        );
      }
    } catch (e) {
      // Close the loading dialog since an unexpected error occurred
      Navigator.of(context).pop();

      print('Error during login: $e');
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        backgroundColor: Colors.red.withOpacity(0.7),
        titleText: const Center(
          child: Text(
            "Error",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.2,
                color: Colors.white,
                fontFamily: 'Rubik'),
          ),
        ),
        messageText: const SizedBox(
          height: 18,
          child: Center(
            child: Text(
              "An unexpected error occurred.",
              style: TextStyle(
                fontSize: 14.2,
                fontFamily: 'Rubik',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        margin: const EdgeInsets.all(4),
        borderRadius: 10,
      );
    }
  }

//Alert Loading Dialogue........
  void showAlertDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: Colors.black,
          ),
          SizedBox(width: 33),
          Text(
            "Please wait",
            style: TextStyle(
                fontFamily: 'Inter', fontSize: 15, letterSpacing: -0.4),
          ),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // Automatically close the dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        "Login account",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Email address',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: -0.4,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          color: Color(0XFF000000),
                        ),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        cursorColor: Colors.black54,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          } else if (!(value.endsWith('.com') ||
                              value.endsWith('.pk') ||
                              value.endsWith('.org'))) {
                            return 'Email must end with .com, .pk, or .org';
                          }
                          return null;
                        },
                        controller: emailController,
                        onChanged: _checkEmail,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isValidEmail ? Colors.green : Colors.red,
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
                              color: isValidEmail ? Colors.green : Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Your email',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
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
                      if (_emailError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 25),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: -0.4,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            cursorColor: Colors.black54,
                            controller: passwordController,
                            obscureText: !_isVisible,
                            onChanged: _checkPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              } else if (!RegExp(
                                      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                  .hasMatch(value)) {
                                return 'Password must contain both letters and numbers';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                icon: _isVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _isPasswordValid
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _isPasswordValid
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _isPasswordValid
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Password',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                                letterSpacing: -0.4,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          if (_passwordError != null) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _passwordError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ForegetEmailpassword.id);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                              color: Color.fromARGB(255, 37, 37, 37),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              loginUser(context, emailController.text,
                                  passwordController.text);
                              showAlertDialog(context);
                            }
                          },
                          child: const Text(
                            'Login',
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
                      const SizedBox(height: 55),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 114, 111, 111),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.8),
                              child: Text(
                                'Or',
                                style: TextStyle(
                                  letterSpacing: -0.4,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Color(0XFF000000),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 114, 111, 111),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 135),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account?",
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
                                Navigator.pushNamed(context, SignupEmail.id);
                              },
                              child: const Text(
                                'SignUp',
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
          ),
        ],
      ),
    );
  }
}
