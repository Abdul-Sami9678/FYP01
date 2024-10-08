class CartItem {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  int quantity; // This will be updated by the CartProvider

  CartItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 1, // Default quantity is 1
  });
}
