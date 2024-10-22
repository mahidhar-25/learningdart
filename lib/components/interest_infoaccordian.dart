import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class InterestInfoAccordion extends StatelessWidget {
  final int? serialNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double principalAmount;
  final double interestAmount;
  final double totalAmount;
  final double interestRate;
  final String totalTime; // e.g., "10 months 12 days"
  final bool? isExpanded;

  const InterestInfoAccordion({
    super.key,
    this.serialNumber,
    required this.startDate,
    required this.endDate,
    required this.principalAmount,
    required this.interestAmount,
    required this.totalAmount,
    required this.interestRate,
    required this.totalTime,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        initiallyExpanded: isExpanded!,
        tilePadding: const EdgeInsets.only(left: 16, right: 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${serialNumber != null ? '$serialNumber. ' : ''}${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 18, 42, 22),
                // fontWeight: FontWeight.bold,
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.expand_more),
            )
          ],
        ),
        trailing:
            const SizedBox.shrink(), // To hide the trailing icon and use custom
        iconColor: Colors.blue,
        collapsedIconColor: Colors.blue,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        childrenPadding: const EdgeInsets.all(16),
        children: [
          buildInfoRow('Principal Amount: ',
              '₹${NumberFormat.decimalPattern().format(principalAmount)}'),
          buildInfoRow('Interest Amount: ',
              '₹${NumberFormat.decimalPattern().format(interestAmount)}'),
          buildInfoRow('Total Amount: ',
              '₹${NumberFormat.decimalPattern().format(totalAmount)}'),
          buildInfoRow('Total Time: ', totalTime),
          buildInfoRow(
              'Interest Rate: ', '${interestRate.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }

  // Helper function to build individual info rows with styling
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
