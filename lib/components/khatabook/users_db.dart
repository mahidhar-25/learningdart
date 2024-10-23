import 'package:learningdart/components/model/khatabook_user.dart';
import 'package:learningdart/database/sql_queries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart'; // Required to define the path for the database

class KhatabookUser {
  final logger = Logger();
  static final KhatabookUser _singleton = KhatabookUser._internal();

  factory KhatabookUser() {
    return _singleton;
  }

  KhatabookUser._internal();

  static Database? _database;

  // Define database path and open connection
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Get the path to store the database
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "myflutter.db");

    // Open and initialize the database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate:
          createKhatabookUsersTable, // Run onCreate callback to create table
    );

    logger.i('Database initialized');
    return _database!;
  }

  // Create the user table
  Future<void> createKhatabookUsersTable(Database db, int version) async {
    await db.execute(SqlQueries.createKhatabookUsersTable);
  }

  // Function to insert a new user
  Future<Map<String, dynamic>> insertNewKhatabookUser(
      KhatabookUserClass user) async {
    try {
      final db = await database;

      // Query to check if the user already exists
      final List<Map<String, dynamic>> existingUser = await db.rawQuery(
          SqlQueries.checkKhatabookUserExists, [user.name, user.village]);

      if (existingUser.isNotEmpty) {
        // User already exists, return the user's data
        final userId = existingUser[0]['id'];
        logger.i('User already exists with ID: $userId');
        return {
          'success': false,
          'message': 'User already exists',
          'user': existingUser[0], // Return user details
        };
      }

      // Insert new user if not exists
      final int newUserId = await db.rawInsert(SqlQueries.insertKhatabookUser,
          [user.name, user.village, user.phone_number, user.address]);
      logger.i('User inserted successfully with ID: $newUserId');

      // Return success response with the new user's details
      return {
        'success': true,
        'message': 'User inserted successfully',
        'user': {
          'id': newUserId,
          'user': user,
        }
      };
    } catch (e) {
      // Handle any errors
      logger.e('Error inserting user: $e');
      return {
        'success': false,
        'message': 'Error inserting user',
        'error': e.toString(),
      };
    }
  }

  // Function to verify user credentials
  // Dummy password verification function (you should implement hashing)

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final db = await database;
      return await db.rawQuery(SqlQueries.getAllKhatabookUsers);
    } catch (e) {
      logger.e('Error fetching users: $e');
      return [];
    }
  }

  // Get user by name and village
  Future<Map<String, dynamic>?> getUserByNameAndVillage(
      String name, String village) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result =
          await db.rawQuery(SqlQueries.getKhatabookUser, [name, village]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching user: $e');
      return null;
    }
  }

  // Get user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result =
          await db.rawQuery(SqlQueries.getKhatabookUserById, [id]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching user by ID: $e');
      return null;
    }
  }

  // Update user by ID
  Future<int> updateUserById(int id, KhatabookUserClass updatedUser) async {
    try {
      final db = await database;
      final int count = await db.rawUpdate(
        SqlQueries.updateKhatabookUserById,
        [
          updatedUser.name,
          updatedUser.village,
          updatedUser.phone_number,
          updatedUser.address,
          id
        ],
      );
      logger.i('User updated successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error updating user: $e');
      return 0;
    }
  }

  // Update user by name and village
  Future<int> updateUserByNameAndVillage(
      KhatabookUserClass updatedUser, String oldName, String oldVillage) async {
    try {
      final db = await database;
      final int count = await db.rawUpdate(
        SqlQueries.updateKhatabookUser,
        [
          updatedUser.name,
          updatedUser.village,
          updatedUser.phone_number,
          updatedUser.address,
          oldName,
          oldVillage
        ],
      );
      logger.i('User updated successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error updating user: $e');
      return 0;
    }
  }

  // Delete user by ID
  Future<int> deleteUserById(int id) async {
    try {
      final db = await database;
      final int count =
          await db.rawDelete(SqlQueries.deleteKhatabookUserById, [id]);
      logger.i('User deleted successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error deleting user by ID: $e');
      return 0;
    }
  }

  // Delete user by name and village
  Future<int> deleteUserByNameAndVillage(String name, String village) async {
    try {
      final db = await database;
      final int count =
          await db.rawDelete(SqlQueries.deleteKhatabookUser, [name, village]);
      logger.i('User deleted successfully, rows affected: $count');
      return count;
    } catch (e) {
      logger.e('Error deleting user by name and village: $e');
      return 0;
    }
  }

  // Close the database connection
  Future<void> dispose() async {
    final db = await database;
    await db.close();
  }
}
