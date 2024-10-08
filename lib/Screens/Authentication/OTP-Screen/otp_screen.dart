import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:rice_application/Screens/Home-Screen/home_screen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class OTPScreen extends StatefulWidget {
  final String vid;
  final String username;
  final String phoneNumber;

  const OTPScreen({
    super.key,
    required this.vid,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? otpCode;
  bool isLoading = false;

  Future<void> verifyOtpCode(String vid, String otp) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: vid, smsCode: otp);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        await saveUserDataToFirestore(user);
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar("Error", "User sign-in failed.");
      }
    } catch (e) {
      Get.snackbar("Verification Error", "Invalid OTP or verification failed.");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserDataToFirestore(User user) async {
    try {
      final userData = {
        'Email': 'N/A',
        'Name': widget.username,
        'Phone': widget.phoneNumber,
      };

      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
      Get.snackbar(
        backgroundColor: Colors.green.withOpacity(0.4),
        "Successfully",
        "Phone Signup!",
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
              "Phone Signup!",
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

      print('User data successfully saved to Firestore.');
    } catch (e) {
      Get.snackbar("Error", "Failed to save user data to Firestore.");
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.black),
              SizedBox(width: 20),
              Text("Please wait",
                  style: TextStyle(fontFamily: 'Inter', fontSize: 15)),
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
                              image: AssetImage('assets/images/Icons/Back.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    "Enter code",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 33,
                      fontFamily: 'Poppins',
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    "We’ve sent an SMS with an activation code to your phone number.",
                    style: TextStyle(
                      letterSpacing: -0.5,
                      fontFamily: 'Inter',
                      fontSize: 16.5,
                      color: Color.fromARGB(255, 128, 124, 124),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Pinput(
                    showCursor: true,
                    onChanged: (value) => otpCode = value,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 54, 54, 54),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 54, 54, 54),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color.fromARGB(255, 54, 54, 54)),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 54, 54, 54),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color.fromARGB(255, 54, 54, 54)),
                      ),
                    ),
                    cursor: Container(
                      width: 1,
                      height: 26,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 66),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TouchableOpacity(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        showLoadingDialog(context);
                        await verifyOtpCode(widget.vid, otpCode!);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.4,
                              fontFamily: 'Inter',
                              fontSize: 16.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
