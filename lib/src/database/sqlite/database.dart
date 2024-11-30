import 'dart:io';
import 'package:flutter/foundation.dart';

import 'binary_sqlite.dart';
import 'statement.dart';
import 'exceptions.dart';

/// A SQLite database connection
class SQLiteDatabase {
  final String _path;
  final SQLiteBinary _sqlite;
  bool _initialized = false;
  int _transactionLevel = 0;
  final Set<SQLiteStatement> _statements = {};

  SQLiteDatabase(this._path) : _sqlite = SQLiteBinary();

  /// Initialize the database connection
  bool initialize() {
    if (_initialized) return true;

    try {
      // Ensure directory exists
      final dbFile = File(_path);
      if (!dbFile.parent.existsSync()) {
        dbFile.parent.createSync(recursive: true);
      }

      // Load SQLite library
      try {
        _sqlite.loadLibrary();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to load SQLite library: $e');
        }
        return false;
      }

      // Open database
      final (result, db) = _sqlite.open(_path);
      if (result != SQLiteResult.ok || db == null) {
        if (kDebugMode) {
          print('Failed to open database: ${_sqlite.errorMessage(result)}');
        }
        return false;
      }

      _sqlite.setDb(db);
      _initialized = true;

      // Enable foreign keys
      try {
        final fkResult = query('PRAGMA foreign_keys');
        if (fkResult.isEmpty || fkResult[0]['foreign_keys'] != 1) {
          execute('PRAGMA foreign_keys = ON');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Warning: Failed to enable foreign keys: $e');
        }
        // Continue anyway as this is not critical
      }

      // Enable WAL mode if not already enabled
      try {
        final walResult = query('PRAGMA journal_mode');
        if (walResult.isEmpty || walResult[0]['journal_mode'] != 'wal') {
          execute('PRAGMA journal_mode = WAL');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Warning: Failed to enable WAL mode: $e');
        }
        // Continue anyway as this is not critical
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Database initialization failed: $e');
      }
      _initialized = false;
      return false;
    }
  }

  /// Execute a SQL statement and return the results
  List<Map<String, dynamic>> execute(String sql, [List<dynamic>? parameters]) {
    if (!_initialized) {
      throw StateError('Database not initialized');
    }

    final stmt = prepare(sql);
    try {
      return stmt.execute(parameters);
    } finally {
      stmt.finalize();
    }
  }

  /// Query the database and return the results
  List<Map<String, dynamic>> query(String sql, [List<dynamic>? parameters]) {
    return execute(sql, parameters);
  }

  /// Prepare a SQL statement
  SQLiteStatement prepare(String sql) {
    if (!_initialized) {
      throw StateError('Database not initialized');
    }

    final stmt = SQLiteStatement(sql, _sqlite);
    _statements.add(stmt);
    return stmt;
  }

  /// Begin a transaction
  void beginTransaction() {
    if (!_initialized) {
      throw StateError('Database not initialized');
    }

    try {
      if (_transactionLevel == 0) {
        execute('BEGIN IMMEDIATE TRANSACTION');
      } else {
        execute('SAVEPOINT level_$_transactionLevel');
      }
      _transactionLevel++;
    } catch (e) {
      if (e is SQLiteException) rethrow;
      throw SQLiteException(
          'Failed to begin transaction: $e', SQLiteResult.error);
    }
  }

  /// Commit the current transaction
  void commit() {
    if (!_initialized) {
      throw StateError('Database not initialized');
    }

    if (_transactionLevel == 0) {
      throw StateError('No transaction to commit');
    }

    try {
      if (_transactionLevel == 1) {
        execute('COMMIT');
      } else {
        execute('RELEASE SAVEPOINT level_${_transactionLevel - 1}');
      }
      _transactionLevel--;
    } catch (e) {
      // If commit fails, try to rollback to maintain consistent state
      try {
        if (_transactionLevel == 1) {
          execute('ROLLBACK');
        } else {
          execute('ROLLBACK TO SAVEPOINT level_${_transactionLevel - 1}');
        }
      } catch (_) {
        // Ignore rollback errors
      }
      if (e is SQLiteException) rethrow;
      throw SQLiteException(
          'Failed to commit transaction: $e', SQLiteResult.error);
    }
  }

  /// Rollback the current transaction
  void rollback() {
    if (!_initialized) {
      throw StateError('Database not initialized');
    }

    if (_transactionLevel == 0) {
      throw StateError('No transaction to rollback');
    }

    try {
      if (_transactionLevel == 1) {
        execute('ROLLBACK');
      } else {
        execute('ROLLBACK TO SAVEPOINT level_${_transactionLevel - 1}');
      }
      _transactionLevel--;
    } catch (e) {
      if (e is SQLiteException) rethrow;
      throw SQLiteException(
          'Failed to rollback transaction: $e', SQLiteResult.error);
    }
  }

  /// Get the number of rows affected by the last statement
  int get changes => _sqlite.changes();

  /// Get the ID of the last inserted row
  int get lastInsertRowid => _sqlite.lastInsertRowid();

  /// Get the current transaction level
  int get transactionLevel => _transactionLevel;

  /// Check if the database is initialized
  bool get isInitialized => _initialized;

  /// Close the database connection
  void close() {
    if (!_initialized) return;

    try {
      // First finalize all prepared statements
      for (final stmt in _statements.toList()) {
        try {
          stmt.finalize();
        } catch (e) {
          if (kDebugMode) {
            print('Warning: Failed to finalize statement: $e');
          }
        }
      }
      _statements.clear();

      // Then rollback any pending transactions
      if (_transactionLevel > 0) {
        while (_transactionLevel > 0) {
          rollback();
        }
      }

      // Finally close the database
      final result = _sqlite.close();
      if (result != SQLiteResult.ok) {
        throw SQLiteException(
          'Failed to close database: ${_sqlite.errorMessage(result)}',
          result,
        );
      }
    } finally {
      _initialized = false;
      _transactionLevel = 0;
    }
  }
}
