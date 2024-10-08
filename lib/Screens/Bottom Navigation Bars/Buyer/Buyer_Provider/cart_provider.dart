import 'package:flutter/material.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/cart_items.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Add item to the cart
  void addItem(CartItem item) {
    // Check if the item already exists in the cart
    int index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);

    if (index >= 0) {
      // If the item already exists, increase its quantity
      _cartItems[index].quantity += 1;
    } else {
      // If the item is new, add it to the cart
      _cartItems.add(item);
    }
    notifyListeners();
  }

  // Remove an item from the cart
  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Update the quantity of a specific item in the cart
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      // If the quantity is 0 or less, remove the item from the cart
      _cartItems.removeAt(index);
    } else {
      // Otherwise, update the quantity
      _cartItems[index].quantity = newQuantity;
    }
    notifyListeners();
  }

  // Calculate the total price of all items in the cart
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Clear all items in the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
