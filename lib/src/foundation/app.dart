/// The core application container that manages the framework's state and services.
class App {
  /// Singleton instance of the application
  static final App _instance = App._internal();
  
  /// Private constructor for singleton pattern
  App._internal();
  
  /// Factory constructor that returns the singleton instance
  factory App() => _instance;
  
  /// Application version
  static const String version = '0.0.1';
  
  /// Whether the application is in debug mode
  bool isDebug = false;
  
  /// Service container for dependency injection
  final Map<Type, dynamic> _container = {};
  
  /// Configuration store
  final Map<String, dynamic> _config = {};
  
  /// Register a service in the container
  void bind<T>(T instance) {
    _container[T] = instance;
  }
  
  /// Get a service from the container
  T? resolve<T>() {
    return _container[T] as T?;
  }
  
  /// Set a configuration value
  void config(String key, dynamic value) {
    _config[key] = value;
  }
  
  /// Get a configuration value
  T? getConfig<T>(String key) {
    return _config[key] as T?;
  }
  
  /// Initialize the application
  Future<void> initialize() async {
    // Initialize core services
    _initializeServices();
    
    // Load configuration
    await _loadConfiguration();
  }
  
  void _initializeServices() {
    // Register core services
    bind(this);
  }
  
  Future<void> _loadConfiguration() async {
    // Load default configuration
    config('database.default', 'memory');
    config('database.connections.memory', {
      'driver': 'memory',
    });
  }
}
