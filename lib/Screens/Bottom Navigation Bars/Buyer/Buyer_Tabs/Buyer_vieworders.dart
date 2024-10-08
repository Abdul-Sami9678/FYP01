import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Provider/cart_provider.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets/buyer_address.dart';

class BuyerCartNavbar extends StatefulWidget {
  const BuyerCartNavbar({super.key});

  @override
  State<BuyerCartNavbar> createState() => _BuyerCartNavbarState();
}

class _BuyerCartNavbarState extends State<BuyerCartNavbar> {
//Circle indicator.............
  bool _isLoading = false;

  void _onProceed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, BuyerAddress.id);
    });
  }

  Map<String, dynamic>? paymentIntent; // Store the payment intent

  // @override
  // void initState() {
  //   super.initState();
  //   Stripe.publishableKey =
  //       "pk_test_51Q72aWGr9UhAIQLONS2w69MXRfQ6WPt8y71eznEVaBAZqMI7HF3l44ZXk3qvbY6TzVVrLYen4XC0dhwlICL1XUym0066Kj7Ay7"; // Add your Stripe publishable key here
  // }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate subtotal
    double subTotal = 0;
    for (var item in cartProvider.cartItems) {
      subTotal += item.price * item.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black,
              letterSpacing: -0.3,
              fontFamily: 'Sans',
              fontSize: 22.5,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0XFFFFFFFF),
      body: SafeArea(
        child: cartProvider.cartItems.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 10),
                      itemCount: cartProvider.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartProvider.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: material.Card(
                            color: const Color(0XFFFFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: cartItem.imagePath.startsWith('http')
                                        ? Image.network(
                                            cartItem.imagePath,
                                            width: 67,
                                            height: 67,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.error,
                                                  color: Colors.red);
                                            },
                                          )
                                        : Image.asset(
                                            cartItem.imagePath,
                                            width: 68,
                                            height: 68,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.error,
                                                  color: Colors.red);
                                            },
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cartItem.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          'Rs.${cartItem.price}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (cartItem.quantity > 1) {
                                                cartProvider.updateQuantity(
                                                    index,
                                                    cartItem.quantity - 1);
                                              }
                                            },
                                          ),
                                          Text(
                                            cartItem.quantity.toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              cartProvider.updateQuantity(
                                                  index, cartItem.quantity + 1);
                                            },
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 55),
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            cartProvider.removeItem(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Cart Summary and Payment Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 50),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, -2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow('Sub-total', subTotal),
                        _buildSummaryRow('Shipping fee', 300),
                        const Divider(),
                        _buildSummaryRow('Total', subTotal + 300,
                            isTotal: true),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onProceed,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 22, horizontal: 5),
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 17, 17),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _isLoading
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                            strokeWidth: 2.5,
                                          )
                                        : const Text(
                                            'Proceed',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    if (!_isLoading)
                                      Container(
                                        height: 23,
                                        width: 23,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Icons/forward.png"),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Center(
                      child: Lottie.asset(
                        'assets/Animations/Check.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Check all your orders here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: -0.2,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Center(
                    child: Text(
                      "Keep an eye out to check order!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: -0.1,
                        fontFamily: 'Inter',
                        color: Color.fromARGB(255, 157, 156, 156),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Widget for building summary rows (subtotal, shipping fee, etc.)
  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18.5 : 16.5,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          Text(
            'Rs.${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18.5 : 16.5,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
