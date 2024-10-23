// ignore_for_file: constant_identifier_names

class KhatbookDataentryClass {
  int? id;
  int? userId;
  InterestEntry? interestEntry;

  KhatbookDataentryClass({
    this.id,
    this.userId,
    this.interestEntry,
  });
}

enum KhatabookDataentryType { SIMPLE_INTEREST, COMPOUND_INTEREST }

// Abstract class to define a contract for all interest entries
abstract class InterestEntry {
  double principalAmount;
  double interestRate;
  DateTime startDate;
  DateTime? endDate;

  InterestEntry({
    required this.principalAmount,
    required this.interestRate,
    required this.startDate,
    this.endDate,
  });
}

// Compounded Interest Entry class
class CompoundedInterestEntry extends InterestEntry {
  int compoundedPeriodInMonths;

  CompoundedInterestEntry({
    required super.principalAmount,
    required super.interestRate,
    required this.compoundedPeriodInMonths,
    required super.startDate,
    super.endDate,
  });
}

// Simple Interest Entry class
class SimpleInterestEntry extends InterestEntry {
  SimpleInterestEntry({
    required super.principalAmount,
    required super.interestRate,
    required super.startDate,
    super.endDate,
  });
}

// Factory class to create instances based on the enum type
class InterestEntryFactory {
  static InterestEntry createInterestEntry({
    required KhatabookDataentryType type,
    required double principalAmount,
    required double interestRate,
    required DateTime startDate,
    DateTime? endDate,
    int compoundedPeriodInMonths = 0, // Optional for compound interest
  }) {
    switch (type) {
      case KhatabookDataentryType.SIMPLE_INTEREST:
        return SimpleInterestEntry(
          principalAmount: principalAmount,
          interestRate: interestRate,
          startDate: startDate,
          endDate: endDate,
        );
      case KhatabookDataentryType.COMPOUND_INTEREST:
        return CompoundedInterestEntry(
          principalAmount: principalAmount,
          interestRate: interestRate,
          compoundedPeriodInMonths: compoundedPeriodInMonths,
          startDate: startDate,
          endDate: endDate,
        );
      default:
        throw Exception("Invalid entry type");
    }
  }
}
