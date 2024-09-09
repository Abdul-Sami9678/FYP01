import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rice_application/Screens/Authentication/Email/login-email.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SignupEmail extends StatefulWidget {
  const SignupEmail({super.key});
//Static-ID of Signup email Screen........
  static const String id = 'signup-email screen';
  @override
  State<SignupEmail> createState() => _SignupEmailState();
}

class _SignupEmailState extends State<SignupEmail> {
  bool _isVisible = false;
  bool isValidUsername = false;
  bool isValidEmail = false;
  bool isChecked = false;
  bool _isPasswordValid = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final positionController = TextEditingController();

//Logics of Passwords field controller for signup.................
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

//Logics of Email field controller for Signup.................

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

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$').hasMatch(value)) {
      return 'Username must contain both uppercase and lowercase letters';
    }
    return null;
  }

  void _checkUsername(String value) {
    final isValid = _validateUsername(value) == null;
    setState(() {
      isValidUsername = isValid;
    });
  }

  //Firebase Defintion instance for email...........
  final FirebaseAuth _auth = FirebaseAuth.instance;
//Strings for username,email,and password...........
  String email = "", password = "", name = "";

  //Signup Email Firebase with Firestore logic............
  Future<void> registration() async {
    if (usernameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('User Data')
              .doc(userCredential.user!.uid)
              .set({
            'Name': usernameController.text,
            'Email': emailController.text,
          });

          Get.snackbar(
            backgroundColor: Colors.green.withOpacity(0.4),
            "Successfully",
            "Email Signup!",
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
                  "Email Signup!",
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

          Navigator.pushNamed(context, Home_Screen.id);
        } else {
          print('User credential is null');
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
            "Error",
            "Weak Password!",
            titleText: const Center(
              child: Text(
                "Error",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.2,
                    color: Colors.black,
                    fontFamily: 'Rubik'),
              ),
            ),
            messageText: const SizedBox(
              height: 18,
              child: Center(
                child: Text(
                  "Weak Password!",
                  style: TextStyle(
                    fontSize: 14.2,
                    fontFamily: 'Rubik',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            margin: const EdgeInsets.all(4),
            borderRadius: 10,
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Oops!",
            "Account already exists!",
            titleText: const Center(
              child: Text(
                "Oops!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.2,
                    color: Colors.black,
                    fontFamily: 'Rubik'),
              ),
            ),
            messageText: const SizedBox(
              height: 18,
              child: Center(
                child: Text(
                  "Account already exists!",
                  style: TextStyle(
                    fontSize: 14.2,
                    fontFamily: 'Rubik',
                    color: Colors.black,
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
        print('An error occurred: $e');
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
  }

//Alert Loading Dialogue........
  showAlertDialog(BuildContext context) {
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
        builder: (BuildContext context) {
          const Duration(seconds: 3);
          return alert;
        });
    {}
  }

// Firestore data store.................
  final CollectionReference myItems = FirebaseFirestore.instance
      .collection("User Data"); // Firestore user database.........

  Future<void> saveUserName(String userId, String username) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'Name': username,
    });
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      "Create account",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        letterSpacing:
                            -1.0, // Adjust this value to reduce the spacing
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Username',
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.w200,
                          fontFamily: ('Inter'),
                          color: Color(0XFF000000)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Enter name";
                      //   }
                      //   return null;
                      // },
                      validator: _validateUsername,
                      controller: usernameController,
                      onChanged: (value) {
                        _checkUsername(value);
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidUsername
                                ? Colors.green
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidUsername ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isValidUsername
                                ? Colors.green
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Your username',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: ('Inter'),
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF000000)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      validator: _validateEmail,
                      controller: emailController,
                      onChanged: (value) {
                        _checkEmail(value);
                      },
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
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: -0.4,
                          fontFamily: ('Inter'),
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF000000)),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      //  validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //   {
                      //     return "Enter Name";
                      //   }
                      //   return null;
                      // },
                      controller: passwordController,
                      obscureText: !_isVisible,
                      onChanged: (value) {
                        _checkPassword(value);
                      },
                      validator: _validatePassword,
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
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isPasswordValid ? Colors.green : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isPasswordValid
                                ? Colors.green
                                : const Color.fromARGB(255, 212, 209, 209),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1, // Scale up the Checkbox if needed
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                            activeColor: Colors.black, // Color when checked
                            checkColor: Colors.white, // Color of the checkmark
                            materialTapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // Shrink tap target
                            side: const BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ), // Border of the checkbox
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Rounded edges for the checkbox
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 3.5), // Space between checkbox and text
                        const Text(
                          'I accept the terms and privacy policy',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                        alignment: Alignment.center,
                        height: 58,
                        width: 342,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 9, 9, 9),
                            borderRadius: BorderRadius.circular(12)),
                        child: TouchableOpacity(
                            activeOpacity: 0.3,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formkey.currentState!.validate() &&
                                    isValidEmail &&
                                    isValidUsername &&
                                    _isPasswordValid) {
                                  showAlertDialog(context);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    registration();
                                    Navigator.pop(
                                        context); // close the loading dialog
                                  });
                                }
                              },
                              child: const Text(
                                'Signup',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ))),
                    const SizedBox(
                      height: 90,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFF000000),
                              fontFamily: ('Inter'),
                              letterSpacing: -0.4),
                        ),
                        const SizedBox(
                          width: 3.5,
                        ),
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
                                fontFamily: ('Inter'),
                                letterSpacing: -0.4,
                                color: Color.fromARGB(255, 37, 37, 37),
                                fontWeight: FontWeight.bold,
                                //decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
