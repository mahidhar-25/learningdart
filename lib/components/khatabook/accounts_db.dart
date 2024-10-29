import 'package:intl/intl.dart';
import 'package:learningdart/components/model/khatabook_account.dart';
import 'package:learningdart/database/db_manager.dart';
import 'package:learningdart/database/sql_queries.dart';
import 'package:logger/logger.dart';

class KhatabookAccount {
  final logger = Logger();
  // Function to insert a new account
  Future<Map<String, dynamic>> insertNewKhatabookAccount(
      KhatabookAccountClass account) async {
    try {
      final db = await DatabaseManager();
      final int newaccountId = await db.insert(SqlQueries.insertAccount, [
        account.userId,
        account.principalAmount,
        account.interestRate,
        DateFormat('yyyy-MM-dd').format(account.startDate),
        account.isCompounded,
        account.accountNotes,
        account.status
      ]);
      logger.i('account inserted successfully with ID: $newaccountId');

      // Return success response with the new account's details
      return {
        'success': true,
        'message': 'account inserted successfully',
        'account': {
          'id': newaccountId,
          'account': account,
        }
      };
    } catch (e) {
      // Handle any errors
      logger.e('Error inserting account: $e');
      return {
        'success': false,
        'message': 'Error inserting account',
        'error': e.toString(),
      };
    }
  }

  // Function to verify account credentials
  // Dummy password verification function (you should implement hashing)

  // Get all accounts
  Future<List<Map<String, dynamic>>> getAllaccountsofUser(int userId) async {
    try {
      final db = DatabaseManager();
      return await db.query(SqlQueries.getAllAccountByUserId, [userId]);
    } catch (e) {
      logger.e('Error fetching accounts: $e');
      return [];
    }
  }

  // Get account by name and village
  Future<List<Map<String, dynamic>>?> getAllAccounts(
      String name, String village) async {
    try {
      final db = DatabaseManager();
      final List<Map<String, dynamic>> result =
          await db.query(SqlQueries.getAllAccounts, []);
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

  // Get account by ID
  Future<Map<String, dynamic>?> getaccountById(int accountId) async {
    try {
      final db = DatabaseManager();
      final List<Map<String, dynamic>> result = await db
          .query(SqlQueries.getKhatabookAccountByAccountId, [accountId]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching account by ID: $e');
      return null;
    }
  }

/*
  // Update account by ID
  Future<int> updateaccountById(
      int id, KhatabookaccountClass updatedaccount) async {
    try {
      final db = DatabaseManager();
      final int count = await db.update(
        SqlQueries.updateKhatabookaccountById,
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
      KhatabookaccountClass updatedaccount,
      String oldName,
      String oldVillage) async {
    try {
      final db = DatabaseManager();
      final int count = await db.update(
        SqlQueries.updateKhatabookaccount,
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
          await db.delete(SqlQueries.deleteKhatabookaccountById, [id]);
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
          await db.delete(SqlQueries.deleteKhatabookaccount, [name, village]);
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