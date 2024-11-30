import 'package:flutter_test/flutter_test.dart';
import 'package:flaravel/src/foundation/app.dart';
import 'package:flaravel/src/foundation/provider.dart';

void main() {
  group('ServiceProvider', () {
    late App app;
    late TestProvider provider;

    setUp(() {
      app = App();
      provider = TestProvider(app);
    });

    test('provider starts unbooted', () {
      expect(provider.isBooted, false);
    });

    test('bootIfNotBooted boots provider once', () {
      expect(provider.bootCount, 0);
      
      provider.bootIfNotBooted();
      expect(provider.isBooted, true);
      expect(provider.bootCount, 1);
      
      provider.bootIfNotBooted();
      expect(provider.bootCount, 1);
    });

    test('register is called during construction', () {
      expect(provider.registerCount, 1);
    });
  });
}

class TestProvider extends ServiceProvider {
  int bootCount = 0;
  int registerCount = 0;

  TestProvider(super.app) {
    register();
  }

  @override
  void register() {
    registerCount++;
  }

  @override
  void boot() {
    bootCount++;
  }
}
