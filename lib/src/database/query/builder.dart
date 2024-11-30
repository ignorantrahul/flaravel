import 'package:flaravel/src/database/manager.dart';

/// Represents a where clause in the query
class WhereClause {
  final String column;
  final dynamic value;
  final String operator;
  final bool isOr;
  final bool isIn;
  final bool isNotIn;

  WhereClause({
    required this.column,
    required this.value,
    this.operator = '=',
    this.isOr = false,
    this.isIn = false,
    this.isNotIn = false,
  });

  String toSql() {
    if (isIn || isNotIn) {
      final placeholders = List.filled((value as List).length, '?').join(', ');
      return '${isOr ? 'OR' : 'AND'} $column ${isNotIn ? 'NOT IN' : 'IN'} ($placeholders)';
    }
    return '${isOr ? 'OR' : 'AND'} $column $operator ?';
  }
}

/// Represents an order by clause in the query
class OrderBy {
  final String column;
  final String direction;

  OrderBy({
    required this.column,
    required this.direction,
  });
}

/// Represents a join condition
class JoinCondition {
  final String first;
  final String operator;
  final String second;

  JoinCondition({
    required this.first,
    required this.operator,
    required this.second,
  });
}

/// Represents a join clause in the query
class Join {
  final String type;
  final String table;
  final List<JoinCondition> conditions;

  Join({
    required this.type,
    required this.table,
    required this.conditions,
  });

  String toSql() {
    final conditionsStr = conditions
        .map((c) => '${c.first} ${c.operator} ${c.second}')
        .join(' AND ');
    return '$type JOIN $table ON $conditionsStr';
  }
}

/// A fluent query builder for constructing database queries
class QueryBuilder {
  /// The table which the query is targeting
  final String _table;

  /// The columns that should be returned
  final List<String> _columns;

  /// The where constraints for the query
  final List<WhereClause> _wheres = [];

  /// The orderings for the query
  final List<OrderBy> _orderBy = [];

  /// The maximum number of records to return
  int? _limit;

  /// The number of records to skip
  int? _offset;

  /// The joins that should be performed
  final List<Join> _joins = [];

  final List<List<dynamic>> _inClauseBindings = [];

  QueryBuilder(this._table, [List<String>? columns])
      : _columns = columns ?? ['*'];

  /// Add a basic where clause to the query
  QueryBuilder where(String column, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      value: value,
    ));
    return this;
  }

  /// Add a where clause with custom operator
  QueryBuilder whereOperator(String column, String operator, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      value: value,
      operator: operator,
    ));
    return this;
  }

  /// Add an "or where" clause to the query
  QueryBuilder orWhere(String column, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      value: value,
      isOr: true,
    ));
    return this;
  }

  /// Add a "where in" clause to the query
  QueryBuilder whereIn(String column, List<dynamic> values) {
    _wheres.add(WhereClause(
      column: column,
      value: values,
      isIn: true,
    ));
    _inClauseBindings.add(values);
    return this;
  }

  /// Add a "where not in" clause to the query
  QueryBuilder whereNotIn(String column, List<dynamic> values) {
    _wheres.add(WhereClause(
      column: column,
      value: values,
      isNotIn: true,
    ));
    _inClauseBindings.add(values);
    return this;
  }

  /// Add a "where null" clause to the query
  QueryBuilder whereNull(String column) {
    _wheres.add(WhereClause(
      column: column,
      value: null,
      operator: 'IS',
    ));
    return this;
  }

  /// Add a "where not null" clause to the query
  QueryBuilder whereNotNull(String column) {
    _wheres.add(WhereClause(
      column: column,
      value: null,
      operator: 'IS NOT',
    ));
    return this;
  }

  /// Add a "where between" clause to the query
  QueryBuilder whereBetween(String column, dynamic from, dynamic to) {
    _wheres.add(WhereClause(
      column: column,
      value: [from, to],
      operator: 'BETWEEN',
    ));
    return this;
  }

  /// Add a "where not between" clause to the query
  QueryBuilder whereNotBetween(String column, dynamic from, dynamic to) {
    _wheres.add(WhereClause(
      column: column,
      value: [from, to],
      operator: 'NOT BETWEEN',
    ));
    return this;
  }

  /// Add an "order by" clause to the query
  QueryBuilder orderBy(String column, {bool descending = false}) {
    _orderBy.add(OrderBy(
      column: column,
      direction: descending ? 'desc' : 'asc',
    ));
    return this;
  }

  /// Set the "limit" value of the query
  QueryBuilder limit(int value) {
    _limit = value;
    return this;
  }

  /// Set the "offset" value of the query
  QueryBuilder offset(int value) {
    _offset = value;
    return this;
  }

  /// Add a join clause to the query
  QueryBuilder join(String table, String first,
      [String? operator, String? second]) {
    _joins.add(Join(
      type: 'INNER',
      table: table,
      conditions: [
        JoinCondition(
          first: first,
          operator: operator ?? '=',
          second: second ?? first,
        ),
      ],
    ));
    return this;
  }

  /// Add a left join clause to the query
  QueryBuilder leftJoin(String table, String first,
      [String? operator, String? second]) {
    _joins.add(Join(
      type: 'LEFT',
      table: table,
      conditions: [
        JoinCondition(
          first: first,
          operator: operator ?? '=',
          second: second ?? first,
        ),
      ],
    ));
    return this;
  }

  /// Get the SQL representation of the query
  String toSql() {
    final parts = <String>[];

    // Select clause
    parts.add('SELECT ${_columns.join(', ')}');
    parts.add('FROM $_table');

    // Joins
    if (_joins.isNotEmpty) {
      final joinsStr = _joins.map((j) => j.toSql()).join(' ');
      parts.add(joinsStr);
    }

    // Where clauses
    if (_wheres.isNotEmpty) {
      final whereClauses = _wheres.map((w) => w.toSql()).toList();
      parts.add('WHERE ${whereClauses.join(' ')}');
    }

    // Order by
    if (_orderBy.isNotEmpty) {
      final orderClauses = _orderBy
          .map((o) => '${o.column} ${o.direction.toUpperCase()}')
          .join(', ');
      parts.add('ORDER BY $orderClauses');
    }

    // Limit and offset
    if (_limit != null) {
      parts.add('LIMIT $_limit');
    }
    if (_offset != null) {
      parts.add('OFFSET $_offset');
    }

    return parts.join(' ');
  }

  /// Get the bindings for the query
  List<dynamic> getBindings() {
    final bindings = <dynamic>[];
    for (final where in _wheres) {
      if (!where.isIn && !where.isNotIn) {
        bindings.add(where.value);
      }
    }
    return bindings;
  }

  /// Get the bindings for IN clauses
  List<List<dynamic>> getInClauseBindings() {
    return _inClauseBindings;
  }

  /// Run an aggregate query and return the result
  Map<String, dynamic> _runAggregate(String sql) {
    final db = DatabaseManager.instance.db;
    final statement = db.prepare(sql);
    try {
      final result = statement.execute();
      if (result.isEmpty) {
        return {'aggregate': 0};
      }
      return result.first;
    } finally {
      statement.finalize();
    }
  }

  /// Get the count of records in the result set
  int count([String column = '*']) {
    final result = _runAggregate('SELECT COUNT($column) as aggregate FROM $_table');
    return result['aggregate'] as int;
  }

  /// Get the average value of a column
  double avg(String column) {
    final result = _runAggregate('SELECT AVG($column) as aggregate FROM $_table');
    return result['aggregate'] as double;
  }

  /// Get the sum of a column
  num sum(String column) {
    final result = _runAggregate('SELECT SUM($column) as aggregate FROM $_table');
    return result['aggregate'] as num;
  }

  /// Get the minimum value of a column
  T min<T>(String column) {
    final result = _runAggregate('SELECT MIN($column) as aggregate FROM $_table');
    return result['aggregate'] as T;
  }

  /// Get the maximum value of a column
  T max<T>(String column) {
    final result = _runAggregate('SELECT MAX($column) as aggregate FROM $_table');
    return result['aggregate'] as T;
  }

  /// Run a general aggregate query
  num aggregate(String aggregate, String column) {
    final result = _runAggregate('SELECT $aggregate($column) as aggregate FROM $_table');
    return result['aggregate'] as num;
  }

  /// Execute the query and get all results
  Future<List<Map<String, dynamic>>> get() async {
    final sql = toSql();
    final values = getBindings();

    final db = DatabaseManager.instance.db;
    final statement = db.prepare(sql);
    try {
      if (values.isNotEmpty) {
        for (var i = 0; i < values.length; i++) {
          statement.bind(i + 1, values[i]);
        }
      }
      return statement.execute();
    } finally {
      statement.finalize();
    }
  }

  /// Execute the query and get the first result
  Future<Map<String, dynamic>?> first() async {
    _limit = 1;
    final results = await get();
    return results.isEmpty ? null : results.first;
  }

  /// Execute the query and get a specific column's value from the first result
  Future<T?> value<T>(String column) async {
    final result = await first();
    return result?[column] as T?;
  }

  /// Execute an insert query
  Future<int> insert(Map<String, dynamic> values) async {
    final columns = values.keys.join(', ');
    final placeholders = List.filled(values.length, '?').join(', ');
    final sql = 'INSERT INTO $_table ($columns) VALUES ($placeholders)';
    
    final db = DatabaseManager.instance.db;
    final statement = db.prepare(sql);
    try {
      var index = 1;
      for (var value in values.values) {
        statement.bind(index++, value);
      }
      statement.execute();
      return db.lastInsertRowid;
    } finally {
      statement.finalize();
    }
  }

  /// Execute an update query
  Future<int> update(Map<String, dynamic> values) async {
    final sets = values.keys.map((k) => '$k = ?').join(', ');
    final whereClause = _wheres.isNotEmpty ? ' WHERE ${_wheres.map((w) => w.toSql()).join(' AND ')}' : '';
    final sql = 'UPDATE $_table SET $sets$whereClause';
    
    final db = DatabaseManager.instance.db;
    final statement = db.prepare(sql);
    try {
      var index = 1;
      // Bind SET values
      for (var value in values.values) {
        statement.bind(index++, value);
      }
      // Bind WHERE values
      for (var where in _wheres) {
        if (where.value is List) {
          for (var value in where.value as List) {
            statement.bind(index++, value);
          }
        } else {
          statement.bind(index++, where.value);
        }
      }
      statement.execute();
      return db.changes;
    } finally {
      statement.finalize();
    }
  }

  /// Execute a delete query
  Future<int> delete() async {
    final whereClause = _wheres.isNotEmpty ? ' WHERE ${_wheres.map((w) => w.toSql()).join(' AND ')}' : '';
    final sql = 'DELETE FROM $_table$whereClause';
    
    final db = DatabaseManager.instance.db;
    final statement = db.prepare(sql);
    try {
      var index = 1;
      for (var where in _wheres) {
        if (where.value is List) {
          for (var value in where.value as List) {
            statement.bind(index++, value);
          }
        } else {
          statement.bind(index++, where.value);
        }
      }
      statement.execute();
      return db.changes;
    } finally {
      statement.finalize();
    }
  }
}
