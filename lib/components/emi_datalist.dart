import 'package:flutter/material.dart';

class EMIDetailsList extends StatelessWidget {
  final List<Map<String, dynamic>> emiDetailsList;

  @immutable
  const EMIDetailsList({super.key, required this.emiDetailsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emiDetailsList.length,
      itemBuilder: (context, index) {
        final detail = emiDetailsList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light grey background
              borderRadius: BorderRadius.circular(12), // Rounded corners
              border: Border.all(color: Colors.grey[400]!), // Border color
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top line with date
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100], // Light blue background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    detail['date'],
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // EMI information
                Text('EMI Amount: ₹${detail["emiAmount"].toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text(
                    'Interest Paid: ₹${detail["interestPaid"].toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text(
                    'Principal Paid: ₹${detail["principalPaid"].toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
