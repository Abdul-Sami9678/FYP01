import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class BuyerCameranavbar extends StatefulWidget {
  const BuyerCameranavbar({super.key});

  @override
  State<BuyerCameranavbar> createState() => _BuyerCameranavbarState();
}

class _BuyerCameranavbarState extends State<BuyerCameranavbar> {
  Uint8List? _image;
  File? selectedImage;

  // Image pick from Camera
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }

  // Image pick from Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }

  // Bottom Sheet to Display
  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 248, 246, 246),
      context: context,
      isDismissible: true, // Allows closing by tapping outside or swiping down
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            children: [
              Container(
                height: 5,
                width: 136,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Icons/Bar.png"))),
              ),
              const SizedBox(height: 58),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Gallery Icon
                  InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.pop(
                          context); // Close bottom sheet after picking
                    },
                    child: const ImageIcon(
                      AssetImage(
                          'assets/images/Icons/Gallery.png'), // Gallery Icon
                      size: 50.5,
                    ),
                  ),
                  // Camera Icon
                  InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                      Navigator.pop(
                          context); // Close bottom sheet after picking
                    },
                    child: const ImageIcon(
                      AssetImage(
                          'assets/images/Icons/Camera1.png'), // Camera Icon
                      size: 50.5,
                    ),
                  ),
                ],
              ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation or Selected Image
            _image == null
                ? Lottie.asset(
                    "assets/Animations/S3.json",
                    height: 160, // Adjust the height as needed
                    width: 200, // Adjust the width as needed
                  )
                : Image.memory(
                    _image!), // Display the selected image if available
            const SizedBox(
              height: 7,
            ),
            // Button to Open Bottom Sheet Manually
            ElevatedButton.icon(
              onPressed: () {
                // Handle button action here
                _showBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button background color
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 50), // Padding inside the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17), // Rounded corners
                ),
              ),
              label: const Text(
                'Classify', // Button text
                style: TextStyle(
                  fontSize: 17, // Text size
                  fontFamily: 'Sans',
                  letterSpacing: -0.2,
                  color: Colors.white, // Text color
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
