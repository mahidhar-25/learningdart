import 'package:learningdart/database/sql_queries.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  final Logger logger = Logger();
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "MoneyMaster.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        try {
          await db.execute(SqlQueries.createKhatabookUsersTable);
        } catch (e) {
          logger.e("Error creating KhatabookUsers table: $e");
        }

        try {
          await db.execute(SqlQueries.createAccountsTable);
        } catch (e) {
          logger.e("Error creating Accounts table: $e");
        }

        try {
          await db.execute(SqlQueries.AlterAccountsTable);
        } catch (e) {
          logger.e("Error alter KhatabookUsers table: $e");
        }

        try {
          await db.execute(SqlQueries.createRecievablesTable);
        } catch (e) {
          logger.e("Error creating Receivables table: $e");
        }

        try {
          await db.execute(SqlQueries.createTransactionTable);
        } catch (e) {
          logger.e("Error creating Transactions table: $e");
        }

        logger.i("Database initialized");
      },
    );
  }

  Future<void> createTable(String createTableQuery) async {
    final db = await database;
    await db.execute(createTableQuery);
  }

  Future<void> execute(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    await db.execute(query, arguments);
  }

  Future<int> insert(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawInsert(query, arguments);
  }

  Future<int> delete(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawDelete(query, arguments);
  }

  Future<List<Map<String, dynamic>>> query(String query,
      [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawQuery(query, arguments);
  }

  Future<int> update(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawUpdate(query, arguments);
  }

  // Add more database-related methods as needed
}
