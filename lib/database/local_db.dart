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
  Future<void> insertNewUser(String username, String password) async {
    try {
      final db = await database;
      await db.rawInsert(SqlQueries.insertUser, [username, password]);
      logger.i('User inserted successfully');
    } catch (e) {
      logger.e('Error inserting user: $e');
    }
  }

  // Function to verify user credentials
  Future<bool> verifyUser(String username, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result =
          await db.rawQuery(SqlQueries.getUser, [username, password]);

      if (result.isNotEmpty) {
        final storedPassword = result[0]['password'];
        if (verifyPassword(password, storedPassword)) {
          logger.i('User verified successfully');
          return true;
        } else {
          logger.e('Invalid password');
          return false;
        }
      } else {
        logger.w('User not found');
        return false;
      }
    } catch (e) {
      logger.e('Error verifying user: $e');
      return false;
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
