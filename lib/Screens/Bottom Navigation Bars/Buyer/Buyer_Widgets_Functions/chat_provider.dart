import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool _isChatInitialized = false;
  bool get isChatInitialized => _isChatInitialized;

  /// Initialize the chat by checking if it already exists
  Future<void> initializeChat(
      String postId, String buyerUid, String sellerUid) async {
    if (postId.isEmpty || buyerUid.isEmpty || sellerUid.isEmpty) {
      debugPrint('Post ID, Buyer UID, or Seller UID is empty.');
      return;
    }

    try {
      final chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(postId)
          .get();

      if (!chatDoc.exists) {
        // If the chat doesn't exist, create it
        await FirebaseFirestore.instance.collection('chats').doc(postId).set({
          'postId': postId,
          'buyerUid': buyerUid,
          'sellerUid': sellerUid,
          'messages': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Chat created for postId: $postId');
      } else {
        debugPrint('Chat already exists for postId: $postId');
      }

      _isChatInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing chat: $e');
    }
  }

  /// Fetch chat messages from Firestore
  Stream<QuerySnapshot> fetchMessages(String postId) {
    if (postId.isEmpty) {
      debugPrint('Post ID is empty. Returning empty stream.');
      return const Stream.empty();
    }

    // Fetch messages ordered by timestamp (descending)
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(postId)
        .collection('messages')
        .orderBy('timestamp',
            descending: true) // Change to descending for latest messages first
        .snapshots();
  }

  /// Send a message to Firestore
  Future<void> sendMessage(
      String postId, String message, String senderUid) async {
    if (postId.isEmpty || message.isEmpty || senderUid.isEmpty) {
      debugPrint('Post ID, message, or sender UID is empty. Message not sent.');
      return;
    }

    try {
      var timestamp = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(postId)
          .collection('messages')
          .add({
        'senderId': senderUid,
        'message': message,
        'timestamp': timestamp,
      });

      // Optionally update the last message or message count in the 'chats' document
      await FirebaseFirestore.instance.collection('chats').doc(postId).update({
        'lastMessage': message,
        'lastMessageTimestamp': timestamp,
        'messageCount': FieldValue.increment(1),
      });

      debugPrint('Message sent for postId: $postId');
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
}
