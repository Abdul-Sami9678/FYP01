import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<void> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User user = userCredential.user!;

        // Save user data to Firestore
        await _saveUserDataToFirestore(user);

        Get.snackbar(
          backgroundColor: Colors.green.withOpacity(0.4),
          "Successfully",
          "Google Login!",
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
            height: 20, // Reduce height
            child: Center(
              child: Text(
                "Google Login!",
                style: TextStyle(
                  fontSize: 14.3,
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
      }
    } catch (e) {
      Get.snackbar(
        "Sign Up Failed",
        "An error occurred while signing up with Google: $e",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: 10,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveUserDataToFirestore(User user) async {
    try {
      final userData = {
        'Email': user.email,
        'Name': user.displayName ?? 'N/A',
        'Phone': user.phoneNumber ?? 'N/A', // Update if needed
      };

      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .set(userData,
              SetOptions(merge: true)); // Merge with existing data if any

      print('User data successfully saved to Firestore.');
    } catch (e) {
      print('Error saving user data: $e');
      Get.snackbar("Error", "Failed to save user data to Firestore.");
    }
  }
}
