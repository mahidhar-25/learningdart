import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:learningdart/components/logger_component.dart';

class SimpleInterestCalculatorPage extends StatefulWidget {
  const SimpleInterestCalculatorPage({super.key});

  @override
  State<SimpleInterestCalculatorPage> createState() =>
      _SimpleInterestCalculatorPageState();
}

class _SimpleInterestCalculatorPageState
    extends State<SimpleInterestCalculatorPage> {
  late final TextEditingController _amount;
  late final TextEditingController _interestRate;

  @override
  void initState() {
    _amount = TextEditingController();
    _interestRate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    super.dispose();
  }
// Controllers for the amount and interest rate

  // Variables for the start and end dates
  DateTime? _startDate;
  DateTime? _endDate;

  // Method to show a date picker
  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2101), // Latest selectable date
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Interest Calculator')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Custom text fields for amount and interest rate
              CustomTextField(
                labelText: 'Amount',
                controller: _amount,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                labelText: 'Interest Rate',
                controller: _interestRate,
                keyboardType: TextInputType.number,
              ),
              // Start date field
              GestureDetector(
                onTap: () => _selectDate(context, isStartDate: true),
                child: AbsorbPointer(
                  child: CustomTextField(
                    labelText: 'Start Date',
                    controller: TextEditingController(
                        text: _startDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(_startDate!)),
                    keyboardType: TextInputType.none, // Disable keyboard
                  ),
                ),
              ), // Space between fields
              // End date field
              GestureDetector(
                onTap: () => _selectDate(context, isStartDate: false),
                child: AbsorbPointer(
                  child: CustomTextField(
                    labelText: 'End Date',
                    controller: TextEditingController(
                        text: _endDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(_endDate!)),
                    keyboardType: TextInputType.none, // Disable keyboard
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space for button
              ElevatedButton(
                onPressed: () {
                  final simpleInterest = calculateSimpleInterest(
                      double.parse(_amount.text),
                      double.parse(_interestRate.text),
                      _startDate!,
                      _endDate!);
                  logger.i(
                      'Principal Amount: ${simpleInterest['principalAmount']},\n '
                      'Interest Rate: ${simpleInterest['interestRate']},\n '
                      'Interest Amount: ${simpleInterest['interestAmount']},\n '
                      'Total Amount: ${simpleInterest['totalAmount']}, \n'
                      'Time Difference: ${simpleInterest['timeDifference']['totalYears']} years, ${simpleInterest['timeDifference']['totalMonths']} months, ${simpleInterest['timeDifference']['totalDays']} days');
                },
                child: const Text('Calculate Simple Interest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, dynamic> calculateSimpleInterest(
    double amount, double interestRate, DateTime startDate, DateTime endDate) {
  // Calculate the time difference in days
  final timeDifference = calculateDateDifference(startDate, endDate);
  // Calculate the simple interest
  final simpleInterest =
      amount * interestRate * timeDifference['totalYears'] / 100;
  return {
    'principalAmount': amount,
    'interestRate': interestRate,
    'totalAmount': amount + simpleInterest,
    'interestAmount': simpleInterest,
    'timeDifference': timeDifference
  };
}

/// Function to calculate the difference between two dates
Map<String, dynamic> calculateDateDifference(
    DateTime startDate, DateTime endDate) {
  // Ensure the endDate is not before startDate
  if (endDate.isBefore(startDate)) {
    throw ArgumentError("End date cannot be before start date");
  }

  // Calculate total difference in days
  final totalDays = endDate.difference(startDate).inDays;
  // Total time in years (including fractional months) with 3 decimal places
  final totalYears = double.parse((totalDays / 365).toStringAsFixed(3));
  final totalMonths = double.parse((totalDays / 30).toStringAsFixed(3));

  // Calculate the year difference
  int years = endDate.year - startDate.year;

  // Calculate the month difference
  int months = endDate.month - startDate.month;

  // Adjust the year and month if necessary (i.e., if months are negative)
  if (months < 0) {
    years -= 1;
    months += 12;
  }

  // Calculate the day difference
  int days = endDate.day - startDate.day;

  // Adjust the month and day if necessary (i.e., if days are negative)
  if (days < 0) {
    final prevMonth = DateTime(endDate.year, endDate.month - 1);
    days += DateTime(prevMonth.year, prevMonth.month + 1, 0)
        .day; // Last day of the previous month
    months -= 1;

    if (months < 0) {
      months += 12;
      years -= 1;
    }
  }

  return {
    'totalDays': totalDays,
    'totalMonths': totalMonths,
    'totalYears': totalYears,
    'years': years,
    'months': months,
    'days': days,
  };
}
