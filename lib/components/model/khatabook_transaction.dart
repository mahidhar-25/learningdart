import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class KhatabookTransactionClass {
  // Class fields
  final int? transactionId; // Unique identifier for account
  final int userId;
  final int transactionAccount; // Foreign key reference to KhatabookUser
  final double transactionAmount; // Interest rate for the account
  final DateTime transactionDate; // Number of compounded months
  final String? transactionNotes; // Optional notes for the account
  final String
      transactionType; // Account status, either 'active' or 'completed'

  // Constructor
  KhatabookTransactionClass(
      {this.transactionId,
      required this.userId,
      required this.transactionAmount,
      required this.transactionDate,
      this.transactionNotes,
      required this.transactionType,
      required this.transactionAccount});

  @override
  String toString() {
    return 'KhatabookTransactionClass(transactionId: $transactionId, userId: $userId, transactionAmount: $transactionAmount, transactionDate: $transactionDate, transactionNotes: $transactionNotes, transactionType: $transactionType)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'userId': userId,
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'transactionNotes': transactionNotes,
      'transactionType': transactionType,
    };
  }

  factory KhatabookTransactionClass.fromMap(Map<String, dynamic> map) {
    return KhatabookTransactionClass(
        transactionId:
            map['transactionId'] != null ? map['transactionId'] as int : null,
        userId: map['userId'] as int,
        transactionAmount: map['transactionAmount'] as double,
        transactionDate:
            DateTime.fromMillisecondsSinceEpoch(map['transactionDate'] as int),
        transactionNotes: map['transactionNotes'] != null
            ? map['transactionNotes'] as String
            : null,
        transactionType: map['transactionType'] as String,
        transactionAccount: map['transactionAccount'] as int);
  }

  String toJson() => json.encode(toMap());

  factory KhatabookTransactionClass.fromJson(String source) =>
      KhatabookTransactionClass.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
