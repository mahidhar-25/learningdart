import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';
import 'sql_queries.dart';
import 'package:path/path.dart'; // Required to define the path for the database

class LocalDatabaseAuthentication {
  final logger = Logger();
  static final LocalDatabaseAuthentication _singleton =
      LocalDatabaseAuthentication._internal();

  factory LocalDatabaseAuthentication() {
    return _singleton;
  }

  LocalDatabaseAuthentication._internal();

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
      onCreate: initAuthTable, // Run onCreate callback to create table
    );

    logger.i('Database initialized');
    return _database!;
  }

  // Create the user table
  Future<void> initAuthTable(Database db, int version) async {
    await db.execute(SqlQueries.createUserTable);
  }

  // Function to insert a new user
  Future<Map<String, dynamic>> insertNewUser(
      String username, String password) async {
    try {
      final db = await database;

      // Query to check if the user already exists
      final List<Map<String, dynamic>> existingUser =
          await db.rawQuery(SqlQueries.checkUserExists, [username]);

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
      final int newUserId =
          await db.rawInsert(SqlQueries.insertUser, [username, password]);
      logger.i('User inserted successfully with ID: $newUserId');

      // Return success response with the new user's details
      return {
        'success': true,
        'message': 'User inserted successfully',
        'user': {
          'id': newUserId,
          'username': username,
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
  Future<Map<String, dynamic>> verifyUser(
      String username, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result =
          await db.rawQuery(SqlQueries.getUser, [username]);

      if (result.isNotEmpty) {
        final storedPassword = result[0]['password'];
        if (verifyPassword(password, storedPassword)) {
          logger.i('User verified successfully');
          return {
            'id': result[0]['id'],
            'username': result[0]['username'],
            'success': true,
            'text': 'User verified successfully'
          };
        } else {
          logger.e('Invalid password');
          return {'success': false, 'text': 'Invalid password'};
        }
      } else {
        logger.w('User not found');
        return {'success': false, 'text': 'User not found'};
      }
    } catch (e) {
      logger.e('Error verifying user: $e');
      return {'success': false, 'text': 'Error verifying user: $e'};
    }
  }

  // Dummy password verification function (you should implement hashing)
  bool verifyPassword(String providedPassword, String storedPassword) {
    return providedPassword == storedPassword; // Simplified for this example
  }

  // Close the database connection
  Future<void> dispose() async {
    final db = await database;
    await db.close();
  }
}
