// sql_queries.dart
import 'dart:core';

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
  static const String createKhatabookUsersTable = '''
    CREATE TABLE khatabookUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        village TEXT NOT NULL,
        phone_number TEXT UNIQUE,
        address TEXT,
        CHECK (name IS NOT NULL AND village IS NOT NULL),
        CONSTRAINT unique_name_village UNIQUE (name, village)
    );
''';

  static const String insertKhatabookUser = '''
    INSERT INTO khatabookUsers (name, village, phone_number, address)
    VALUES (?, ?, ?, ?);
''';

  static const String getKhatabookUser = '''
    SELECT * FROM khatabookUsers
    WHERE name = ? AND village = ?;
  ''';

  static const String checkKhatabookUserExists = '''
    SELECT * FROM khatabookUsers WHERE name = ? AND village = ?
  ''';

  static const String updateKhatabookUser = '''
    UPDATE khatabookUsers
    SET name = ?, village = ?, phone_number = ?, address = ?
    WHERE name = ? AND village = ?;
  ''';

  static const String deleteKhatabookUser = '''
    DELETE FROM khatabookUsers
    WHERE name = ? AND village = ?;
  ''';

  static const String getAllKhatabookUsers = '''
    SELECT * FROM khatabookUsers;
  ''';

  static const String getKhatabookUserById = '''
    SELECT * FROM khatabookUsers
    WHERE id = ?;
  ''';

  static const String deleteAllKhatabookUsers = '''
    DELETE FROM khatabookUsers;
  ''';

  static const String updateKhatabookUserById = '''
    UPDATE khatabookUsers
    SET name = ?, village = ?, phone_number = ?, address = ?
    WHERE id = ?;
  ''';

  static const String deleteKhatabookUserById = '''
    DELETE FROM khatabookUsers
    WHERE id = ?;
  ''';
}
