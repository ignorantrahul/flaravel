/// Exception thrown when a SQLite error occurs
class SQLiteException implements Exception {
  final String message;
  final int code;

  SQLiteException(this.message, this.code);

  @override
  String toString() => 'SQLiteException: $message (code: $code)';
}
