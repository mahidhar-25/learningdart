import 'package:flutter/material.dart';
import 'package:learningdart/components/khatabook/createnewuser_page.dart';

class KhatabookPage extends StatefulWidget {
  const KhatabookPage({super.key});

  @override
  State<KhatabookPage> createState() => _KhatabookPageState();
}

class _KhatabookPageState extends State<KhatabookPage> {
  // Action to perform when the card is clicked
  void _onCardTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatenewuserPage()),
    );
    // You can navigate to another page or perform other actions here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khatabook'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20), // Equal padding on left and right
        child: Card(
          elevation: 5, // Adds shadow to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: InkWell(
            onTap: _onCardTap, // Makes the card clickable
            child: const Padding(
              padding: EdgeInsets.all(15), // Small padding inside the card
              child: Row(
                mainAxisSize:
                    MainAxisSize.max, // Ensures the row takes the full width
                mainAxisAlignment:
                    MainAxisAlignment.start, // Aligns children at the start
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 30,
                    color: Colors.black,
                  ), // Icon for visual representation
                  SizedBox(
                      width: 20), // Adds space between the icon and the text
                  Text(
                    'Create a New User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
