import 'package:flutter/material.dart';

class SellerDashboardHome extends StatefulWidget {
  const SellerDashboardHome({super.key});

  @override
  State<SellerDashboardHome> createState() => _SellerDashboardHomeState();
}

class _SellerDashboardHomeState extends State<SellerDashboardHome> {
  bool _hasRefreshed = false;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _hasRefreshed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.black, // Spinner color
        backgroundColor:
            Colors.white, // Background color of the refresh indicator
        child: ListView(
          children: const [
            SizedBox(height: 300), // Add some space to make the list scrollable
            Center(child: Text("Home")),
          ],
        ),
      ),
    );
  }
}
