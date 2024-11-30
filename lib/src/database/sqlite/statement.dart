import 'dart:ffi' as ffi;
import 'package:flutter/foundation.dart';

import 'binary_sqlite.dart';
import 'exceptions.dart';

/// A prepared SQLite statement
class SQLiteStatement {
  final String _sql;
  final SQLiteBinary _sqlite;
  ffi.Pointer<ffi.Void>? _stmt;
  bool _finalized = false;

  SQLiteStatement(this._sql, this._sqlite) {
    final (result, stmt) = _sqlite.prepare(_sql);
    if (result != SQLiteResult.ok || stmt == null) {
      throw SQLiteException(
        'Failed to prepare statement: ${_sqlite.errorMessage(result)}',
        result,
      );
    }
    _stmt = stmt;
  }

  /// Execute the statement and return the result
  List<Map<String, dynamic>> execute([List<dynamic>? parameters]) {
    if (_finalized) {
      throw StateError('Statement has been finalized');
    }

    if (_stmt == null) {
      throw StateError('Statement not initialized');
    }

    if (kDebugMode) {
      print('Executing SQL: $_sql');
      if (parameters != null) {
        print('Parameters: $parameters');
      }
    }

    final results = <Map<String, dynamic>>[];

    try {
      _sqlite.reset(_stmt!);
      _sqlite.clearBindings(_stmt!);

      // Bind parameters if provided
      if (parameters != null) {
        for (var i = 0; i < parameters.length; i++) {
          final value = parameters[i];
          if (kDebugMode) {
            print('Binding parameter $i: $value (${value.runtimeType})');
          }
          switch (value) {
            case int value:
              _sqlite.bindInt(_stmt!, i + 1, value);
            case double value:
              _sqlite.bindDouble(_stmt!, i + 1, value);
            case String value:
              _sqlite.bindText(_stmt!, i + 1, value);
            case List<int> value:
              _sqlite.bindBlob(_stmt!, i + 1, value);
            case null:
              _sqlite.bindNull(_stmt!, i + 1);
            default:
              throw ArgumentError(
                'Unsupported parameter type: ${value.runtimeType}',
              );
          }
        }
      }

      // Execute the statement and collect results
      while (true) {
        final stepResult = _sqlite.step(_stmt!);
        if (kDebugMode) {
          print('Step result: $stepResult');
        }

        if (stepResult == SQLiteResult.done) {
          break;
        }

        if (stepResult != SQLiteResult.row) {
          throw SQLiteException(
            'Failed to execute statement: ${_sqlite.errorMessage(stepResult)}',
            stepResult,
          );
        }

        final row = <String, dynamic>{};
        final columnCount = _sqlite.columnCount(_stmt!);
        if (kDebugMode) {
          print('Column count: $columnCount');
        }

        for (var i = 0; i < columnCount; i++) {
          final name = _sqlite.columnName(_stmt!, i);
          if (name == null) continue;

          final type = _sqlite.columnType(_stmt!, i);
          if (kDebugMode) {
            print('Column $i ($name) type: $type');
          }
          dynamic value;

          try {
            value = switch (type) {
              SQLiteColumnType.integer => _sqlite.columnInt(_stmt!, i),
              SQLiteColumnType.float => _sqlite.columnDouble(_stmt!, i),
              SQLiteColumnType.text => _sqlite.columnText(_stmt!, i),
              SQLiteColumnType.blob => _sqlite.columnBlob(_stmt!, i),
              SQLiteColumnType.nullValue => null,
              _ => _sqlite.columnText(_stmt!, i), // Try text for unknown types
            };
            if (kDebugMode) {
              print('Column $i ($name) value: $value');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error getting column $i ($name) value: $e');
            }
            // If conversion fails, try as text
            value = _sqlite.columnText(_stmt!, i);
          }

          row[name] = value;
        }

        results.add(row);
        if (kDebugMode) {
          print('Added row: $row');
        }
      }

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('Error executing statement: $e');
      }
      // Reset statement on error
      _sqlite.reset(_stmt!);
      _sqlite.clearBindings(_stmt!);
      rethrow;
    } finally {
      _sqlite.reset(_stmt!);
      _sqlite.clearBindings(_stmt!);
    }
  }

  /// Finalize the statement
  void finalize() {
    if (_finalized) return;
    if (_stmt != null) {
      _sqlite.finalize(_stmt!);
      _stmt = null;
    }
    _finalized = true;
  }

  /// Check if the statement has been finalized
  bool get isFinalized => _finalized;
}
