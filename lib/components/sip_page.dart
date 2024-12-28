import 'package:flutter/material.dart';
import 'package:learningdart/components/custom_textfield.dart';
import 'package:intl/intl.dart'; // For Indian number formatting
import 'package:learningdart/helpers/finance_calculations.dart';
import 'package:pie_chart/pie_chart.dart';

class SIPCalculatorPage extends StatefulWidget {
  const SIPCalculatorPage({super.key});

  @override
  State<SIPCalculatorPage> createState() => _SIPCalculatorPageState();
}

class _SIPCalculatorPageState extends State<SIPCalculatorPage> {
  late final TextEditingController _amount;
  late final TextEditingController _interestRate;
  late final TextEditingController _timePeriod;
  late final FocusNode _amountFocus;
  late final FocusNode _interestRateFocus;
  late final FocusNode _timePeriodFocus;

  Map<String, dynamic>? _calculatedInterest;
  bool calculated = false;

  @override
  void initState() {
    _amount = TextEditingController();
    _interestRate = TextEditingController();
    _amountFocus = FocusNode();
    _interestRateFocus = FocusNode();
    _timePeriod = TextEditingController();
    _timePeriodFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    _amountFocus.dispose();
    _interestRateFocus.dispose();
    _timePeriod.dispose();
    _timePeriodFocus.dispose();
    super.dispose();
  }

  // Method to format numbers in Indian format (with commas)
  String formatWithIndianCommas(double amount) {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
      child: Scaffold(
        appBar: AppBar(title: const Text('SIP Calculator')),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Monthly Investment',
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    focusNode: _amountFocus,
                  ),
                  CustomTextField(
                    labelText: 'Interest Rate(%)',
                    controller: _interestRate,
                    keyboardType: TextInputType.number,
                    focusNode: _interestRateFocus,
                  ),
                  CustomTextField(
                    labelText: 'Time Period (in years)',
                    controller: _timePeriod,
                    keyboardType: TextInputType.number,
                    focusNode: _timePeriodFocus,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_amount.text.isNotEmpty &&
                          _interestRate.text.isNotEmpty &&
                          _timePeriod.text.isNotEmpty) {
                        setState(() {
                          _calculatedInterest = SipCalculator.calculateSip(
                            monthlyInvestment: double.parse(_amount.text),
                            annualInterestRate:
                                double.parse(_interestRate.text),
                            timePeriodInYears: int.parse(_timePeriod.text),
                          );
                          calculated = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 62, 165, 177),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Calculate SIP',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (calculated && _calculatedInterest != null) ...[
                    const SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Investment: ₹${formatWithIndianCommas(_calculatedInterest!['totalInvestment']!)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Estimated Returns: ₹${formatWithIndianCommas(_calculatedInterest!['estimatedReturns']!)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Amount: ₹${formatWithIndianCommas(_calculatedInterest!['totalAmount']!)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PieChart(
                      dataMap: {
                        "Investment": _calculatedInterest!['totalInvestment']!,
                        "Returns": _calculatedInterest!['estimatedReturns']!,
                      },
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.bottom,
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
