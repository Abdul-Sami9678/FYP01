import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class BuyerCameranavbar extends StatefulWidget {
  final VoidCallback onBottomSheetClosed;

  const BuyerCameranavbar({super.key, required this.onBottomSheetClosed});

  @override
  State<BuyerCameranavbar> createState() => _BuyerCameranavbarState();
}

class _BuyerCameranavbarState extends State<BuyerCameranavbar> {
  Uint8List? _image;
  File? selectedImage;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

//Image pick from Gallery................
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }

//Image pick from Gallery................
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }

//Bottom Sheet to Display................
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
              const SizedBox(
                height: 58,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Gallery Icon
                  InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: const ImageIcon(
                      AssetImage(
                          'assets/images/Icons/Gallery.png'), // Gallery Icon........
                      size: 50.5,
                    ),
                  ),

                  // Camera Icon..........
                  InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const ImageIcon(
                      AssetImage(
                          'assets/images/Icons/Camera1.png'), // Camera Icon..........
                      size: 50.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      widget
          .onBottomSheetClosed(); // Navigate to home tab after bottom sheet closes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Center(
        child: Lottie.asset(
          "assets/Animations/Loading4.json",
          height: 135, // Adjust the height as needed
          width: 135, // Adjust the width as needed
        ),
      ),
    );
  }
}
