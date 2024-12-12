import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuyerChatnavbar extends StatefulWidget {
  const BuyerChatnavbar({
    super.key,
    required this.postId,
    required this.sellerUid,
    required this.buyerUid,
  });

  // Static-ID of Chat Screen
  static const String id = 'Chat-screen';

  final String postId;
  final String sellerUid;
  final String buyerUid;

  @override
  State<BuyerChatnavbar> createState() => _BuyerChatnavbarState();
}

class _BuyerChatnavbarState extends State<BuyerChatnavbar> {
  final TextEditingController _messageController = TextEditingController();
  bool _isChatInitialized = false; // Flag to track if chat is initialized

  // Initialize chat room if it doesn't exist
  Future<void> _initChat() async {
    // Check if the chat room already exists
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.postId) // Use postId as the unique ID for the chat
        .get();

    if (!chatDoc.exists) {
      // If it doesn't exist, create a new chat document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.postId)
          .set({
        'postId': widget.postId,
        'buyerUid': widget.buyerUid,
        'sellerUid': widget.sellerUid,
        'messages': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Update the state to show chat content
    setState(() {
      _isChatInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initChat(); // Initialize chat when the screen loads
  }

  // Send message to the chat room
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        var timestamp = FieldValue.serverTimestamp();

        // Add message to Firestore as a new document in the 'messages' subcollection
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.postId)
            .collection('messages') // Subcollection for messages
            .add({
          'senderId': widget.buyerUid,
          'message': _messageController.text,
          'timestamp': timestamp, // Use timestamp here
        });

        // Clear the message controller
        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Center(
        child: _isChatInitialized
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Chat section where we display messages
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.postId)
                            .collection('messages')
                            .orderBy('timestamp') // Order by timestamp
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text(
                              'No messages yet!',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: 'Poppins',
                                  letterSpacing: -0.2),
                            ));
                          }

                          final messages = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final senderId = message['senderId'];
                              final messageText = message['message'];
                              final timestamp = message['timestamp'];

                              bool isBuyerMessage = senderId == widget.buyerUid;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: isBuyerMessage
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0,
                                        vertical: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isBuyerMessage
                                            ? const Color.fromARGB(
                                                255, 14, 14, 14)
                                            : Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isBuyerMessage
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isBuyerMessage ? 'Buyer' : 'Seller',
                                            style: TextStyle(
                                              color: isBuyerMessage
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // White for Buyer, Black for Seller
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            messageText,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: isBuyerMessage
                                                  ? Colors
                                                      .white // White font color for buyer's message
                                                  : Colors
                                                      .black, // Default black font for seller's message
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          // Removed timestamp as per previous request
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Send message input section
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                cursorColor:
                                    Colors.black, // Set cursor color to black
                                decoration: const InputDecoration(
                                  hintText: 'Enter a message...',
                                  hintStyle: TextStyle(
                                      fontFamily: 'Roboto-Regular',
                                      letterSpacing: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0)), // Round corners
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            18.0)), // Rounded focus border
                                    borderSide: BorderSide(
                                        color: Colors
                                            .black), // Border color on focus
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            17.0)), // Rounded enabled border
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Border color when not focused
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    8), // Add space between the TextField and IconButton
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black, // Button background color
                                borderRadius: BorderRadius.circular(
                                    30.0), // Make the button rounded
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors
                                      .white, // Set the icon color to white
                                ),
                                onPressed: _sendMessage,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Show Lottie animation and text only if chat is not initialized yet
                  Flexible(
                    child: Lottie.asset(
                      'assets/Animations/Chat.json',
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Check all your chats here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: -0.2,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Keep an eye out for notifications!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: -0.1,
                      fontFamily: 'Inter',
                      color: Color.fromARGB(255, 157, 156, 156),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
