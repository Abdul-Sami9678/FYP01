import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SearchBarBuyer extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarBuyer({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  _SearchBarBuyerState createState() => _SearchBarBuyerState();
}

class _SearchBarBuyerState extends State<SearchBarBuyer> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 80, // Increased height of the TextField
        width: 330, // Width of the TextField
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          focusNode: _focusNode,
          cursorColor: const Color.fromARGB(
              255, 60, 60, 60), // Set cursor color to light grey
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(
              fontSize: 17.5,
              fontFamily: 'Sans',
              color: Color.fromARGB(
                  255, 52, 52, 52), // Set hint text color to dark grey
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(16.0), // Adjust padding as needed
              child: SizedBox(
                width: 22, // Set desired width for the icon
                height: 22, // Set desired height for the icon
                child: TouchableOpacity(
                  activeOpacity: 0.2,
                  child: Image.asset(
                    'assets/images/Icons/Search.png', // Replace with your image path
                    fit: BoxFit
                        .contain, // Ensure the image fits within the SizedBox
                  ),
                ),
              ),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 244, 245, 248),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Circular border radius
              borderSide: BorderSide.none, // Remove border line
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Circular border radius
              borderSide: BorderSide.none, // Remove border line
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15.0), // Circular border radius
              borderSide: BorderSide.none, // Remove border line
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Adjust padding inside the TextField
          ),
          style: const TextStyle(
            fontFamily: 'Sans', // Replace with your font family
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
