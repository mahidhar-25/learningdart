import 'package:flutter/material.dart';
import 'package:learningdart/components/interest_infoaccordian.dart';

class InterestDetailsList extends StatelessWidget {
  final List<Map<String, dynamic>> compoundedDetails;
  final double interstRate;

  const InterestDetailsList({
    super.key,
    required this.compoundedDetails,
    required this.interstRate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: compoundedDetails.length,
      itemBuilder: (context, index) {
        final detail = compoundedDetails[index];
        return InterestInfoAccordion(
          serialNumber: detail['period'],
          startDate: detail['startDate'],
          endDate: detail['endDate'],
          principalAmount: detail['principalAmount'],
          interestAmount: detail['interestAmount'],
          totalAmount: detail['totalAmount'],
          interestRate: interstRate,
          totalTime: detail['totalTime'],
          isExpanded: false, // Set this based on your initial state logic
        );
      },
    );
  }
}
