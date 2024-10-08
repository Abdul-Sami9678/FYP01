import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Provider/cart_provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/cart_items.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class PostDetailsScreen extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imagePath;

  const PostDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
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
              child: imagePath.startsWith('http')
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/Profile.jpg',
                      image: imagePath,
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
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              name,
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
                price,
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
              'Rs.$description',
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
                    id: name, // You can use a unique ID here like a product ID
                    name: name, // Product name
                    imagePath: imagePath, // Product image path
                    price: double.parse(
                        description), // Ensure the price is a double
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
                onPressed: () {
                  // Handle chat action here
                },
                child: TouchableOpacity(
                  activeOpacity: 0.2,
                  child: const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 16,
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
