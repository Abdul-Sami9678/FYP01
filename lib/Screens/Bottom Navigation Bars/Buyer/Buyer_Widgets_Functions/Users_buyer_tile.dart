import 'package:flutter/material.dart';

class UsersBuyerTile extends StatelessWidget {
  final String text; // Changed to lowercase
  final void Function()? onTap;

  const UsersBuyerTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.person),
            Text(text), // Using the corrected variable name
          ],
        ),
      ),
    );
  }
}
