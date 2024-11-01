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
  static const String getAllTransactionsWithUserInfo = '''
SELECT Transactions.*, khatabookUsers.name, khatabookUsers.village
FROM Transactions
JOIN khatabookUsers ON Transactions.user_id = khatabookUsers.id;
''';

  static const String createAccountsTable = '''
  CREATE TABLE Accounts (
    account_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    principal_amount REAL,
    interest_rate REAL,
    start_date DATE,
    is_compounded BOOLEAN DEFAULT FALSE,
    compounded_months INTEGER DEFAULT 0,
    account_notes TEXT,
    status TEXT DEFAULT 'active' CHECK(status IN ('active', 'completed')),
    FOREIGN KEY (user_id) REFERENCES khatabookUsers(id) ON DELETE CASCADE
);
''';

  static const AlterAccountsTable = '''
ALTER TABLE Accounts ADD COLUMN interest_amount REAL;

ALTER TABLE Accounts ADD COLUMN end_date DATE;

ALTER TABLE Accounts ADD COLUMN closed_notes TEXT;
''';

  static const String createTransactionTable = '''
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_date DATE,
    transaction_type TEXT CHECK(transaction_type IN ('credit', 'debit')),
    transaction_notes TEXT,
    user_id INTEGER,
    transaction_amount REAL,
    transaction_account INTEGER,
    FOREIGN KEY (user_id) REFERENCES khatabookUsers(id) ON DELETE CASCADE,
    FOREIGN KEY (transaction_account) REFERENCES Accounts(account_id) ON DELETE CASCADE
);
''';

  static const String insertTransaction = '''
INSERT INTO Transactions (transaction_date, transaction_type, transaction_notes, user_id, transaction_amount, transaction_account)
VALUES (?, ?, ?, ?, ?, ?);
''';

  static const String getAllTransactionsByUserId = '''
SELECT * FROM Transactions
WHERE user_id = ?;
''';

  static const String getAllTransactions = '''
SELECT * FROM Transactions;
''';

  static const String createRecievablesTable = '''
CREATE TABLE Receivables (
    receivable_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    account_id INTEGER,
    amount_received REAL,
    end_date DATE,
    received_notes TEXT,
    account_status BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES khatabookUsers(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id) ON DELETE CASCADE
);
''';

  static const String insertAccount = '''
  INSERT INTO Accounts (user_id, principal_amount, interest_rate, start_date, is_compounded, account_notes , status)
  VALUES (?, ?, ?, ?, ?, ? , ?);
''';

  static const String updateAccountByUserIdAndAccountId = '''
UPDATE Accounts
SET principal_amount = ?, interest_rate = ?, start_date = ?, is_compounded = ?, compounded_months = ?, account_notes = ?, status = ?
WHERE user_id = ? AND account_id = ?;
''';

  static const String deleteAccountByUserIdAndAccountiD = '''
DELETE FROM Accounts
WHERE user_id = ? AND account_id = ?;
''';

  static const String getAllAccountByUserId = '''
SELECT * FROM Accounts
WHERE user_id = ?;
''';

  static const String getAllAccounts = '''
SELECT * FROM Accounts;
''';

  static const String getKhatabookAccountByAccountId = '''
SELECT * FROM Accounts
WHERE  account_id = ?;
''';

  static const String getASpecificAccountByUserIdAndAccountId = '''
SELECT * FROM Accounts
WHERE user_id = ? AND account_id = ?;
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
