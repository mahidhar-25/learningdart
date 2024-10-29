class KhatabookAccountClass {
  // Class fields
  final int? accountId; // Unique identifier for account
  final int userId; // Foreign key reference to KhatabookUser
  final double principalAmount; // Principal amount for the account
  final double interestRate; // Interest rate for the account
  final DateTime startDate; // Account start date
  final bool isCompounded; // Boolean flag for compound interest
  final int compoundedMonths; // Number of compounded months
  final String? accountNotes; // Optional notes for the account
  final String status; // Account status, either 'active' or 'completed'

  // Constructor
  KhatabookAccountClass({
    this.accountId,
    required this.userId,
    required this.principalAmount,
    required this.interestRate,
    required this.startDate,
    this.isCompounded = false,
    this.compoundedMonths = 0,
    this.accountNotes,
    this.status = 'active',
  });

  // Getters
  int? get getAccountId => accountId;
  int get getUserId => userId;
  double get getPrincipalAmount => principalAmount;
  double get getInterestRate => interestRate;
  DateTime get getStartDate => startDate;
  bool get getIsCompounded => isCompounded;
  int get getCompoundedMonths => compoundedMonths;
  String? get getAccountNotes => accountNotes;
  String get getStatus => status;

  // Override toString
  @override
  String toString() {
    return 'KhatabookAccountClass(accountId: $accountId, userId: $userId, principalAmount: $principalAmount, interestRate: $interestRate, startDate: $startDate, isCompounded: $isCompounded, compoundedMonths: $compoundedMonths, accountNotes: $accountNotes, status: $status)';
  }

  // Override == operator and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KhatabookAccountClass &&
        other.accountId == accountId &&
        other.userId == userId &&
        other.principalAmount == principalAmount &&
        other.interestRate == interestRate &&
        other.startDate == startDate &&
        other.isCompounded == isCompounded &&
        other.compoundedMonths == compoundedMonths &&
        other.accountNotes == accountNotes &&
        other.status == status;
  }

  @override
  int get hashCode {
    return accountId.hashCode ^
        userId.hashCode ^
        principalAmount.hashCode ^
        interestRate.hashCode ^
        startDate.hashCode ^
        isCompounded.hashCode ^
        compoundedMonths.hashCode ^
        (accountNotes?.hashCode ?? 0) ^
        status.hashCode;
  }

  // Copy with method for creating modified copies of the instance
  KhatabookAccountClass copyWith({
    int? accountId,
    int? userId,
    double? principalAmount,
    double? interestRate,
    DateTime? startDate,
    bool? isCompounded,
    int? compoundedMonths,
    String? accountNotes,
    String? status,
  }) {
    return KhatabookAccountClass(
      accountId: accountId ?? this.accountId,
      userId: userId ?? this.userId,
      principalAmount: principalAmount ?? this.principalAmount,
      interestRate: interestRate ?? this.interestRate,
      startDate: startDate ?? this.startDate,
      isCompounded: isCompounded ?? this.isCompounded,
      compoundedMonths: compoundedMonths ?? this.compoundedMonths,
      accountNotes: accountNotes ?? this.accountNotes,
      status: status ?? this.status,
    );
  }
}
