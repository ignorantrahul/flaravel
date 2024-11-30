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

  QueryBuilder(this._table, [List<String>? columns]) 
      : _columns = columns ?? ['*'];

  /// Add a basic where clause to the query
  QueryBuilder where(String column, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      operator: '=',
      value: value,
      boolean: 'and',
    ));
    return this;
  }

  /// Add a where clause with custom operator
  QueryBuilder whereOperator(String column, String operator, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      operator: operator,
      value: value,
      boolean: 'and',
    ));
    return this;
  }

  /// Add an "or where" clause to the query
  QueryBuilder orWhere(String column, dynamic value) {
    _wheres.add(WhereClause(
      column: column,
      operator: '=',
      value: value,
      boolean: 'or',
    ));
    return this;
  }

  /// Add a "where in" clause to the query
  QueryBuilder whereIn(String column, List<dynamic> values) {
    _wheres.add(WhereClause(
      column: column,
      operator: 'in',
      value: values,
      boolean: 'and',
    ));
    return this;
  }

  /// Add a "where not in" clause to the query
  QueryBuilder whereNotIn(String column, List<dynamic> values) {
    _wheres.add(WhereClause(
      column: column,
      operator: 'not in',
      value: values,
      boolean: 'and',
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

  /// Get the SQL representation of the query
  String toSql() {
    final parts = <String>[];

    // Select clause
    parts.add('SELECT ${_columns.join(', ')}');
    parts.add('FROM $_table');

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
    return _wheres
        .where((w) => w.operator != 'in' && w.operator != 'not in')
        .map((w) => w.value)
        .toList();
  }

  /// Get the "in" clause bindings for the query
  List<List<dynamic>> getInClauseBindings() {
    return _wheres
        .where((w) => w.operator == 'in' || w.operator == 'not in')
        .map((w) => w.value as List<dynamic>)
        .toList();
  }
}

/// Represents a where clause in the query
class WhereClause {
  final String column;
  final String operator;
  final dynamic value;
  final String boolean;

  WhereClause({
    required this.column,
    required this.operator,
    required this.value,
    required this.boolean,
  });

  String toSql() {
    final prefix = boolean == 'and' ? 'AND' : 'OR';
    
    if (operator == 'in' || operator == 'not in') {
      final placeholders = List.filled((value as List).length, '?').join(', ');
      return '$prefix $column ${operator.toUpperCase()} ($placeholders)';
    }
    
    return '$prefix $column $operator ?';
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
