import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import for star ratings
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:lottie/lottie.dart';

class SellerCartNavbar extends StatefulWidget {
  const SellerCartNavbar({super.key});

  @override
  State<SellerCartNavbar> createState() => _SellerCartNavbarState();
}

class _SellerCartNavbarState extends State<SellerCartNavbar> {
  final DatabaseReference _feedbackRef =
      FirebaseDatabase.instance.ref().child('Feedbacks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 22,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 130,
                    ),
                    Text(
                      'Feedbacks',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontFamily: 'Sans',
                        letterSpacing: -0.1,
                        fontSize: 24.2, // Font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    ImageIcon(
                        AssetImage('assets/images/Icons/Notifications.png'))
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _feedbackRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.data!.snapshot.value != null) {
                        Map<dynamic, dynamic> feedbacks = snapshot
                            .data!.snapshot.value as Map<dynamic, dynamic>;

                        return ListView.builder(
                          itemCount: feedbacks.length,
                          itemBuilder: (context, index) {
                            String key = feedbacks.keys.elementAt(index);
                            Map feedback = feedbacks[key];

                            // Parse the timestamp to show only the hour and minute
                            DateTime timestamp = DateTime.parse(
                                feedback['timestamp'] ??
                                    DateTime.now().toString());
                            String formattedTime =
                                DateFormat.Hm().format(timestamp);

                            return Card(
                              color: const Color(0XFFFFFFFF),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                title: Text(
                                  feedback['feedback'] ?? 'No Feedback',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display rating as stars
                                    RatingBarIndicator(
                                      rating:
                                          feedback['rating']?.toDouble() ?? 0.0,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(height: 4),
                                    // Display time in HH:mm format
                                    Text(
                                      "Submitted at: $formattedTime",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteFeedback(key),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: Lottie.asset(
                                'assets/Animations/Check.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Text(
                              "Check all feedbacks here",
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
                              "Keep an eye out to see feedbacks!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: -0.1,
                                fontFamily: 'Inter',
                                color: Color.fromARGB(255, 157, 156, 156),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to delete feedback
  void _deleteFeedback(String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0XFFFFFFFF), // White background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Rounded corners
          ),
          title: const Text(
            'Delete Feedback',
            style: TextStyle(
              fontSize: 22, // Title font size
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold, // Bold font weight for the title
              color: Colors.black, // Black color for the title
              letterSpacing: -0.2, // Letter spacing for title
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this feedback?',
            style: TextStyle(
              fontSize: 16, // Content font size
              color: Colors.grey, // Grey color for content
              letterSpacing: -0.2,
              fontFamily: 'Sans',
              fontWeight: FontWeight.normal, // Normal font weight for content
              height: 1.5, // Line height for better readability
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16, // Font size for Cancel button
                  letterSpacing: -0.2,
                  fontFamily: 'Sans',
                  color: Colors.black, // Black text color for Cancel button
                  fontWeight: FontWeight.w500, // Medium weight for button text
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _feedbackRef.child(key).remove();
                Get.snackbar(
                  "Feedback Deleted",
                  "Feedback has been deleted!",
                  backgroundColor: Colors.red.withOpacity(0.4),
                  colorText: Colors.white,
                  snackPosition:
                      SnackPosition.TOP, // Position it at the TOP (optional)
                  margin: const EdgeInsets.all(10), // Add some margin if needed
                  titleText: const Text(
                    "Feedback Deleted",
                    textAlign: TextAlign.center, // Center the title text
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Sans',
                        letterSpacing: -0.1),
                  ),
                  messageText: const Text(
                    "Feedback has been deleted!",
                    textAlign: TextAlign.center, // Center the message text
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sans',
                        letterSpacing: -0.1),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16, // Font size for Delete button
                  letterSpacing: -0.2,
                  fontFamily: 'Sans',
                  color: Colors.red, // Red color for Delete button
                  fontWeight: FontWeight.bold, // Bold text for Delete button
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
