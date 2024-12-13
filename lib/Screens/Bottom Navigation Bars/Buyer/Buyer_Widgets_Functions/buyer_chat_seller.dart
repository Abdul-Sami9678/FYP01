import 'package:flutter/material.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/Users_buyer_tile.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/chat_pagebuyer.dart';
import 'package:rice_application/Services/chat/chat_service.dart';

class BuyerChatSeller extends StatelessWidget {
  BuyerChatSeller({super.key});
  final ChatService _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return UsersBuyerTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatPagebuyer(receiveremail: userData["email"])));
        });
  }
}
