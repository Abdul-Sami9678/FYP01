import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();
  XFile? _image;
  String? _imageUrl;

  XFile? get image => _image;
  String? get imageUrl => _imageUrl;

  // Pick Gallery image
  Future<void> pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
    }
  }

  // Pick Camera image
  Future<void> pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
    }
  }

  void pickImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0XFFFFFFFF),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const ImageIcon(
                    AssetImage('assets/images/Icons/Camera1.png'),
                    size: 20,
                  ),
                  title: const Text("Camera",
                      style:
                          TextStyle(fontFamily: 'Inter', letterSpacing: -0.1)),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const ImageIcon(
                    AssetImage('assets/images/Icons/Gallery.png'),
                    size: 20,
                  ),
                  title: const Text("Gallery",
                      style:
                          TextStyle(letterSpacing: -0.1, fontFamily: 'Inter')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Upload image section....................
  Future<void> uploadImage(BuildContext context) async {
    if (_image == null) return;

    try {
      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Create a unique file name and reference
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          storage.ref().child('profile_images/$userId/$fileName');

      // Upload image
      final uploadTask = storageRef.putFile(File(_image!.path));
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      final imageUrl = await storageRef.getDownloadURL();

      // Update Firestore with the image URL
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(userId)
          .update({'ProfileImage': imageUrl});

      _imageUrl = imageUrl;
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Load image from Firebase................
  Future<void> loadProfileImage() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Get the profile image URL from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('User Data')
          .doc(userId)
          .get();
      _imageUrl = snapshot.data()?['ProfileImage'] as String?;

      notifyListeners();
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }
}
