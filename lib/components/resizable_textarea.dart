import 'package:flutter/material.dart';

class ResizableTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final String labelText; // New parameter for the label

  const ResizableTextField({
    required this.controller,
    required this.hintText,
    required this.focusNode,
    required this.labelText, // Pass the label as a parameter
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ResizableTextFieldState createState() => _ResizableTextFieldState();
}

class _ResizableTextFieldState extends State<ResizableTextField> {
  double _height = 150; // Default height of the text field

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use the parameterized label text here
        Text(
          widget.labelText,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              // Adjust the height dynamically as the user drags
              _height = (_height + details.delta.dy).clamp(100.0, 400.0);
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100, // Minimum height of the text area
                maxHeight: 400, // Maximum height of the text area
              ),
              child: SizedBox(
                height: _height,
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true, // Ensures the text fills the available space
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    contentPadding: const EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
