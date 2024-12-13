import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuyerChatNavbar extends StatefulWidget {
  const BuyerChatNavbar({
    super.key,
    required this.postId,
    required this.sellerUid,
    required this.buyerUid,
  });

  static const String id = 'Buyer-Chat-screen';

  final String postId;
  final String sellerUid;
  final String buyerUid;

  @override
  State<BuyerChatNavbar> createState() => _BuyerChatNavbarState();
}

class _BuyerChatNavbarState extends State<BuyerChatNavbar> {
  final TextEditingController _messageController = TextEditingController();
  bool _isChatInitialized = false;

  // Initialize chat if it doesn't exist
  Future<void> _initChat() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.postId)
        .get();

    if (!chatDoc.exists) {
      // Create a new chat if it doesn't exist
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.postId)
          .set({
        'postId': widget.postId,
        'buyerUid': widget.buyerUid,
        'sellerUid': widget.sellerUid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      _isChatInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  // Send message
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        var timestamp = FieldValue.serverTimestamp();

        // Add message to Firestore
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.postId)
            .collection('messages')
            .add({
          'senderId': widget.buyerUid,
          'message': _messageController.text,
          'timestamp': timestamp,
        });

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
                    // Display messages from the seller and buyer
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.postId)
                            .collection('messages')
                            .orderBy('timestamp')
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
                                child: Text('No messages yet!'));
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
                                          horizontal: 14.0, vertical: 7.0),
                                      decoration: BoxDecoration(
                                        color: isBuyerMessage
                                            ? const Color.fromARGB(
                                                255, 36, 36, 36)
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
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            messageText,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: isBuyerMessage
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
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

                    // Input field to send message
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                hintText: 'Enter a message...',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14.0)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 36, 36, 36),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Keep an eye out for notifications!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
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
