import 'package:intl/intl.dart';
import 'package:learningdart/components/model/khatabook_transaction.dart';
import 'package:learningdart/database/db_manager.dart';
import 'package:learningdart/database/sql_queries.dart';
import 'package:logger/logger.dart';

class KhatabookTransaction {
  final logger = Logger();
  // Function to insert a new account
  Future<Map<String, dynamic>> insertNewKhatabookTransaction(
      KhatabookTransactionClass transaction) async {
    try {
      final db = DatabaseManager();
      final int newTransactionId =
          await db.insert(SqlQueries.insertTransaction, [
        DateFormat('yyyy-MM-dd').format(transaction.transactionDate),
        transaction.transactionType,
        transaction.transactionNotes,
        transaction.userId,
        transaction.transactionAmount,
        transaction.transactionAccount,
      ]);
      logger.i('account inserted successfully with ID: $newTransactionId');

      // Return success response with the new account's details
      return {
        'success': true,
        'message': 'account inserted successfully',
        'account': {
          'id': newTransactionId,
          'transaction': transaction,
        }
      };
    } catch (e) {
      // Handle any errors
      logger.e('Error inserting transaction: $e');
      return {
        'success': false,
        'message': 'Error inserting transaction',
        'error': e.toString(),
      };
    }
  }

  // Function to verify account credentials
  // Dummy password verification function (you should implement hashing)

  // Get all accounts
  Future<List<Map<String, dynamic>>> getAlltransactionsofUser(
      int userId) async {
    try {
      final db = DatabaseManager();
      return await db.query(SqlQueries.getAllTransactionsByUserId, [userId]);
    } catch (e) {
      logger.e('Error fetching accounts: $e');
      return [];
    }
  }

  // Get account by name and village
  Future<List<Map<String, dynamic>>?> getAllTransactions() async {
    try {
      final db = DatabaseManager();
      final List<Map<String, dynamic>> result =
          await db.query(SqlQueries.getAllTransactionsWithUserInfo, []);
      if (result.isNotEmpty) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching account: $e');
      return null;
    }
  }

/*
  // Update account by ID
  Future<int> updateaccountById(
      int id, KhatabookTransactionClass updatedaccount) async {
    try {
      final db = DatabaseManager();
      final int count = await db.update(
        SqlQueries.updateKhatabookTransactionById,
        [
          updatedaccount.name,
          updatedaccount.village,
          updatedaccount.phone_number,
          updatedaccount.address,
          id
        ],
      );
      logger.i('account updated successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error updating account: $e');
      return 0;
    }
  }

  // Update account by name and village
  Future<int> updateaccountByNameAndVillage(
      KhatabookTransactionClass updatedaccount,
      String oldName,
      String oldVillage) async {
    try {
      final db = DatabaseManager();
      final int count = await db.update(
        SqlQueries.updateKhatabookTransaction,
        [
          updatedaccount.name,
          updatedaccount.village,
          updatedaccount.phone_number,
          updatedaccount.address,
          oldName,
          oldVillage
        ],
      );
      logger.i('account updated successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error updating account: $e');
      return 0;
    }
  }

  // Delete account by ID
  Future<int> deleteaccountById(int id) async {
    try {
      final db = DatabaseManager();
      final int count =
          await db.delete(SqlQueries.deleteKhatabookTransactionById, [id]);
      logger.i('account deleted successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error deleting account by ID: $e');
      return 0;
    }
  }

  // Delete account by name and village
  Future<int> deleteaccountByNameAndVillage(String name, String village) async {
    try {
      final db = DatabaseManager();
      final int count =
          await db.delete(SqlQueries.deleteKhatabookTransaction, [name, village]);
      logger.i('account deleted successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error deleting account by name and village: $e');
      return 0;
    }
  }


*/
  // Close the database connection
  Future<void> dispose() async {
    final db = await DatabaseManager().database;
    await db.close();
  }
}
