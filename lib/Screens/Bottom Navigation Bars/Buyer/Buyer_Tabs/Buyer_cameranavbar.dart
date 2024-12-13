import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; // For image processing
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:lottie/lottie.dart';

class BuyerCameranavbar extends StatefulWidget {
  const BuyerCameranavbar({super.key});

  @override
  State<BuyerCameranavbar> createState() => _BuyerCameranavbarState();
}

class _BuyerCameranavbarState extends State<BuyerCameranavbar> {
  Uint8List? _image;
  File? selectedImage;
  List<dynamic>? _output;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/new_rice_classifier_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  // Convert image to grayscale
  Future<File?> convertToGrayscale(File image) async {
    try {
      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        print("Error: Could not decode image");
        return null;
      }

      // Convert the image to grayscale
      final grayImage = img.grayscale(decodedImage);

      // Save the grayscale image temporarily
      final tempDir = Directory.systemTemp;
      final grayscaleImagePath = '${tempDir.path}/grayscale_image.png';
      final grayscaleFile = File(grayscaleImagePath);

      await grayscaleFile.writeAsBytes(img.encodePng(grayImage));
      print("Grayscale image saved at: $grayscaleImagePath");
      return grayscaleFile;
    } catch (e) {
      print("Error during grayscale conversion: $e");
      return null;
    }
  }

  // Classify the selected image
  Future<void> classifyImage(File image) async {
    if (image == null) return;

    // Run the TFLite model
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;

      // Check if output is valid
      if (output != null && output.isNotEmpty) {
        final topPrediction = output[0];
        final confidence = topPrediction['confidence'];
        final label = topPrediction['label'];

        if (confidence > 0.5) {
          _output = output; // Show valid prediction
        } else {
          _output = [
            {'label': 'Invalid image: Unable to predict rice type'}
          ]; // Invalid prediction
        }
      } else {
        _output = [
          {'label': 'Invalid image: Unable to predict rice type'}
        ];
      }
    });
  }

  // Image pick from Camera with Grayscale Conversion
  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;

    setState(() {
      _loading = true;
      selectedImage = File(returnImage.path);
    });

    // Convert image to grayscale
    final grayscaleImage = await convertToGrayscale(selectedImage!);

    if (grayscaleImage != null) {
      final grayscaleBytes =
          await grayscaleImage.readAsBytes(); // Read bytes outside setState
      setState(() {
        _image = grayscaleBytes; // Update state
      });

      // Classify the grayscale image
      classifyImage(grayscaleImage);
    } else {
      setState(() {
        _loading = false;
        _output = [
          {'label': 'Error: Unable to process the image'}
        ];
      });
    }
  }

  // Image pick from Gallery (Optional: Can add grayscale conversion if needed)
  Future<void> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    setState(() {
      _loading = true;
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });

    // Classify the selected image
    classifyImage(selectedImage!);
  }

  // Bottom Sheet to Display
  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 248, 246, 246),
      context: context,
      isDismissible: true,
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
                    image: AssetImage("assets/images/Icons/Bar.png"),
                  ),
                ),
              ),
              const SizedBox(height: 58),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Gallery Icon
                  InkWell(
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.pop(context); // Close bottom sheet
                    },
                    child: const ImageIcon(
                      AssetImage('assets/images/Icons/Gallery.png'),
                      size: 50.5,
                    ),
                  ),
                  // Camera Icon
                  InkWell(
                    onTap: () {
                      _pickImageFromCamera();
                      Navigator.pop(context); // Close bottom sheet
                    },
                    child: const ImageIcon(
                      AssetImage('assets/images/Icons/Camera1.png'),
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
            // Display loading animation or the selected image
            _loading
                ? Lottie.asset(
                    "assets/Animations/Loading4.json",
                    height: 135,
                    width: 135,
                  )
                : _image != null
                    ? Column(
                        children: [
                          Image.memory(
                            _image!,
                            width: 300,
                            height: 300,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Prediction:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _output != null
                                ? '${_output![0]['label']}'
                                : 'No Prediction',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : Lottie.asset(
                        "assets/Animations/S3.json",
                        height: 160,
                        width: 200,
                      ),
            const SizedBox(height: 7),
            // Button to open bottom sheet
            ElevatedButton.icon(
              onPressed: () {
                _showBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              icon: const Icon(Icons.camera),
              label: const Text(
                'Classify',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: -0.2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
