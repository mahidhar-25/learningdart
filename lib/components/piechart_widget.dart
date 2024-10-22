import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/components/appcolors.dart';
import 'package:learningdart/components/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  final double principalAmount;
  final double interestAmount;

  const PieChartSample2({
    super.key,
    required this.principalAmount,
    required this.interestAmount,
  });

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2, // Pie chart takes 2/3 of the row space
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(
                    widget.principalAmount,
                    widget.interestAmount,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1, // The indicators take 1/3 of the row space
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.blue, // Example color for principal
                  text: 'Principal',
                  isSquare: true,
                ),
                SizedBox(height: 8),
                Indicator(
                  color: Colors.orange, // Example color for interest
                  text: 'Interest',
                  isSquare: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      double principalAmount, double interestAmount) {
    final double totalAmount = principalAmount + interestAmount;

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          final principalPercentage = (principalAmount / totalAmount) * 100;
          return PieChartSectionData(
            color: Colors.blue, // Use your color for principal
            value: principalAmount,
            title: isTouched
                ? '${principalPercentage.toStringAsFixed(1)}%'
                : '${principalPercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
              // shadows: shadows,
            ),
          );
        case 1:
          final interestPercentage = (interestAmount / totalAmount) * 100;
          return PieChartSectionData(
            color: Colors.orange, // Use your color for interest
            value: interestAmount,
            title: isTouched
                ? '${interestPercentage.toStringAsFixed(1)}%'
                : '${interestPercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
