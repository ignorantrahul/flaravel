import 'dart:convert';
import '../../foundation/app.dart';

/// Base model class that provides Active Record pattern functionality
abstract class Model {
  /// Create a new model instance
  Model();

  /// The table associated with the model
  String get table;
  
  /// The primary key for the model
  String get primaryKey => 'id';
  
  /// Indicates if the model should be timestamped
  bool get timestamps => true;
  
  /// The name of the "created at" column
  String get createdAtColumn => 'created_at';
  
  /// The name of the "updated at" column
  String get updatedAtColumn => 'updated_at';
  
  /// The name of the "deleted at" column for soft deletes
  String? get deletedAtColumn => null;
  
  /// The attributes that are mass assignable
  List<String> get fillable => const [];
  
  /// The attributes that aren't mass assignable
  List<String> get guarded => const ['id'];
  
  /// The model's attributes
  final Map<String, dynamic> _attributes = {};
  
  /// The model's original attributes
  final Map<String, dynamic> _original = {};
  
  /// The loaded relationships
  final Map<String, dynamic> _relations = {};
  
  /// Get the application instance
  App get app => App();
  
  /// Get all of the model's attributes
  Map<String, dynamic> get attributes => Map.unmodifiable(_attributes);
  
  /// Get the original model attributes
  Map<String, dynamic> get original => Map.unmodifiable(_original);
  
  /// Get the model's relationships
  Map<String, dynamic> get relations => Map.unmodifiable(_relations);
  
  /// Get whether the model exists in the database
  bool get exists => _attributes.containsKey(primaryKey);
  
  /// Get whether the model has been deleted
  bool get isDeleted => deletedAtColumn != null && 
      _attributes[deletedAtColumn] != null;
  
  /// Fill the model with an array of attributes
  void fill(Map<String, dynamic> attributes) {
    for (final key in attributes.keys) {
      if (_isFillable(key)) {
        _attributes[key] = attributes[key];
      }
    }
  }
  
  /// Get an attribute from the model
  dynamic getAttribute(String key) => _attributes[key];
  
  /// Set a given attribute on the model
  void setAttribute(String key, dynamic value) {
    _attributes[key] = value;
  }
  
  /// Convert the model instance to JSON
  Map<String, dynamic> toJson() => Map.from(_attributes);
  
  /// Create a new instance from JSON data
  factory Model.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }
  
  /// Determine if the given attribute may be mass assigned
  bool _isFillable(String key) {
    if (guarded.contains('*')) return false;
    if (guarded.contains(key)) return false;
    if (fillable.isEmpty) return true;
    return fillable.contains(key);
  }
  
  /// Handle dynamic property access
  dynamic operator [](String key) => getAttribute(key);
  
  /// Handle dynamic property assignment
  void operator []=(String key, dynamic value) => setAttribute(key, value);
  
  @override
  String toString() => json.encode(toJson());
}
