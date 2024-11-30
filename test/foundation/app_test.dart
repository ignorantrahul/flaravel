import 'package:flutter_test/flutter_test.dart';
import 'package:flaravel/src/foundation/app.dart';

void main() {
  group('App', () {
    late App app;

    setUp(() {
      app = App();
    });

    test('singleton instance works correctly', () {
      final app1 = App();
      final app2 = App();
      expect(identical(app1, app2), true);
    });

    test('debug mode can be toggled', () {
      expect(app.isDebug, false);
      app.isDebug = true;
      expect(app.isDebug, true);
    });

    test('can bind and resolve services', () {
      final service = TestService();
      app.bind<TestService>(service);
      
      final resolved = app.resolve<TestService>();
      expect(identical(service, resolved), true);
    });

    test('can set and get configuration', () {
      app.config('test.key', 'value');
      expect(app.getConfig<String>('test.key'), 'value');
    });

    test('initialization sets default configuration', () async {
      await app.initialize();
      
      expect(app.getConfig<String>('database.default'), 'memory');
      expect(
        app.getConfig<Map<String, dynamic>>('database.connections.memory'),
        {'driver': 'memory'},
      );
    });
  });
}

class TestService {}
