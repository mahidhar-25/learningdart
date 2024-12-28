class KhatabookReceivablesClass {
  // Class fields
  final int? receivableId; // Unique identifier for account
  final int userId;
  final int accountId; // Foreign key reference to KhatabookUser
  final double amountReceived; // Principal amount for the account
  final DateTime endDate; // Number of compounded months
  final String? receivedNotes; // Optional notes for the account
  final String status; // Account status, either 'active' or 'completed'

  // Constructor
  KhatabookReceivablesClass({
    required this.accountId,
    this.receivableId,
    required this.userId,
    required this.amountReceived,
    required this.endDate,
    this.receivedNotes,
    this.status = 'active',
  });

  // Getters
  int? get getreceivableId => receivableId;
  int get getUserId => userId;
  double get getamountReceived => amountReceived;
  DateTime get getendDate => endDate;
  String? get getreceivedNotes => receivedNotes;
  String get getStatus => status;

  // Override toString
  @override
  String toString() {
    return 'KhatabookReceivablesClass(receivableId: $receivableId, userId: $userId, amountReceived: $amountReceived, endDate: $endDate,  receivedNotes: $receivedNotes, status: $status)';
  }

  // Override == operator and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KhatabookReceivablesClass &&
        other.accountId == accountId &&
        other.receivableId == receivableId &&
        other.userId == userId &&
        other.amountReceived == amountReceived &&
        other.endDate == endDate &&
        other.receivedNotes == receivedNotes &&
        other.status == status;
  }

  @override
  int get hashCode {
    return receivableId.hashCode ^
        accountId.hashCode ^
        userId.hashCode ^
        amountReceived.hashCode ^
        endDate.hashCode ^
        (receivedNotes?.hashCode ?? 0) ^
        status.hashCode;
  }

  // Copy with method for creating modified copies of the instance
  KhatabookReceivablesClass copyWith({
    int? accountId,
    int? receivableId,
    int? userId,
    double? amountReceived,
    DateTime? endDate,
    bool? isCompounded,
    int? compoundedMonths,
    String? receivedNotes,
    String? status,
  }) {
    return KhatabookReceivablesClass(
      accountId: accountId ?? this.accountId,
      receivableId: receivableId ?? this.receivableId,
      userId: userId ?? this.userId,
      amountReceived: amountReceived ?? this.amountReceived,
      endDate: endDate ?? this.endDate,
      receivedNotes: receivedNotes ?? this.receivedNotes,
      status: status ?? this.status,
    );
  }
}
