import 'dart:io';

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
  final VoidCallback onBottomSheetClosed;
  const SellerPostcreatenavbar({super.key, required this.onBottomSheetClosed});

  @override
  State<SellerPostcreatenavbar> createState() => _SellerPostcreatenavbarState();
}

class _SellerPostcreatenavbarState extends State<SellerPostcreatenavbar> {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  Future<void> pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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

  void _showBottomSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                    color: const Color.fromARGB(
                                        255, 230, 229, 229),
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
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.black54,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 167, 170, 167),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
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
                                labelText: 'Enter title',
                                hintText: 'Your title',
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
                            const SizedBox(height: 25),
                            TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
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
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Enter description',
                                hintText: 'Your description',
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
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
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
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Enter price',
                                hintText: 'Your price',
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
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: locationController,
                              keyboardType: TextInputType.text,
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
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Enter location',
                                hintText: 'Your location',
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
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: TextButton(
                                onPressed: () async {
                                  if (_selectedImage == null) {
                                    // Show error message if no image is selected
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
                                    int date =
                                        DateTime.now().microsecondsSinceEpoch;
                                    final fileName = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                    final storageRef = storage
                                        .ref()
                                        .child('post_images/$date/$fileName');

                                    // Upload image
                                    final uploadTask = storageRef
                                        .putFile(File(_selectedImage!.path));
                                    await uploadTask.whenComplete(() => null);
                                    // Get the download URL
                                    final imageUrl =
                                        await storageRef.getDownloadURL();
                                    final User? user = _auth.currentUser;

                                    // Use fallback mechanisms for user information
                                    final String? email = user?.email;
                                    final String? phoneNumber =
                                        user?.phoneNumber;
                                    final String? uid = user?.uid;
                                    final String? displayName =
                                        user?.displayName;
                                    final String userIdentifier = email ??
                                        phoneNumber ??
                                        displayName ??
                                        'Unknown User';

                                    postRef
                                        .child('Post List')
                                        .child(date.toString())
                                        .set({
                                      'pId': date.toString(),
                                      'pImage': imageUrl.toString(),
                                      'pTime': date.toString(),
                                      'pTitle': titleController.text.trim(),
                                      'pDescription':
                                          descriptionController.text.trim(),
                                      'pPrice': priceController.text.trim(),
                                      'pLocation':
                                          locationController.text.trim(),
                                      'uEmail': email ?? 'No Email',
                                      'uPhoneNumber':
                                          phoneNumber ?? 'No Phone Number',
                                      'uDisplayName':
                                          displayName ?? 'No Display Name',
                                      'uId': uid ?? 'No UID',
                                      'userIdentifier': userIdentifier,
                                    }).then((value) {
                                      setState(() {
                                        showSpinner = false;
                                      });

                                      // Show QuickAlert on success
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title: 'Post Published',
                                        text: 'Successfully!',
                                        confirmBtnText: 'Continue',
                                        confirmBtnColor: Colors.black,
                                        onConfirmBtnTap: () {
                                          Navigator.of(context)
                                              .pop(); // Close the QuickAlert
                                          Navigator.of(context)
                                              .pop(); // Close the bottom sheet
                                          Navigator.of(context)
                                              .pushReplacementNamed('/home');
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
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  "Upload",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    letterSpacing: -0.3,
                                    fontFamily: 'Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
      ).whenComplete(() {
        widget.onBottomSheetClosed();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 130, top: 33),
        child: Lottie.asset(
          "assets/Animations/Dot.json",
          height: 155,
          width: 155,
        ),
      ),
    );
  }
}
