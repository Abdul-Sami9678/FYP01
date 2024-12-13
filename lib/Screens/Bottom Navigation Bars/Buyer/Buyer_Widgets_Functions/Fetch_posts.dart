import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Provider/cart_provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/cart_items.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailsScreen extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final String imagePath;
  final String postId;
  final String sellerUid;

  const PostDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.postId, // Add postId
    required this.sellerUid, // Add sellerUid
  });

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool isLoading = false; // Track the loading state
  void launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber'; // WhatsApp link
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current buyer UID from FirebaseAuth
    final buyerUid = FirebaseAuth.instance.currentUser?.uid;
    // If buyerUid is null, handle the error (should not happen if user is logged in)
    if (buyerUid == null) {
      // Show an error message and return
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('User not authenticated! Please log in.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Arrow Icon
                IconButton(
                  icon: Image.asset(
                    'assets/images/Icons/Back.png', // Your image path
                    width: 22,
                    height: 22,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Details',
                  style: TextStyle(
                    color: Color.fromARGB(255, 27, 27, 27),
                    fontSize: 24,
                    fontFamily: 'Sans',
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/Icons/Notifications.png',
                    width: 28,
                    height: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: widget.imagePath.startsWith('http')
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/Profile.jpg',
                      image: widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/error_image.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                        );
                      },
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              widget.name,
              style: const TextStyle(
                letterSpacing: -0.3,
                fontWeight: FontWeight.bold,
                fontSize: 22.5,
              ),
            ),
            const SizedBox(height: 1),
            // Star Rating and Reviews
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star_half, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Text(
                  '4.0/5 (45 reviews)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.price,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Price Section
            const Text(
              'Price',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.5,
                letterSpacing: -0.2,
                color: Color.fromARGB(255, 162, 161, 161),
              ),
            ),
            Text(
              'Rs.${widget.description}',
              style: const TextStyle(
                fontSize: 21,
                letterSpacing: -0.3,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
            ),
            const SizedBox(height: 25),

            // Add to Cart Button (Primary Button)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // Create a CartItem with all necessary fields
                  final cartItem = CartItem(
                    id: widget
                        .name, // You can use a unique ID here like a product ID
                    name: widget.name, // Product name
                    imagePath: widget.imagePath, // Product image path
                    price: double.parse(
                        widget.description), // Ensure the price is a double
                  );

                  // Add the item to the cart using CartProvider
                  Provider.of<CartProvider>(context, listen: false)
                      .addItem(cartItem);

                  // Show a snackbar to notify the user
                  Get.snackbar(
                    backgroundColor: Colors.green.withOpacity(0.4),
                    "Successfully",
                    "Added to Cart!",
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
                      height: 20,
                      child: Center(
                        child: Text(
                          "Added to Cart!",
                          style: TextStyle(
                            fontSize: 14.3,
                            fontFamily: 'Rubik',
                            letterSpacing: -0.4,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(4),
                    borderRadius: 10,
                  );
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Chat Button (Secondary Button)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true; // Show the loading indicator
                  });

                  // Wait for 2 seconds
                  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    isLoading = false; // Hide the loading indicator
                  });

                  // Navigate to the chat screen after the delay
                  const sellerPhoneNumber =
                      '+923478780096'; // Replace with actual seller's phone number
                  launchWhatsApp(sellerPhoneNumber);
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : TouchableOpacity(
                        activeOpacity: 0.2,
                        child: const Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: -0.3,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
