import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'exceptions.dart';

// SQLite FFI type definitions
typedef Sqlite3OpenV2Native = ffi.Int32 Function(
  ffi.Pointer<Utf8> filename,
  ffi.Pointer<ffi.Pointer<ffi.Void>> ppDb,
  ffi.Int32 flags,
  ffi.Pointer<Utf8> vfs,
);
typedef Sqlite3OpenV2Dart = int Function(
  ffi.Pointer<Utf8> filename,
  ffi.Pointer<ffi.Pointer<ffi.Void>> ppDb,
  int flags,
  ffi.Pointer<Utf8> vfs,
);

typedef Sqlite3CloseV2Native = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pDb,
);
typedef Sqlite3CloseV2Dart = int Function(
  ffi.Pointer<ffi.Void> pDb,
);

typedef Sqlite3PrepareV2Native = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> db,
  ffi.Pointer<Utf8> zSql,
  ffi.Int32 nByte,
  ffi.Pointer<ffi.Pointer<ffi.Void>> ppStmt,
  ffi.Pointer<ffi.Pointer<Utf8>> pzTail,
);
typedef Sqlite3PrepareV2Dart = int Function(
  ffi.Pointer<ffi.Void> db,
  ffi.Pointer<Utf8> zSql,
  int nByte,
  ffi.Pointer<ffi.Pointer<ffi.Void>> ppStmt,
  ffi.Pointer<ffi.Pointer<Utf8>> pzTail,
);

typedef Sqlite3StepNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
);
typedef Sqlite3StepDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
);

typedef Sqlite3FinalizeNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
);
typedef Sqlite3FinalizeDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
);

typedef Sqlite3ColumnTypeNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnTypeDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnInt64Native = ffi.Int64 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnInt64Dart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnDoubleNative = ffi.Double Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnDoubleDart = double Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnTextNative = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnTextDart = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnBlobNative = ffi.Pointer<ffi.Void> Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnBlobDart = ffi.Pointer<ffi.Void> Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnBytesNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnBytesDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ColumnCountNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
);
typedef Sqlite3ColumnCountDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
);

typedef Sqlite3ChangesNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> db,
);
typedef Sqlite3ChangesDart = int Function(
  ffi.Pointer<ffi.Void> db,
);

typedef Sqlite3LastInsertRowidNative = ffi.Int64 Function(
  ffi.Pointer<ffi.Void> db,
);
typedef Sqlite3LastInsertRowidDart = int Function(
  ffi.Pointer<ffi.Void> db,
);

typedef Sqlite3BindInt64Native = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 index,
  ffi.Int64 value,
);
typedef Sqlite3BindInt64Dart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int index,
  int value,
);

typedef Sqlite3BindDoubleNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 index,
  ffi.Double value,
);
typedef Sqlite3BindDoubleDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int index,
  double value,
);

typedef Sqlite3BindTextNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 index,
  ffi.Pointer<Utf8> value,
  ffi.Int32 nBytes,
  ffi.Pointer<ffi.Void> destructor,
);
typedef Sqlite3BindTextDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int index,
  ffi.Pointer<Utf8> value,
  int nBytes,
  ffi.Pointer<ffi.Void> destructor,
);

typedef Sqlite3BindBlobNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 index,
  ffi.Pointer<ffi.Void> value,
  ffi.Int32 nBytes,
  ffi.Pointer<ffi.Void> destructor,
);
typedef Sqlite3BindBlobDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int index,
  ffi.Pointer<ffi.Void> value,
  int nBytes,
  ffi.Pointer<ffi.Void> destructor,
);

typedef Sqlite3BindNullNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 index,
);
typedef Sqlite3BindNullDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
  int index,
);

typedef Sqlite3ColumnNameNative = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> pStmt,
  ffi.Int32 iCol,
);
typedef Sqlite3ColumnNameDart = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> pStmt,
  int iCol,
);

typedef Sqlite3ResetNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
);
typedef Sqlite3ResetDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
);

typedef Sqlite3ClearBindingsNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> pStmt,
);
typedef Sqlite3ClearBindingsDart = int Function(
  ffi.Pointer<ffi.Void> pStmt,
);

typedef Sqlite3ErrMsgNative = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> db,
);
typedef Sqlite3ErrMsgDart = ffi.Pointer<Utf8> Function(
  ffi.Pointer<ffi.Void> db,
);

/// SQLite data types
enum SQLiteType {
  integer, // SQLITE_INTEGER = 1
  float, // SQLITE_FLOAT = 2
  text, // SQLITE_TEXT = 3
  blob, // SQLITE_BLOB = 4
  nullValue, // SQLITE_NULL = 5
}

/// SQLite column types
class SQLiteColumnType {
  static const int integer = 1;
  static const int float = 2;
  static const int text = 3;
  static const int blob = 4;
  static const int nullValue = 5;
}

/// SQLite result codes
class SQLiteResult {
  static const int ok = 0; // SQLITE_OK
  static const int error = 1; // SQLITE_ERROR
  static const int busy = 5; // SQLITE_BUSY
  static const int locked = 6; // SQLITE_LOCKED
  static const int nomem = 7; // SQLITE_NOMEM
  static const int readonly = 8; // SQLITE_READONLY
  static const int interrupt = 9; // SQLITE_INTERRUPT
  static const int ioerr = 10; // SQLITE_IOERR
  static const int corrupt = 11; // SQLITE_CORRUPT
  static const int full = 13; // SQLITE_FULL
  static const int cantopen = 14; // SQLITE_CANTOPEN
  static const int protocol = 15; // SQLITE_PROTOCOL
  static const int schema = 17; // SQLITE_SCHEMA
  static const int toobig = 18; // SQLITE_TOOBIG
  static const int constraint = 19; // SQLITE_CONSTRAINT
  static const int mismatch = 20; // SQLITE_MISMATCH
  static const int misuse = 21; // SQLITE_MISUSE
  static const int nolfs = 22; // SQLITE_NOLFS
  static const int auth = 23; // SQLITE_AUTH
  static const int range = 25; // SQLITE_RANGE
  static const int notadb = 26; // SQLITE_NOTADB
  static const int row = 100; // SQLITE_ROW
  static const int done = 101; // SQLITE_DONE
}

/// SQLite open flags
class SQLiteOpenFlags {
  static const int readOnly = 0x00000001; // SQLITE_OPEN_READONLY
  static const int readWrite = 0x00000002; // SQLITE_OPEN_READWRITE
  static const int create = 0x00000004; // SQLITE_OPEN_CREATE
  static const int uri = 0x00000040; // SQLITE_OPEN_URI
  static const int memory = 0x00000080; // SQLITE_OPEN_MEMORY
  static const int noMutex = 0x00008000; // SQLITE_OPEN_NOMUTEX
  static const int fullMutex = 0x00010000; // SQLITE_OPEN_FULLMUTEX
  static const int sharedCache = 0x00020000; // SQLITE_OPEN_SHAREDCACHE
  static const int privateCache = 0x00040000; // SQLITE_OPEN_PRIVATECACHE
}

/// FFI bindings for SQLite
class SQLiteBinary {
  late ffi.DynamicLibrary _dylib;

  /// SQLite database handle
  ffi.Pointer<ffi.Void>? _db;

  /// Load the SQLite library
  void loadLibrary() {
    try {
      if (Platform.isMacOS) {
        try {
          _dylib = ffi.DynamicLibrary.open('/usr/lib/libsqlite3.dylib');
        } catch (e) {
          // Try alternate path on macOS
          _dylib = ffi.DynamicLibrary.process();
        }
      } else if (Platform.isLinux) {
        try {
          _dylib = ffi.DynamicLibrary.open('libsqlite3.so');
        } catch (e) {
          // Try alternate paths on Linux
          try {
            _dylib = ffi.DynamicLibrary.open('libsqlite3.so.0');
          } catch (e) {
            _dylib = ffi.DynamicLibrary.process();
          }
        }
      } else if (Platform.isWindows) {
        try {
          _dylib = ffi.DynamicLibrary.open('sqlite3.dll');
        } catch (e) {
          // Try system32 path on Windows
          _dylib =
              ffi.DynamicLibrary.open('C:\\Windows\\System32\\sqlite3.dll');
        }
      } else {
        throw UnsupportedError(
            'Unsupported platform: ${Platform.operatingSystem}');
      }

      _loadFunctions();
    } catch (e) {
      throw Exception(
        'Failed to load SQLite library: $e',
      );
    }
  }

  // SQLite function signatures
  late final ffi.Pointer<T> Function<T extends ffi.NativeType>(
      String symbolName) _lookup;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3OpenV2Native>>
      _sqlite3OpenV2;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3CloseV2Native>>
      _sqlite3CloseV2;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3PrepareV2Native>>
      _sqlite3PrepareV2;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3StepNative>> _sqlite3Step;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3FinalizeNative>>
      _sqlite3Finalize;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnTypeNative>>
      _sqlite3ColumnType;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnInt64Native>>
      _sqlite3ColumnInt64;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnDoubleNative>>
      _sqlite3ColumnDouble;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnTextNative>>
      _sqlite3ColumnText;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnBlobNative>>
      _sqlite3ColumnBlob;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnBytesNative>>
      _sqlite3ColumnBytes;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnCountNative>>
      _sqlite3ColumnCount;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ChangesNative>>
      _sqlite3Changes;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3LastInsertRowidNative>>
      _sqlite3LastInsertRowId;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3BindInt64Native>>
      _sqlite3BindInt64;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3BindDoubleNative>>
      _sqlite3BindDouble;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3BindTextNative>>
      _sqlite3BindText;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3BindBlobNative>>
      _sqlite3BindBlob;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3BindNullNative>>
      _sqlite3BindNull;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ColumnNameNative>>
      _sqlite3ColumnName;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ResetNative>> _sqlite3Reset;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ClearBindingsNative>>
      _sqlite3ClearBindings;
  late final ffi.Pointer<ffi.NativeFunction<Sqlite3ErrMsgNative>>
      _sqlite3ErrMsg;

  void _loadFunctions() {
    _lookup = _dylib.lookup;

    _sqlite3OpenV2 = _lookup('sqlite3_open_v2');
    _sqlite3CloseV2 = _lookup('sqlite3_close_v2');
    _sqlite3PrepareV2 = _lookup('sqlite3_prepare_v2');
    _sqlite3Step = _lookup('sqlite3_step');
    _sqlite3Finalize = _lookup('sqlite3_finalize');
    _sqlite3ColumnType = _lookup('sqlite3_column_type');
    _sqlite3ColumnInt64 = _lookup('sqlite3_column_int64');
    _sqlite3ColumnDouble = _lookup('sqlite3_column_double');
    _sqlite3ColumnText = _lookup('sqlite3_column_text');
    _sqlite3ColumnBlob = _lookup('sqlite3_column_blob');
    _sqlite3ColumnBytes = _lookup('sqlite3_column_bytes');
    _sqlite3ColumnCount = _lookup('sqlite3_column_count');
    _sqlite3Changes = _lookup('sqlite3_changes');
    _sqlite3LastInsertRowId = _lookup('sqlite3_last_insert_rowid');
    _sqlite3BindInt64 = _lookup('sqlite3_bind_int64');
    _sqlite3BindDouble = _lookup('sqlite3_bind_double');
    _sqlite3BindText = _lookup('sqlite3_bind_text');
    _sqlite3BindBlob = _lookup('sqlite3_bind_blob');
    _sqlite3BindNull = _lookup('sqlite3_bind_null');
    _sqlite3ColumnName = _lookup('sqlite3_column_name');
    _sqlite3Reset = _lookup('sqlite3_reset');
    _sqlite3ClearBindings = _lookup('sqlite3_clear_bindings');
    _sqlite3ErrMsg = _lookup('sqlite3_errmsg');
  }

  /// Open a database connection
  (int, ffi.Pointer<ffi.Void>?) open(String dbPath) {
    final cPath = dbPath.toNativeUtf8();
    final ppDb = calloc<ffi.Pointer<ffi.Void>>();

    try {
      // Add NOMUTEX flag to avoid threading issues
      const flags = SQLiteOpenFlags.readWrite |
          SQLiteOpenFlags.create |
          SQLiteOpenFlags.noMutex |
          SQLiteOpenFlags.privateCache;

      final result = _sqlite3OpenV2.asFunction<Sqlite3OpenV2Dart>()(
          cPath, ppDb, flags, ffi.nullptr);

      if (result != SQLiteResult.ok) {
        if (kDebugMode) {
          print('Failed to open database: ${errorMessage(result)}');
        }
        return (result, null);
      }

      return (result, ppDb.value);
    } finally {
      calloc.free(cPath);
      calloc.free(ppDb);
    }
  }

  /// Set the database connection
  void setDb(ffi.Pointer<ffi.Void> db) {
    _db = db;
  }

  /// Close the database connection
  int close() {
    if (_db == null) return SQLiteResult.error;

    try {
      return _sqlite3CloseV2.asFunction<Sqlite3CloseV2Dart>()(_db!);
    } finally {
      _db = null;
    }
  }

  /// Prepare a SQL statement
  (int, ffi.Pointer<ffi.Void>?) prepare(String sql) {
    if (_db == null) {
      return (SQLiteResult.error, null);
    }

    final sqlText = sql.toNativeUtf8();
    final ppStmt = calloc<ffi.Pointer<ffi.Void>>();
    final ppTail = calloc<ffi.Pointer<Utf8>>();

    try {
      final result = _sqlite3PrepareV2.asFunction<Sqlite3PrepareV2Dart>()(
          _db!, sqlText, sqlText.length, ppStmt, ppTail);
      return (result, result == SQLiteResult.ok ? ppStmt.value : null);
    } finally {
      calloc.free(sqlText);
      calloc.free(ppStmt);
      calloc.free(ppTail);
    }
  }

  /// Step through a prepared statement
  int step(ffi.Pointer<ffi.Void> stmt) {
    return _sqlite3Step.asFunction<int Function(ffi.Pointer<ffi.Void>)>()(stmt);
  }

  /// Finalize a prepared statement
  int finalize(ffi.Pointer<ffi.Void> stmt) {
    return _sqlite3Finalize
        .asFunction<int Function(ffi.Pointer<ffi.Void>)>()(stmt);
  }

  /// Get the type of a column
  int columnType(ffi.Pointer<ffi.Void> stmt, int column) {
    return _sqlite3ColumnType.asFunction<Sqlite3ColumnTypeDart>()(stmt, column);
  }

  /// Get an integer from a column
  int columnInt(ffi.Pointer<ffi.Void> stmt, int column) {
    return _sqlite3ColumnInt64.asFunction<Sqlite3ColumnInt64Dart>()(
        stmt, column);
  }

  /// Get a double from a column
  double columnDouble(ffi.Pointer<ffi.Void> stmt, int column) {
    return _sqlite3ColumnDouble.asFunction<Sqlite3ColumnDoubleDart>()(
        stmt, column);
  }

  /// Get text from a column
  String? columnText(ffi.Pointer<ffi.Void> stmt, int column) {
    final type = columnType(stmt, column);
    if (type == SQLiteColumnType.nullValue) {
      return null;
    }

    final textPtr =
        _sqlite3ColumnText.asFunction<Sqlite3ColumnTextDart>()(stmt, column);
    if (textPtr == ffi.nullptr) {
      return null;
    }

    try {
      return textPtr.toDartString();
    } catch (e) {
      if (kDebugMode) {
        print('Error converting column text: $e');
      }
      return null;
    }
  }

  /// Get blob from a column
  List<int>? columnBlob(ffi.Pointer<ffi.Void> stmt, int column) {
    final type = columnType(stmt, column);
    if (type == SQLiteColumnType.nullValue) {
      return null;
    }

    final bytes =
        _sqlite3ColumnBytes.asFunction<Sqlite3ColumnBytesDart>()(stmt, column);
    if (bytes <= 0) {
      return null;
    }

    final blob =
        _sqlite3ColumnBlob.asFunction<Sqlite3ColumnBlobDart>()(stmt, column);
    if (blob == ffi.nullptr) {
      throw SQLiteException(
        'Failed to get column blob: Column is not null but returned nullptr',
        SQLiteResult.error,
      );
    }

    return blob.cast<ffi.Uint8>().asTypedList(bytes);
  }

  /// Get the number of columns in a result set
  int columnCount(ffi.Pointer<ffi.Void> stmt) {
    return _sqlite3ColumnCount.asFunction<Sqlite3ColumnCountDart>()(stmt);
  }

  /// Get the number of rows affected by the last statement
  int changes() {
    return _sqlite3Changes.asFunction<Sqlite3ChangesDart>()(_db!);
  }

  /// Get the last inserted row ID
  int lastInsertRowid() {
    return _sqlite3LastInsertRowId
        .asFunction<Sqlite3LastInsertRowidDart>()(_db!);
  }

  /// Get the error message for a result code
  String errorMessage(int resultCode) {
    final message = _sqlite3ErrMsg.asFunction<Sqlite3ErrMsgDart>()(_db!);
    if (message == ffi.nullptr) {
      return 'Unknown error';
    }
    return message.toDartString();
  }

  /// Bind an integer to a parameter
  int bindInt(ffi.Pointer<ffi.Void> stmt, int index, int value) {
    return _sqlite3BindInt64.asFunction<Sqlite3BindInt64Dart>()(
        stmt, index, value);
  }

  /// Bind a double to a parameter
  int bindDouble(ffi.Pointer<ffi.Void> stmt, int index, double value) {
    return _sqlite3BindDouble.asFunction<Sqlite3BindDoubleDart>()(
        stmt, index, value);
  }

  /// Bind text to a parameter
  int bindText(ffi.Pointer<ffi.Void> stmt, int index, String value) {
    final text = value.toNativeUtf8();
    try {
      return _sqlite3BindText.asFunction<Sqlite3BindTextDart>()(
        stmt,
        index,
        text,
        -1, // Text length, -1 means SQLite will calculate it
        ffi.Pointer<ffi.Void>.fromAddress(-1), // SQLITE_TRANSIENT
      );
    } finally {
      calloc.free(text);
    }
  }

  /// Bind a blob to a parameter
  int bindBlob(ffi.Pointer<ffi.Void> stmt, int index, List<int> value) {
    final blob = calloc<ffi.Uint8>(value.length);
    try {
      blob.asTypedList(value.length).setAll(0, value);
      return _sqlite3BindBlob.asFunction<Sqlite3BindBlobDart>()(
        stmt,
        index,
        blob.cast(),
        value.length,
        ffi.nullptr,
      );
    } finally {
      calloc.free(blob);
    }
  }

  /// Bind null to a parameter
  int bindNull(ffi.Pointer<ffi.Void> stmt, int index) {
    return _sqlite3BindNull
        .asFunction<int Function(ffi.Pointer<ffi.Void>, int)>()(stmt, index);
  }

  /// Get the name of a column
  String? columnName(ffi.Pointer<ffi.Void> stmt, int column) {
    final namePtr =
        _sqlite3ColumnName.asFunction<Sqlite3ColumnNameDart>()(stmt, column);
    if (namePtr == ffi.nullptr) {
      return null;
    }

    return namePtr.toDartString();
  }

  /// Reset a statement
  int reset(ffi.Pointer<ffi.Void> stmt) {
    return _sqlite3Reset
        .asFunction<int Function(ffi.Pointer<ffi.Void>)>()(stmt);
  }

  /// Clear bindings from a statement
  int clearBindings(ffi.Pointer<ffi.Void> stmt) {
    return _sqlite3ClearBindings
        .asFunction<int Function(ffi.Pointer<ffi.Void>)>()(stmt);
  }
}
