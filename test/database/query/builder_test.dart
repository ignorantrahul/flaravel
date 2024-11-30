import 'package:flutter_test/flutter_test.dart';
import 'package:flaravel/src/database/query/builder.dart';

void main() {
  group('QueryBuilder', () {
    late QueryBuilder query;

    setUp(() {
      query = QueryBuilder('users');
    });

    test('builds basic select query', () {
      expect(query.toSql(), 'SELECT * FROM users');
    });

    test('builds query with specific columns', () {
      query = QueryBuilder('users', ['id', 'name', 'email']);
      expect(query.toSql(), 'SELECT id, name, email FROM users');
    });

    test('builds query with where clause', () {
      query.where('active', true);
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND active = ?',
      );
      expect(query.getBindings(), [true]);
    });

    test('builds query with multiple where clauses', () {
      query
        .where('active', true)
        .where('age', 18);
      
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND active = ? AND age = ?',
      );
      expect(query.getBindings(), [true, 18]);
    });

    test('builds query with or where clause', () {
      query
        .where('active', true)
        .orWhere('admin', true);
      
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND active = ? OR admin = ?',
      );
      expect(query.getBindings(), [true, true]);
    });

    test('builds query with where in clause', () {
      query.whereIn('status', ['active', 'pending']);
      
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND status IN (?, ?)',
      );
      expect(query.getInClauseBindings(), [
        ['active', 'pending']
      ]);
    });

    test('builds query with where not in clause', () {
      query.whereNotIn('status', ['deleted', 'banned']);
      
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND status NOT IN (?, ?)',
      );
      expect(query.getInClauseBindings(), [
        ['deleted', 'banned']
      ]);
    });

    test('builds query with custom operator', () {
      query.whereOperator('age', '>=', 18);
      
      expect(
        query.toSql(),
        'SELECT * FROM users WHERE AND age >= ?',
      );
      expect(query.getBindings(), [18]);
    });

    test('builds query with order by', () {
      query
        .orderBy('name')
        .orderBy('created_at', descending: true);
      
      expect(
        query.toSql(),
        'SELECT * FROM users ORDER BY name ASC, created_at DESC',
      );
    });

    test('builds query with limit and offset', () {
      query
        .limit(10)
        .offset(20);
      
      expect(
        query.toSql(),
        'SELECT * FROM users LIMIT 10 OFFSET 20',
      );
    });

    test('builds complex query', () {
      query
        .where('active', true)
        .whereIn('role', ['admin', 'moderator'])
        .whereOperator('posts_count', '>', 5)
        .orderBy('created_at', descending: true)
        .limit(10);
      
      expect(
        query.toSql(),
        'SELECT * FROM users '
        'WHERE AND active = ? AND role IN (?, ?) AND posts_count > ? '
        'ORDER BY created_at DESC LIMIT 10',
      );
      
      expect(query.getBindings(), [true, 5]);
      expect(query.getInClauseBindings(), [
        ['admin', 'moderator']
      ]);
    });
  });
}
