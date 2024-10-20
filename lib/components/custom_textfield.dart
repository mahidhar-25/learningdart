import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // Constructor to accept parameters
  const CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.obscureText = false,
      this.hintText,
      this.enableSuggestions = true,
      this.autocorrect = true});

  // Parameters to make the widget reusable
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final bool? enableSuggestions;
  final bool? autocorrect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20, // equal margins on both sides
            vertical: 10, // small margin on top and bottom
          ), // You can modify width as needed or pass as argument
          child: TextField(
            enableSuggestions: enableSuggestions!, // Enable auto-suggestions
            autocorrect: autocorrect!, // Enable auto-correct
            controller: controller,
            obscureText: obscureText, // Useful for password fields
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText, // Label for the TextField
              hintText: hintText, // Optional hint text
            ),
          ),
        ));
  }
}
