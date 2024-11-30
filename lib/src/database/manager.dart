import 'package:flutter/foundation.dart';
import 'sqlite/database.dart';

/// Database manager that handles connections
class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._();
  SQLiteDatabase? _db;

  DatabaseManager._();

  /// Get the singleton instance
  static DatabaseManager get instance => _instance;

  /// Get the database connection
  SQLiteDatabase get db {
    if (_db == null) {
      throw StateError('Database not initialized. Call DatabaseManager.initialize() first.');
    }
    return _db!;
  }

  /// Initialize the database with the given path
  Future<bool> initialize(String path) async {
    if (_db != null) {
      if (kDebugMode) {
        print('Database already initialized');
      }
      return true;
    }

    _db = SQLiteDatabase(path);
    return _db!.initialize();
  }

  /// Close the database connection
  Future<void> close() async {
    if (_db != null) {
      _db!.close();
      _db = null;
    }
  }
}
