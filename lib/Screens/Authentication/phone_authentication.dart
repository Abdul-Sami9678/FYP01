import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rice_application/Screens/Authentication/OTP-Screen/otp_screen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class Phone_Authentication extends StatefulWidget {
  const Phone_Authentication({super.key});
  static const String id = 'phone-auth-screen';

  @override
  State<Phone_Authentication> createState() => _Phone_AuthenticationState();
}

class _Phone_AuthenticationState extends State<Phone_Authentication> {
  TextEditingController phonenumber = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool validate = false;

  void _checkPhoneNumber(String value) {
    setState(() {
      validate = value.length == 10;
    });
  }

  sendcode() async {
    String username = usernameController.text.trim();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92${phonenumber.text}',
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          Get.snackbar('Error Occurred', e.toString());
        },
        codeSent: (String vid, int? token) {
          Get.to(OTPScreen(
            vid: vid,
            username: username, // Pass username to OTP screen
            phoneNumber: phonenumber.text.trim(),
          ));
        },
        codeAutoRetrievalTimeout: (e) {
          Get.snackbar('Error Occurred', e.toString());
        },
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error Occurred', e.code);
    } catch (e) {
      Get.snackbar('Error Occurred', e.toString());
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: Colors.black),
          SizedBox(width: 33),
          Text(
            "Please wait",
            style: TextStyle(fontFamily: 'Inter', fontSize: 15),
          )
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
    {}
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
                              border:
                                  Border.all(color: const Color(0XFFD8DADC)),
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
                                    image: AssetImage(
                                        'assets/images/Icons/Back.png'),
                                  )),
                                ),
                              ),
                            )),
                        const SizedBox(height: 50),
                        const Text(
                          "Login number",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Please type your phone number',
                          style: TextStyle(
                              letterSpacing: -0.5,
                              fontFamily: ('Inter'),
                              fontSize: 16,
                              color: Color.fromARGB(255, 128, 124, 124)),
                        ),
                        const SizedBox(height: 27),
                        const Divider(
                          thickness: 0.8,
                          color: Color.fromARGB(255, 204, 207, 210),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                autofocus: true,
                                controller: usernameController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 22, bottom: 22),
                                  labelText: 'Username',
                                  hintText: 'Your username',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 169, 163, 163),
                                  ),
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 163, 157, 157),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          validate ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: validate
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255, 217, 220, 222),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                onChanged: _checkPhoneNumber,
                                autofocus: true,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                controller: phonenumber,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 22, bottom: 22),
                                  labelText: 'Number',
                                  hintText: 'Your number',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 169, 163, 163),
                                  ),
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 163, 157, 157),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          validate ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: validate
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255, 217, 220, 222),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 75),
                        AbsorbPointer(
                          absorbing: validate ? false : true,
                          child: ElevatedButton(
                            onPressed: () {
                              showAlertDialog(context);
                              sendcode();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ])))
        ],
      ),
    );
  }
}
