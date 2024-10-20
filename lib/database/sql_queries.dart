// sql_queries.dart
class SqlQueries {
  static const String createUserTable = '''
    CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE,
    phone_number TEXT UNIQUE,
    password TEXT NOT NULL,
    CHECK (username IS NOT NULL OR phone_number IS NOT NULL)
);
  ''';

  static const String insertUser = '''
    INSERT INTO users (username, password)
    VALUES (?, ?);
  ''';

  static const String getUser = '''
    SELECT * FROM users
    WHERE username = ?;
  ''';
  static const String checkUserExists = '''
    SELECT * FROM users WHERE username = ?
  ''';
  // Add more queries as needed
}
