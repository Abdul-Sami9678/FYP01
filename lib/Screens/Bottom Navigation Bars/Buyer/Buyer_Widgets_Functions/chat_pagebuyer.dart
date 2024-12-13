import 'package:flutter/material.dart';

class ChatPagebuyer extends StatelessWidget {
  final String receiveremail;
  const ChatPagebuyer({super.key, required this.receiveremail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      appBar: AppBar(
        title: Text(receiveremail),
      ),
    );
  }
}
