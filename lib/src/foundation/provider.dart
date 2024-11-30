import 'app.dart';

/// Base class for service providers
abstract class ServiceProvider {
  /// The application instance
  final App app;
  
  /// Whether the provider has been booted
  bool _booted = false;
  
  ServiceProvider(this.app);
  
  /// Register any services into the container
  void register();
  
  /// Perform any post-registration bootstrapping
  void boot() {}
  
  /// Boot the provider if it hasn't been booted
  void bootIfNotBooted() {
    if (!_booted) {
      boot();
      _booted = true;
    }
  }
  
  /// Get whether the provider has been booted
  bool get isBooted => _booted;
}
