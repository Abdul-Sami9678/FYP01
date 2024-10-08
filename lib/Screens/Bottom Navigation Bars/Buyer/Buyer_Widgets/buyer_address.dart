import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Provider/cart_provider.dart';
import 'package:rice_application/Services/Stripe/payment_service.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class BuyerAddress extends StatefulWidget {
  const BuyerAddress({super.key});

  // Static-ID of Buyer Address
  static const String id = 'Buyer-Address';

  @override
  State<BuyerAddress> createState() => _BuyerAddressState();
}

class _BuyerAddressState extends State<BuyerAddress> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for each input field
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  TouchableOpacity(
                    activeOpacity: 0.2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Icons/Back.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 79),
                  const Text(
                    'New Address',
                    style: TextStyle(
                      letterSpacing: -0.3,
                      fontSize: 24,
                      fontFamily: 'Sans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 44),
              // Full Name Field
              buildTextFormField(
                controller: _fullNameController,
                labelText: 'Your Name',
                validatorText: 'Please enter your full name',
              ),
              const SizedBox(height: 24),
              // City Field
              buildTextFormField(
                controller: _cityController,
                labelText: 'Your City',
                validatorText: 'Please enter your city',
              ),
              const SizedBox(height: 24),
              // Address Field
              buildTextFormField(
                controller: _addressController,
                labelText: 'Your Address',
                validatorText: 'Please enter your address',
              ),
              const SizedBox(height: 24),
              // Postal Code Field
              buildTextFormField(
                controller: _postalCodeController,
                labelText: 'Postal Code',
                validatorText: 'Please enter your postal code',
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              // State Field
              buildTextFormField(
                controller: _stateController,
                labelText: 'Your State',
                validatorText: 'Please enter your state name',
              ),
              const SizedBox(height: 24),
              // Contact Number Field
              buildTextFormField(
                controller: _contactNumberController,
                labelText: 'Contact Number',
                validatorText: 'Please enter your contact number',
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 40),
              // Submit and Payment Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus(); // Hide the keyboard

                    // Attempt to make the payment
                    try {
                      await StripeService.instance.makePayment();
                      cartProvider.clearCart();
                      _showThankYouDialog(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment failed: $e')),
                      );
                    }

                    Get.snackbar(
                      "Address",
                      "Saved Successfully!",
                      backgroundColor: Colors.green.withOpacity(0.4),
                      titleText: const Center(
                        child: Text(
                          "Address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: -0.4,
                            color: Colors.white,
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ),
                      messageText: const Center(
                        child: Text(
                          "Saved Successfully!",
                          style: TextStyle(
                            fontSize: 14.3,
                            fontFamily: 'Rubik',
                            letterSpacing: -0.4,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 15),
                  backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.5,
                        fontFamily: 'Sans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/Icons/card.png"))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text form fields
  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String validatorText,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 16,
          letterSpacing: -0.1,
          color: Color.fromARGB(255, 93, 92, 92),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 212, 209, 209),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 212, 209, 209),
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      keyboardType: inputType,
    );
  }

  // Function to clear all form fields
  void _clearAddressForm() {
    _formKey.currentState?.reset(); // Resets form state
    _fullNameController.clear();
    _cityController.clear();
    _addressController.clear();
    _postalCodeController.clear();
    _contactNumberController.clear();
    _stateController.clear();
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0XFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Thank You!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
                fontFamily: 'Sans',
                fontSize: 25,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your payment was successful. We appreciate your purchase!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sans',
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showFeedbackBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Leave Feedback',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Sans',
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackBottomSheet(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    double rating = 0;

    showModalBottomSheet(
      backgroundColor: const Color(0XFFFFFFFF),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Set height to 70% of the screen
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  20, // Adjust for keyboard
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Leave Your Feedback',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (newRating) {
                        rating = newRating;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.grey,
                    controller: feedbackController,
                    decoration: InputDecoration(
                      labelText: 'Your Review',
                      labelStyle: const TextStyle(
                        fontFamily: 'Sans',
                        letterSpacing: -0.2,
                        color: Color.fromARGB(255, 93, 92, 92),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 212, 209, 209), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey, // Grey color when focused
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (rating > 0 && feedbackController.text.isNotEmpty) {
                        await _saveFeedbackToFirebase(
                            feedbackController.text, rating);

                        // Show success message
                        Get.snackbar(
                          "Feedback",
                          "Submitted Successfully!",
                          backgroundColor: Colors.green.withOpacity(0.4),
                          titleText: const Center(
                            child: Text(
                              "Feedback",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: -0.4,
                                color: Colors.white,
                                fontFamily: 'Rubik',
                              ),
                            ),
                          ),
                          messageText: const Center(
                            child: Text(
                              "Submitted Successfully!",
                              style: TextStyle(
                                fontSize: 14.3,
                                fontFamily: 'Rubik',
                                letterSpacing: -0.4,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );

                        // Clear address form after feedback submission
                        _clearAddressForm();

                        // Close the feedback modal and return to the main screen
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please provide both a rating and a review.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit Feedback',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontFamily: 'Sans',
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveFeedbackToFirebase(
      String feedbackText, double rating) async {
    try {
      final DatabaseReference feedbackRef =
          FirebaseDatabase.instance.ref().child('Feedbacks');
      await feedbackRef.push().set({
        'feedback': feedbackText,
        'rating': rating,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print("Feedback saved successfully!");
    } catch (error) {
      print("Error saving feedback: $error");
    }
  }
}
