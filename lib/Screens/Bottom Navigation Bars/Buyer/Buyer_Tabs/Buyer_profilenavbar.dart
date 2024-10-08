import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Seller/sellerHomescreen.dart';
import 'package:rice_application/Screens/OnBoarding/IntroScreens/GetStarted/welcome.dart';
import 'package:rice_application/Screens/Profile-Controller/profile_controller.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class BuyerProfilenavbar extends StatefulWidget {
  const BuyerProfilenavbar({super.key});

  @override
  State<BuyerProfilenavbar> createState() => _BuyerProfilenavbarState();
}

class _BuyerProfilenavbarState extends State<BuyerProfilenavbar> {
  String displayName = 'Loading...';
  String email = 'Loading...';
  String phoneNumber = 'N/A';
  String providerId = '';

  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = ProfileController();
    _loadUserData();
    _loadProfileImage();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        providerId =
            user.providerData.isNotEmpty ? user.providerData[0].providerId : '';
      });

      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('User Data')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            displayName = userDoc.data()?['Name'] ?? 'N/A';
            email = userDoc.data()?['Email'] ?? 'N/A';
            phoneNumber = userDoc.data()?['Phone'] ?? 'N/A';
          });
        } else {
          print('User document does not exist.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No authenticated user found.');
    }
  }

  Future<void> _loadProfileImage() async {
    await _profileController.loadProfileImage();
    setState(() {});
  }

  //Show Alert Dialogue function....................
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
          return alert;
        });
  }

//Exit Function to close the app......................
  void _showExitConfirmation(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0XFFFFFFFF),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0), // Change the radius value here
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 175, // Adjust the height as needed
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Do you really want to close the app?',
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Close the app
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.black, // Button background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>.value(
      value: _profileController,
      child: Consumer<ProfileController>(
        builder: (context, provider, child) {
          return Scaffold(
              backgroundColor: const Color(0XFFFFFFFF),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TouchableOpacity(
                                activeOpacity: 0.3,
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/Icons/Back1.png'),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Color.fromARGB(255, 154, 153, 153)),
                              ),
                              TouchableOpacity(
                                activeOpacity: 0.2,
                                child: GestureDetector(
                                  onTap: () {
                                    _showExitConfirmation(context);
                                  },
                                  child: Container(
                                    height: 21.8,
                                    width: 21.8,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Icons/Power.png"))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: SizedBox(
                              height: 108,
                              width: 108,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: provider.imageUrl != null
                                        ? NetworkImage(provider.imageUrl!)
                                        : provider.image != null
                                            ? FileImage(
                                                File(provider.image!.path))
                                            : const AssetImage(
                                                    "assets/images/Profile.jpg")
                                                as ImageProvider,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 66,
                                    child: SizedBox(
                                      height: 42,
                                      width: 42,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: const Color.fromARGB(
                                                  255, 250, 248, 248)
                                              .withOpacity(1),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () async {
                                          try {
                                            // Pick image
                                            provider.pickImage(context);

                                            // Check if an image was picked
                                            if (provider.image != null) {
                                              // Upload image
                                              await provider
                                                  .uploadImage(context);

                                              // Refresh the profile image
                                              _loadProfileImage();

                                              // Close the dialog
                                              Navigator.pop(context);
                                            }
                                          } catch (e) {
                                            // Handle any errors here
                                            print('Error: $e');
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/Icons/V.svg",
                                          width: 18,
                                          height: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Display user data based on providerId
                          if (providerId == 'password') ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Text(displayName,
                                  style: const TextStyle(
                                      fontSize: 18.2,
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: -0.001,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF000000))),
                            ),
                            Center(
                              child: Text(email,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: -0.2,
                                      color: Color.fromRGBO(158, 158, 158, 1))),
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 58,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 33, 32, 32),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    showAlertDialog(context);

                                    // Wait for 2 seconds
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    // Close the alert dialog
                                    Navigator.pop(context);

                                    // Switch to the seller dashboard
                                    Navigator.pushNamed(
                                        context, Sellerhomescreen.id);
                                  },
                                  child: const Text(
                                    "Farmer mode",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 38),
                            // TextButton for MyOrders..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Order.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "My Orders",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Notifications..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Notif.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Notifications",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

// TextButton for Helpcenter..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Help.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Helpcenter",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Privacy and Security..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Security.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Privicy Policy",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),

                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Logout..........
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 249, 247, 247),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: const Color(0XFFFFFFFF),
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(27)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 305,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 136,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Icons/Bar.png"))),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            "Logout",
                                            style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 20,
                                                letterSpacing: -0.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Divider(
                                              thickness: 0.4,
                                              color: Color.fromARGB(
                                                  255, 114, 111, 111),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          const Text(
                                            "Are you sure you want to log out?",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                letterSpacing: -0.2,
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 103, 103, 103)),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .black, // Background color for Cancel
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Inter',
                                                    letterSpacing: -0.2,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color
                                                      .fromARGB(255, 235, 60,
                                                      47), // Background color for Logout
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  showAlertDialog(context);

                                                  // Delay for 2 seconds
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));

                                                  // Close the loading dialog
                                                  Navigator.pop(context);
                                                  // Navigate to the next screen

                                                  try {
                                                    await GoogleSignIn()
                                                        .signOut();
                                                    await FirebaseAuth.instance
                                                        .signOut();

                                                    if (mounted) {
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      Get.snackbar(
                                                        "Logout!",
                                                        "Successfully",
                                                        backgroundColor: Colors
                                                            .red
                                                            .withOpacity(0.4),
                                                        titleText: const Center(
                                                          child: Text(
                                                            "Logout!",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  -0.4,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Rubik',
                                                            ),
                                                          ),
                                                        ),
                                                        messageText:
                                                            const SizedBox(
                                                          height: 20,
                                                          child: Center(
                                                            child: Text(
                                                              "Successfully",
                                                              style: TextStyle(
                                                                fontSize: 14.2,
                                                                fontFamily:
                                                                    'Rubik',
                                                                letterSpacing:
                                                                    -0.4,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        borderRadius: 10,
                                                      );

                                                      Get.offAll(() =>
                                                          const Welcome_Screen());
                                                    }
                                                  } catch (e) {
                                                    Get.snackbar("Logout",
                                                        "Logout Error!");
                                                  } finally {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  }
                                                  // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: -0.2,
                                                    fontFamily: 'Inter',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Icons/Logout.svg",
                                    width: 22,
                                  ),
                                  const SizedBox(width: 20),
                                  const Expanded(
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        letterSpacing: 0.4,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ],
                              ),
                            )
                          ] else if (providerId == 'phone') ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Text(displayName,
                                  style: const TextStyle(
                                      fontSize: 18.2,
                                      fontFamily: 'Poppins',
                                      letterSpacing: -0.001,
                                      color: Color(0XFF000000))),
                            ),
                            Center(
                              child: Text(phoneNumber,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: -0.2,
                                      color: Color.fromRGBO(158, 158, 158, 1))),
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 58,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 33, 32, 32),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    showAlertDialog(context);

                                    // Wait for 2 seconds
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    // Close the alert dialog
                                    Navigator.pop(context);

                                    // Switch to the seller dashboard
                                    Navigator.pushNamed(
                                        context, Sellerhomescreen.id);
                                  },
                                  child: const Text(
                                    'Seller mode',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 38),
                            // TextButton for MyOrders..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Order.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "My Orders",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Notifications..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Notif.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Notifications",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

// TextButton for Helpcenter..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Help.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Helpcenter",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Privacy and Security..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Security.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Privicy Policy",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),

                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Logout..........
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 249, 247, 247),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: const Color(0XFFFFFFFF),
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(27)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 305,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 136,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Icons/Bar.png"))),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            "Logout",
                                            style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 20,
                                                letterSpacing: -0.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Divider(
                                              thickness: 0.4,
                                              color: Color.fromARGB(
                                                  255, 114, 111, 111),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          const Text(
                                            "Are you sure you want to log out?",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                letterSpacing: -0.2,
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 103, 103, 103)),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .black, // Background color for Cancel
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Inter',
                                                    letterSpacing: -0.2,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color
                                                      .fromARGB(255, 235, 60,
                                                      47), // Background color for Logout
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  showAlertDialog(context);

                                                  // Delay for 2 seconds
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));

                                                  // Close the loading dialog
                                                  Navigator.pop(context);
                                                  // Navigate to the next screen

                                                  try {
                                                    await GoogleSignIn()
                                                        .signOut();
                                                    await FirebaseAuth.instance
                                                        .signOut();

                                                    if (mounted) {
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      Get.snackbar(
                                                        "Logout!",
                                                        "Successfully",
                                                        backgroundColor: Colors
                                                            .red
                                                            .withOpacity(0.4),
                                                        titleText: const Center(
                                                          child: Text(
                                                            "Logout!",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  -0.4,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Rubik',
                                                            ),
                                                          ),
                                                        ),
                                                        messageText:
                                                            const SizedBox(
                                                          height: 20,
                                                          child: Center(
                                                            child: Text(
                                                              "Successfully",
                                                              style: TextStyle(
                                                                fontSize: 14.2,
                                                                fontFamily:
                                                                    'Rubik',
                                                                letterSpacing:
                                                                    -0.4,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        borderRadius: 10,
                                                      );

                                                      Get.offAll(() =>
                                                          const Welcome_Screen());
                                                    }
                                                  } catch (e) {
                                                    Get.snackbar("Logout",
                                                        "Logout Error!");
                                                  } finally {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  }
                                                  // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: -0.2,
                                                    fontFamily: 'Inter',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Icons/Logout.svg",
                                    width: 22,
                                  ),
                                  const SizedBox(width: 20),
                                  const Expanded(
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        letterSpacing: 0.4,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ],
                              ),
                            )
                          ] else if (providerId == 'google.com') ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Text(displayName,
                                  style: const TextStyle(
                                      fontSize: 18.2,
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: -0.001,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF000000))),
                            ),
                            Center(
                              child: Text(email,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: -0.2,
                                      color: Color.fromRGBO(158, 158, 158, 1))),
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 58,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 33, 32, 32),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    showAlertDialog(context);

                                    // Wait for 2 seconds
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    // Close the alert dialog
                                    Navigator.pop(context);

                                    // Switch to the seller dashboard
                                    Navigator.pushNamed(
                                        context, Sellerhomescreen.id);
                                  },
                                  child: const Text(
                                    'Seller mode',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 38),
                            // TextButton for MyOrders..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Order.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "My Orders",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Notifications..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Notif.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Notifications",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

// TextButton for Helpcenter..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Help.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Helpcenter",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Privacy and Security..........
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 249, 247, 247)
                                    // Padding
                                    ),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Icons/Security.svg",
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Privicy Policy",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.4,
                                          fontSize: 14
                                          //fontWeight: FontWeight.w600
                                          ),
                                    )),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                  ],
                                )),

                            const SizedBox(
                              height: 20,
                            ),

                            // TextButton for Logout..........
                            TextButton(
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 249, 247, 247),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: const Color(0XFFFFFFFF),
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(27)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 305,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 136,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Icons/Bar.png"))),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Text(
                                            "Logout",
                                            style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 20,
                                                letterSpacing: -0.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Divider(
                                              thickness: 0.4,
                                              color: Color.fromARGB(
                                                  255, 114, 111, 111),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          const Text(
                                            "Are you sure you want to log out?",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                letterSpacing: -0.2,
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 103, 103, 103)),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .black, // Background color for Cancel
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Inter',
                                                    letterSpacing: -0.2,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color
                                                      .fromARGB(255, 235, 60,
                                                      47), // Background color for Logout
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  showAlertDialog(context);

                                                  // Delay for 2 seconds
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));

                                                  // Close the loading dialog
                                                  Navigator.pop(context);
                                                  // Navigate to the next screen

                                                  try {
                                                    await GoogleSignIn()
                                                        .signOut();
                                                    await FirebaseAuth.instance
                                                        .signOut();

                                                    if (mounted) {
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }

                                                      Get.snackbar(
                                                        "Logout!",
                                                        "Successfully",
                                                        backgroundColor: Colors
                                                            .red
                                                            .withOpacity(0.4),
                                                        titleText: const Center(
                                                          child: Text(
                                                            "Logout!",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  -0.4,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Rubik',
                                                            ),
                                                          ),
                                                        ),
                                                        messageText:
                                                            const SizedBox(
                                                          height: 20,
                                                          child: Center(
                                                            child: Text(
                                                              "Successfully",
                                                              style: TextStyle(
                                                                fontSize: 14.2,
                                                                fontFamily:
                                                                    'Rubik',
                                                                letterSpacing:
                                                                    -0.4,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(4),
                                                        borderRadius: 10,
                                                      );

                                                      Get.offAll(() =>
                                                          const Welcome_Screen());
                                                    }
                                                  } catch (e) {
                                                    Get.snackbar("Logout",
                                                        "Logout Error!");
                                                  } finally {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  }
                                                  // Close the bottom sheet
                                                },
                                                child: const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: -0.2,
                                                    fontFamily: 'Inter',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Icons/Logout.svg",
                                    width: 22,
                                  ),
                                  const SizedBox(width: 20),
                                  const Expanded(
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        letterSpacing: 0.4,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
