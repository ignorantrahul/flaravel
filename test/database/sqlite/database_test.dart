import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flaravel/src/database/sqlite/database.dart';
import 'package:flaravel/src/database/sqlite/exceptions.dart';

void main() {
  group('SQLiteDatabase', () {
    late SQLiteDatabase db;
    late String dbPath;

    setUp(() {
      // Create temporary database path
      final tempDir = Directory.systemTemp.createTempSync();
      dbPath = '${tempDir.path}/test.db';
      db = SQLiteDatabase(dbPath);
    });

    tearDown(() {
      // Close database and cleanup files
      if (db.isInitialized) {
        db.close();
      }

      final dbFile = File(dbPath);
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }

      // Delete WAL and SHM files
      final walFile = File('$dbPath-wal');
      if (walFile.existsSync()) {
        walFile.deleteSync();
      }

      final shmFile = File('$dbPath-shm');
      if (shmFile.existsSync()) {
        shmFile.deleteSync();
      }
    });

    test('can initialize database', () {
      expect(db.initialize(), true);
      expect(db.isInitialized, true);
    });

    test('can create and query tables', () {
      expect(db.initialize(), true);

      // Create table
      db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Insert data
      db.execute('INSERT INTO users (name, email) VALUES (?, ?)',
          ['John Doe', 'john@example.com']);

      // Query data
      final results =
          db.query('SELECT * FROM users WHERE email = ?', ['john@example.com']);

      expect(results.length, 1);
      expect(results[0]['name'], 'John Doe');
      expect(results[0]['email'], 'john@example.com');
    });

    test('handles transactions', () {
      expect(db.initialize(), true);

      // Create table
      db.execute(
          'CREATE TABLE counters (id INTEGER PRIMARY KEY, value INTEGER)');

      // Start transaction
      db.beginTransaction();

      try {
        db.execute('INSERT INTO counters (value) VALUES (?)', [1]);
        db.execute('INSERT INTO counters (value) VALUES (?)', [2]);
        db.commit();
      } catch (e) {
        db.rollback();
        rethrow;
      }

      final results = db.query('SELECT * FROM counters ORDER BY value');
      expect(results.length, 2);
      expect(results[0]['value'], 1);
      expect(results[1]['value'], 2);
    });

    test('handles nested transactions', () {
      expect(db.initialize(), true);

      // Create table
      db.execute(
          'CREATE TABLE nested_test (id INTEGER PRIMARY KEY, value TEXT)');

      // Start outer transaction
      db.beginTransaction();

      try {
        db.execute('INSERT INTO nested_test (value) VALUES (?)', ['outer1']);

        // Start inner transaction
        db.beginTransaction();

        try {
          db.execute('INSERT INTO nested_test (value) VALUES (?)', ['inner1']);
          db.execute('INSERT INTO nested_test (value) VALUES (?)', ['inner2']);
          db.commit(); // Commit inner transaction
        } catch (e) {
          db.rollback(); // Rollback inner transaction
          rethrow;
        }

        db.execute('INSERT INTO nested_test (value) VALUES (?)', ['outer2']);
        db.commit(); // Commit outer transaction
      } catch (e) {
        db.rollback(); // Rollback outer transaction
        rethrow;
      }

      final results = db.query('SELECT * FROM nested_test ORDER BY id');
      expect(results.length, 4);
      expect(results[0]['value'], 'outer1');
      expect(results[1]['value'], 'inner1');
      expect(results[2]['value'], 'inner2');
      expect(results[3]['value'], 'outer2');
    });

    test('handles transaction rollbacks', () {
      expect(db.initialize(), true);

      // Create table
      db.execute(
          'CREATE TABLE rollback_test (id INTEGER PRIMARY KEY, value TEXT)');

      // Start transaction
      db.beginTransaction();

      try {
        db.execute('INSERT INTO rollback_test (value) VALUES (?)', ['value1']);
        throw 'Simulated error'; // Force rollback
      } catch (e) {
        db.rollback();
      }

      final results = db.query('SELECT * FROM rollback_test');
      expect(results.length, 0); // Should be empty due to rollback
    });

    test('handles nested transaction rollbacks', () {
      expect(db.initialize(), true);

      // Create table
      db.execute(
          'CREATE TABLE nested_rollback (id INTEGER PRIMARY KEY, value TEXT)');

      // Start outer transaction
      db.beginTransaction();

      try {
        db.execute(
            'INSERT INTO nested_rollback (value) VALUES (?)', ['outer1']);

        // Start inner transaction
        db.beginTransaction();

        try {
          db.execute(
              'INSERT INTO nested_rollback (value) VALUES (?)', ['inner1']);
          throw 'Simulated error'; // Force inner rollback
        } catch (e) {
          db.rollback(); // Rollback inner transaction
        }

        db.execute(
            'INSERT INTO nested_rollback (value) VALUES (?)', ['outer2']);
        db.commit(); // Commit outer transaction
      } catch (e) {
        db.rollback(); // Rollback outer transaction if needed
      }

      final results = db.query('SELECT * FROM nested_rollback ORDER BY id');
      expect(results.length, 2);
      expect(results[0]['value'], 'outer1');
      expect(results[1]['value'], 'outer2');
    });

    test('handles errors', () {
      expect(db.initialize(), true);

      // Create table
      db.execute(
          'CREATE TABLE test (id INTEGER PRIMARY KEY, value TEXT UNIQUE)');

      // Insert initial data
      db.execute('INSERT INTO test (value) VALUES (?)', ['unique']);

      // Try to insert duplicate value
      expect(
          () => db.execute('INSERT INTO test (value) VALUES (?)', ['unique']),
          throwsA(isA<SQLiteException>()));
    });

    test('handles prepared statements', () {
      expect(db.initialize(), true);

      // Create test table
      db.execute('''
        CREATE TABLE test_prepared (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          value INTEGER NOT NULL
        )
      ''');

      // Prepare and execute statement multiple times
      final stmt =
          db.prepare('INSERT INTO test_prepared (name, value) VALUES (?, ?)');
      try {
        stmt.execute(['item1', 10]);
        stmt.execute(['item2', 20]);
        stmt.execute(['item3', 30]);
      } finally {
        stmt.finalize();
      }

      // Query and verify results
      final results = db.query('SELECT * FROM test_prepared ORDER BY value');
      expect(results.length, 3);
      expect(results[0]['name'], 'item1');
      expect(results[0]['value'], 10);
      expect(results[1]['name'], 'item2');
      expect(results[1]['value'], 20);
      expect(results[2]['name'], 'item3');
      expect(results[2]['value'], 30);
    });

    test('handles bank transfer correctly', () {
      expect(db.initialize(), true);

      // Create accounts table
      db.execute('''
        CREATE TABLE accounts (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          balance REAL NOT NULL
        )
      ''');

      // Insert initial account data
      db.execute(
        'INSERT INTO accounts (name, balance) VALUES (?, ?)',
        ['Account1', 1000.0],
      );
      db.execute(
        'INSERT INTO accounts (name, balance) VALUES (?, ?)',
        ['Account2', 2000.0],
      );

      // Perform transfer with transaction
      db.beginTransaction();
      try {
        // Deduct from Account1
        db.execute(
          'UPDATE accounts SET balance = balance - ? WHERE name = ?',
          [500.0, 'Account1'],
        );

        // Add to Account2
        db.execute(
          'UPDATE accounts SET balance = balance + ? WHERE name = ?',
          [500.0, 'Account2'],
        );

        db.commit();
      } catch (e) {
        db.rollback();
        rethrow;
      }

      // Verify balances
      final results = db.query('SELECT * FROM accounts ORDER BY name');
      expect(results.length, 2);
      expect(results[0]['balance'], 500.0);
      expect(results[1]['balance'], 2500.0);
    });

    test('handles transactions correctly', () {
      expect(db.initialize(), true);

      // Create test table
      db.execute('''
        CREATE TABLE test_transactions (
          id INTEGER PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');

      // Test successful transaction
      db.beginTransaction();
      try {
        db.execute(
          'INSERT INTO test_transactions (value) VALUES (?)',
          ['value1'],
        );
        db.execute(
          'INSERT INTO test_transactions (value) VALUES (?)',
          ['value2'],
        );
        db.commit();
      } catch (e) {
        db.rollback();
        rethrow;
      }

      var results = db.query('SELECT * FROM test_transactions ORDER BY id');
      expect(results.length, 2);
      expect(results[0]['value'], 'value1');
      expect(results[1]['value'], 'value2');

      // Test transaction rollback
      db.beginTransaction();
      try {
        db.execute(
          'INSERT INTO test_transactions (value) VALUES (?)',
          ['value3'],
        );
        throw 'Simulated error';
      } catch (e) {
        db.rollback();
      }

      results = db.query('SELECT * FROM test_transactions ORDER BY id');
      expect(results.length, 2); // Still 2, value3 was rolled back
    });

    test('handles errors gracefully', () {
      expect(db.initialize(), true);

      // Test invalid SQL
      expect(() => db.execute('INVALID SQL'), throwsA(isA<SQLiteException>()));

      // Test invalid table
      expect(() => db.execute('SELECT * FROM non_existent_table'),
          throwsA(isA<SQLiteException>()));

      // Test invalid column
      db.execute('CREATE TABLE error_test (id INTEGER PRIMARY KEY)');
      expect(
          () => db.execute(
              'INSERT INTO error_test (non_existent_column) VALUES (1)'),
          throwsA(isA<SQLiteException>()));
    });

    test('handles statement reuse correctly', () {
      expect(db.initialize(), true);

      // Create test table
      db.execute('CREATE TABLE items (name TEXT)');

      // Execute same statement multiple times using prepare
      final stmt = db.prepare('INSERT INTO items (name) VALUES (?)');
      try {
        for (var i = 0; i < 5; i++) {
          stmt.execute(['Item $i']);
        }
      } finally {
        stmt.finalize();
      }

      // Verify results
      final results = db.query('SELECT * FROM items ORDER BY name');
      expect(results.length, 5);
      for (var i = 0; i < 5; i++) {
        expect(results[i]['name'], 'Item $i');
      }
    });
  });
}
