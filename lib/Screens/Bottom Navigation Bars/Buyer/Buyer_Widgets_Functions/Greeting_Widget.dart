import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;
    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon,";
    } else if (hour >= 17 && hour < 21) {
      greeting = "Good Evening,";
    } else {
      greeting = "Good Night,";
    }

    return FutureBuilder<Map<String, String?>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading while fetching user info
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error details
        } else if (snapshot.hasData) {
          final userInfo = snapshot.data;
          final username = userInfo?['username'] ?? 'User';
          final profileImageUrl = userInfo?['profileImage'];

          return Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust radius as needed
                child: profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? Image.network(
                        profileImageUrl,
                        width: 47.5, // Adjust width as needed
                        height: 47.5, // Adjust height as needed
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultProfileImage();
                        },
                      )
                    : _buildDefaultProfileImage(),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 67, 67, 67),
                      fontFamily: 'Sans',
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Sans',
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 29, 28, 28),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TouchableOpacity(
                activeOpacity: 0.2,
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/Icons/Notifications.png"),
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return const Text(
              'No user data available'); // Fallback if no data is found
        }
      },
    );
  }

  // Helper method to build the default profile image
  Widget _buildDefaultProfileImage() {
    return Image.asset(
      "assets/images/Profile.jpg",
      width: 47.5,
      height: 47.5,
      fit: BoxFit.cover,
    );
  }

  Future<Map<String, String?>> _getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return {'username': 'Guest', 'profileImage': null};
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.uid)
          .get();

      print(
          'User document: ${userDoc.data()}'); // Debugging: Print fetched document data

      String? username;
      String? profileImage;

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        // Check if fields exist before accessing them
        username = data.containsKey('Name') ? data['Name'] as String : null;
        profileImage = data.containsKey('ProfileImage')
            ? data['ProfileImage'] as String
            : null;

        // Fallbacks if data is not available in Firestore
        username ??= user.displayName ??
            user.phoneNumber ??
            user.email?.split('@')[0] ??
            'User';
        profileImage ??= user.photoURL;
      } else {
        // Fallback to FirebaseAuth display name, phone number, or email if Firestore document doesn't exist.
        username = user.displayName ??
            user.phoneNumber ??
            user.email?.split('@')[0] ??
            'User';
        profileImage = user.photoURL;
      }

      return {'username': username, 'profileImage': profileImage};
    } catch (e) {
      print('Error fetching user info: $e'); // Debugging: Print error details
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}
