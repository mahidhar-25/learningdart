import 'dart:math';

import 'package:intl/intl.dart';
import 'package:learningdart/components/logger_component.dart';

Map<String, dynamic> calculateCompoundInterest(
    double principalAmount,
    double interestRate, // Annual interest rate as a percentage
    int compoundedPeriodInMonths, // Compounding period in months (e.g., 3 = quarterly, 12 = yearly)
    DateTime startDate,
    DateTime endDate) {
  final Map<String, dynamic> timeDifference =
      calculateDateDifference(startDate, endDate);
  double currentPrincipal = principalAmount;
  double totalInterest = 0;
  List<Map<String, dynamic>> compoundedDetails = [];

  DateTime currentStartDate = startDate;

  // Calculate the number of periods based on the difference in months between startDate and endDate
  int totalMonths = ((endDate.year - startDate.year) * 12) +
      (endDate.month - startDate.month);
  int fullPeriods = totalMonths ~/ compoundedPeriodInMonths;
  int remainingMonths = totalMonths % compoundedPeriodInMonths;

  int i;
  for (i = 0; i < fullPeriods; i++) {
    // Calculate the interest for each full compound period
    double periodInterestRate =
        (interestRate / 100) * (compoundedPeriodInMonths / 12);
    double interestForPeriod = currentPrincipal * periodInterestRate;
    totalInterest += interestForPeriod;
    currentPrincipal += interestForPeriod;

    DateTime periodEndDate = DateTime(
        currentStartDate.year,
        currentStartDate.month + compoundedPeriodInMonths,
        currentStartDate.day);

    final Map<String, dynamic> periodTimeDifference =
        calculateDateDifference(currentStartDate, periodEndDate);

    compoundedDetails.add({
      'period': i + 1,
      'interestAmount': interestForPeriod,
      'principalAmount': currentPrincipal - interestForPeriod,
      'totalAmount': currentPrincipal,
      'startDate': currentStartDate,
      'endDate': periodEndDate,
      'totalTime': periodTimeDifference['totalTime'],
    });

    currentStartDate = periodEndDate;
  }

  // Handle remaining months if any
  if (remainingMonths > 0 || currentStartDate.isBefore(endDate)) {
    DateTime finalEndDate = endDate;
    double remainingPeriodRate = (interestRate / 100) * (remainingMonths / 12);
    double interestForRemainingDays = currentPrincipal * remainingPeriodRate;
    totalInterest += interestForRemainingDays;
    currentPrincipal += interestForRemainingDays;

    final Map<String, dynamic> remainingTimeDifference =
        calculateDateDifference(currentStartDate, finalEndDate);
    compoundedDetails.add({
      'period': i + 1,
      'interestAmount': interestForRemainingDays,
      'principalAmount': currentPrincipal - interestForRemainingDays,
      'totalAmount': currentPrincipal,
      'startDate': currentStartDate,
      'endDate': finalEndDate,
      'totalTime': remainingTimeDifference['totalTime'],
    });
  }

  return {
    'principalAmount': principalAmount,
    'interestAmount': totalInterest,
    'totalAmount': currentPrincipal,
    'interestRate': interestRate,
    'compoundedPeriodInMonths': compoundedPeriodInMonths,
    'compoundedDetails': compoundedDetails,
    'totalTime': timeDifference['totalTime'],
  };
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
  final totalYears = double.parse((totalDays / 365).toString());
  final totalMonths = double.parse((totalDays / 30).toString());

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

Map<String, dynamic> calculateEMI({
  required double amount,
  required double annualInterestRate,
  required int numberOfMonths,
  required DateTime startDate,
}) {
  double monthlyInterestRate =
      annualInterestRate / (12 * 100); // Monthly interest rate in decimal
  double emi = (amount *
          monthlyInterestRate *
          pow(1 + monthlyInterestRate, numberOfMonths)) /
      (pow(1 + monthlyInterestRate, numberOfMonths) - 1);

  Map<String, dynamic> emiSchedule = {};
  double remainingPrincipal = amount;
  double totalAmountPaid = 0.0;
  List<Map<String, dynamic>> emiCalculations = [];
  for (int i = 0; i < numberOfMonths; i++) {
    double interestPaid = remainingPrincipal * monthlyInterestRate;
    double principalPaid = emi - interestPaid;
    remainingPrincipal -= principalPaid;
    totalAmountPaid += emi;

    DateTime paymentDate =
        DateTime(startDate.year, startDate.month + i, startDate.day);
    emiCalculations.add({
      "emiAmount": emi,
      "date": DateFormat('yyyy-MM-dd').format(paymentDate),
      "principalPaid": principalPaid,
      "interestPaid": interestPaid,
      "totalAmountPaid": totalAmountPaid,
    });
  }
  double finaltotalAmountPaid = 0.0;
  for (Map<String, dynamic> emi in emiCalculations) {
    finaltotalAmountPaid += emi['emiAmount'];
  }
  double finalinterestPaid = finaltotalAmountPaid - amount;
  emiSchedule['totalAmountPaid'] = finaltotalAmountPaid;
  emiSchedule['totalInterestPaid'] = finalinterestPaid;
  emiSchedule['emiCalculations'] = emiCalculations;
  emiSchedule['endDate'] = DateFormat('yyyy-MM-dd').format(DateTime(
      startDate.year, startDate.month + numberOfMonths, startDate.day));
  emiSchedule['startDate'] = DateFormat('yyyy-MM-dd')
      .format(DateTime(startDate.year, startDate.month, startDate.day));
  logger.i(emiSchedule);
  return emiSchedule;
}
