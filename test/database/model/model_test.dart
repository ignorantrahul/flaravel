import 'package:flutter_test/flutter_test.dart';
import 'package:flaravel/src/database/model/model.dart';

void main() {
  group('Model', () {
    late TestModel model;

    setUp(() {
      model = TestModel();
    });

    test('has correct default values', () {
      expect(model.primaryKey, 'id');
      expect(model.timestamps, true);
      expect(model.createdAtColumn, 'created_at');
      expect(model.updatedAtColumn, 'updated_at');
      expect(model.deletedAtColumn, null);
    });

    test('can fill attributes', () {
      model.fill({
        'name': 'Test',
        'email': 'test@example.com',
      });

      expect(model['name'], 'Test');
      expect(model['email'], 'test@example.com');
    });

    test('respects fillable attributes', () {
      model.fill({
        'name': 'Test',
        'email': 'test@example.com',
        'admin': true,
      });

      expect(model['name'], 'Test');
      expect(model['email'], 'test@example.com');
      expect(model['admin'], null);
    });

    test('respects guarded attributes', () {
      model.fill({
        'id': 1,
        'name': 'Test',
      });

      expect(model['id'], null);
      expect(model['name'], 'Test');
    });

    test('can convert to and from JSON', () {
      model.fill({
        'name': 'Test',
        'email': 'test@example.com',
      });

      final json = model.toJson();
      final newModel = TestModel.fromJson(json);

      expect(newModel['name'], 'Test');
      expect(newModel['email'], 'test@example.com');
    });

    test('can access attributes via array syntax', () {
      model['name'] = 'Test';
      expect(model['name'], 'Test');
    });
  });
}

class TestModel extends Model {
  TestModel();
  
  @override
  String get table => 'test_table';

  @override
  List<String> get fillable => ['name', 'email'];

  factory TestModel.fromJson(Map<String, dynamic> json) {
    final model = TestModel();
    model.fill(json);
    return model;
  }
}
