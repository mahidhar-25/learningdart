import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:learningdart/components/emi_datalist.dart';
import 'package:learningdart/components/piechart_widget.dart';
import 'package:learningdart/helpers/finance_calculations.dart';

class EMICalculatorPage extends StatefulWidget {
  const EMICalculatorPage({super.key});

  @override
  State<EMICalculatorPage> createState() => _EMICalculatorPageState();
}

class _EMICalculatorPageState extends State<EMICalculatorPage> {
  late final TextEditingController _amount;
  late final TextEditingController _interestRate;
  late final FocusNode _amountFocus;
  late final FocusNode _interestRateFocus;
  late final TextEditingController _noOfMonths;
  late final FocusNode _noOfMonthsFocus;
  @override
  void initState() {
    _amount = TextEditingController();
    _interestRate = TextEditingController();
    _amountFocus = FocusNode();
    _interestRateFocus = FocusNode();
    _noOfMonths = TextEditingController();
    _noOfMonthsFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    _amountFocus.dispose();
    _interestRateFocus.dispose();
    _noOfMonths.dispose();
    _noOfMonthsFocus.dispose();
    super.dispose();
  }

  // Variables for the start and end dates
  DateTime? _startDate;
  Map<String, dynamic>? _calculatedInterest;

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        if (isStartDate) {
          _startDate = picked;
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
        appBar: AppBar(title: const Text('EMI Calculator')),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Initial Amount',
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
                  CustomTextField(
                    labelText: 'No of Months',
                    controller: _noOfMonths,
                    keyboardType: TextInputType.number,
                    focusNode:
                        _noOfMonthsFocus, // Same behavior for interest rate field
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _calculatedInterest = calculateEMI(
                          amount: double.parse(_amount.text),
                          annualInterestRate: double.parse(_interestRate.text),
                          numberOfMonths: int.parse(_noOfMonths.text),
                          startDate: _startDate!);
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
                      'Calculate EMI\'s',
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
                                  _calculatedInterest?['totalAmountPaid'] -
                                          _calculatedInterest?[
                                              'totalInterestPaid'] ??
                                      0.0,
                              interestAmount:
                                  _calculatedInterest?['totalInterestPaid'] ??
                                      0.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey[200], // Light grey background
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                  border: Border.all(color: Colors.grey[400]!),
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
                                        color: Colors
                                            .blue[100], // Light blue background
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _calculatedInterest?['startDate'] ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                              "-"), // Add some space between dates
                                          const SizedBox(width: 8),
                                          Text(
                                            _calculatedInterest?['endDate'] ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // EMI information
                                    Text(
                                        'Total Amount: ₹${_calculatedInterest?["totalAmountPaid"]?.toStringAsFixed(2)}'),
                                    const SizedBox(height: 4),
                                    Text(
                                        'Interest Amount: ₹${_calculatedInterest?["totalInterestPaid"]?.toStringAsFixed(2)}'),
                                    const SizedBox(height: 4),
                                    // Convert to double before subtracting
                                    Text(
                                        'Principal Amount: ₹${(_calculatedInterest?["totalAmountPaid"] ?? 0) - (_calculatedInterest?["totalInterestPaid"] ?? 0)}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "EMI Details: ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 400,
                              child: EMIDetailsList(
                                  emiDetailsList:
                                      _calculatedInterest!['emiCalculations']),
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
