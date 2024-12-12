import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quickalert/quickalert.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SellerPostcreatenavbar extends StatefulWidget {
  const SellerPostcreatenavbar({super.key});

  @override
  State<SellerPostcreatenavbar> createState() => _SellerPostcreatenavbarState();
}

class _SellerPostcreatenavbarState extends State<SellerPostcreatenavbar> {
  Uint8List? _image;
  String folderName = "Post_images";
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _selectedImage;
  final picker = ImagePicker();

  // Text Controllers for creating posts
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // Method to pick image from gallery
  Future<void> pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Method to pick image from camera
  Future<void> pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Dialog for choosing image from camera or gallery
  void dialog(BuildContext context) {
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
                    pickCameraImage(context).then((_) {
                      Navigator.pop(context);
                    });
                  },
                  leading: const ImageIcon(
                    AssetImage('assets/images/Icons/Camera1.png'),
                    size: 20,
                  ),
                  title: const Text(
                    "Camera",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context).then((_) {
                      Navigator.pop(context);
                    });
                  },
                  leading: const ImageIcon(
                    AssetImage('assets/images/Icons/Gallery.png'),
                    size: 20,
                  ),
                  title: const Text(
                    "Gallery",
                    style: TextStyle(
                      letterSpacing: -0.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to show bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 248, 246, 246),
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * 1,
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 230, 229, 229),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: TouchableOpacity(
                                    activeOpacity: 0.2,
                                    child: InkWell(
                                      onTap: () {
                                        dialog(context);
                                      },
                                      child: const ImageIcon(
                                        AssetImage(
                                            "assets/images/Icons/Camera.png"),
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Form(
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: titleController,
                            labelText: 'Enter title',
                            hintText: 'Your title',
                          ),
                          const SizedBox(height: 25),
                          _buildTextField(
                            controller: descriptionController,
                            labelText: 'Enter description',
                            hintText: 'Your description',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 25),
                          _buildTextField(
                            controller: priceController,
                            labelText: 'Enter price',
                            hintText: 'Your price',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 25),
                          _buildTextField(
                            controller: locationController,
                            labelText: 'Enter location',
                            hintText: 'Your location',
                          ),
                          const SizedBox(height: 30),
                          _buildUploadButton(), // Upload button created separately
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Button to upload post
  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_selectedImage == null) {
            // Show error if no image selected
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'No Image Selected',
              text: 'Please select an image to upload.',
              confirmBtnText: 'Okay',
              confirmBtnColor: Colors.red,
            );
            return;
          }

          setState(() {
            showSpinner = true;
          });

          try {
            int date = DateTime.now().microsecondsSinceEpoch;
            final fileName = DateTime.now().millisecondsSinceEpoch.toString();

            final storageRef =
                storage.ref().child('post_images/$date/$fileName');

            // Upload image
            final uploadTask = storageRef.putFile(File(_selectedImage!.path));
            await uploadTask.whenComplete(() => null);

            // Get download URL
            final imageUrl = await storageRef.getDownloadURL();
            final User? user = _auth.currentUser;

            // Upload post to Firebase Database
            postRef.child('Post List').child(date.toString()).set({
              'pId': date.toString(),
              'pImage': imageUrl.toString(),
              'pTime': date.toString(),
              'pTitle': titleController.text.trim(),
              'pDescription': descriptionController.text.trim(),
              'pPrice': priceController.text.trim(),
              'pLocation': locationController.text.trim(),
              'uEmail': user?.email ?? 'No Email',
              'uPhoneNumber': user?.phoneNumber ?? 'No Phone Number',
              'uDisplayName': user?.displayName ?? 'No Display Name',
              'sellerUid': user?.uid ?? 'No UID',
            }).then((value) {
              setState(() {
                showSpinner = false;
              });

              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Post Published',
                text: 'Successfully!',
                confirmBtnText: 'Continue',
                confirmBtnColor: Colors.black,
                onConfirmBtnTap: () {
                  Navigator.of(context).pop(); // Close alert
                  Navigator.of(context).pop(); // Close bottom sheet
                },
              );
            }).onError((error, stackTrace) {
              print('Error uploading the post: $error');
              setState(() {
                showSpinner = false;
              });
            });
          } catch (e) {
            setState(() {
              showSpinner = false;
            });
            print('Error uploading the post: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Button background color
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17), // Rounded corners
          ),
        ),
        label: const Text(
          'Upload',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Reusable TextField widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      cursorColor: Colors.black54,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 167, 170, 167),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 221, 225, 221),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 180, 182, 180),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: labelText,
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          letterSpacing: -0.4,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lottie Animation or Selected Image
            _image == null
                ? Center(
                    child: Lottie.asset(
                      "assets/Animations/S2.json",
                      height: 280, // Adjust the height as needed
                      width: 280, // Adjust the width as needed
                    ),
                  )
                : Image.memory(
                    _image!), // Display the selected image if available
            // Button to create new post (Open the Bottom Sheet)
            Center(
              child: ElevatedButton.icon(
                onPressed:
                    _showBottomSheet, // Show bottom sheet when button is pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // Rounded corners
                  ),
                ),
                label: const Text(
                  'Create Post', // Button text
                  style: TextStyle(
                    fontSize: 16.2,
                    letterSpacing: -0.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
