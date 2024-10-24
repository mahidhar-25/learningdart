import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:learningdart/components/interest_infoaccordian.dart';
import 'package:learningdart/components/piechart_widget.dart';

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
  late final FocusNode _amountFocus;
  late final FocusNode _interestRateFocus;

  @override
  void initState() {
    _amount = TextEditingController();
    _interestRate = TextEditingController();
    _amountFocus = FocusNode();
    _interestRateFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    _amountFocus.dispose();
    _interestRateFocus.dispose();
    super.dispose();
  }

  // Variables for the start and end dates
  DateTime? _startDate;
  DateTime? _endDate;
  Map<String, dynamic>? _calculatedInterest;

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      if (!mounted) return;
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  bool calculated = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
      child: Scaffold(
        appBar: AppBar(title: const Text('Simple Interest Calculator')),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Amount',
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    focusNode: _amountFocus, // Only focuses when user taps
                  ),
                  CustomTextField(
                    labelText: 'Interest Rate(%)',
                    controller: _interestRate,
                    keyboardType: TextInputType.number,
                    focusNode:
                        _interestRateFocus, // Same behavior for interest rate field
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, isStartDate: true),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        labelText: 'Start Date',
                        controller: TextEditingController(
                            text: _startDate == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(_startDate!)),
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, isStartDate: false),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        labelText: 'End Date',
                        controller: TextEditingController(
                            text: _endDate == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(_endDate!)),
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _calculatedInterest = calculateSimpleInterest(
                          double.parse(_amount.text),
                          double.parse(_interestRate.text),
                          _startDate!,
                          _endDate!);
                      setState(() {
                        calculated = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 62, 165,
                          177), // Set your desired background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Slightly rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Adjust padding
                    ),
                    child: const Text(
                      'Calculate Simple Interest',
                      style: TextStyle(
                        fontSize: 16, // Optional: Adjust text size
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  calculated && _calculatedInterest != null
                      ? Column(
                          children: [
                            PieChartSample2(
                              principalAmount:
                                  _calculatedInterest?['principalAmount'] ??
                                      0.0,
                              interestAmount:
                                  _calculatedInterest?['interestAmount'] ?? 0.0,
                            ),
                            InterestInfoAccordion(
                              isExpanded: true,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              principalAmount:
                                  _calculatedInterest?['principalAmount'] ??
                                      0.0,
                              interestAmount:
                                  _calculatedInterest?['interestAmount'] ?? 0.0,
                              totalAmount:
                                  _calculatedInterest?['totalAmount'] ?? 0.0,
                              interestRate: double.parse(_interestRate.text),
                              totalTime: _calculatedInterest?['timeDifference']
                                      ['totalTime'] ??
                                  "",
                            ),
                          ],
                        )
                      : Container(), // or SizedBox() for an empty widget when not calculated
                ],
              ),
            ),
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
  // Total time in years (including fractional months)
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

  // Create a readable string for total time
  String totalTime = '';
  if (years > 0) {
    totalTime += '$years ${years == 1 ? 'year' : 'years'} ';
  }
  if (months > 0) {
    totalTime += '$months ${months == 1 ? 'month' : 'months'} ';
  }
  if (days > 0) {
    totalTime += '$days ${days == 1 ? 'day' : 'days'}';
  }

  // Trim any trailing whitespace
  totalTime = totalTime.trim();

  return {
    'totalTime': totalTime.isEmpty ? '0 days' : totalTime,
    'totalDays': totalDays,
    'totalMonths': totalMonths,
    'totalYears': totalYears,
    'years': years,
    'months': months,
    'days': days,
  };
}
