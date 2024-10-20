import 'package:flutter/material.dart';
import 'package:learningdart/components/simple_interest.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            // Circle with logo
            CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/MoneyMaster.png"), // Add your logo image path here
              radius: 20, // Adjust size of the logo
            ),
            SizedBox(width: 10), // Add space between logo and title
            Text(
              'Money Master',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(Colors.blue.shade300.value),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Add functionality for menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3, // Two columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            // Simple Interest Calculator Box
            _buildElevatedBox(
              context,
              'assets/simpleInterest.jpeg', // Replace with a logo/icon for simple interest
              'S.I Calculator',
              () {
                // Navigation to Simple Interest Calculator
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SimpleInterestCalculatorPage()),
                );
              },
            ),
            // Compound Interest Calculator Box
            _buildElevatedBox(
              context,
              'assets/compoundInterest.jpeg', // Replace with a logo/icon for compound interest
              'C.I Calculator',
              () {
                // Navigation to Compound Interest Calculator
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CompoundInterestCalculatorPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each elevated box
  Widget _buildElevatedBox(BuildContext context, String imagePath, String label,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 70), // Logo/icon image
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Simple Interest Calculator Page

// Placeholder for Compound Interest Calculator Page
class CompoundInterestCalculatorPage extends StatelessWidget {
  const CompoundInterestCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compound Interest Calculator')),
      body: const Center(
          child: Text('Compound Interest Calculator Functionality')),
    );
  }
}
