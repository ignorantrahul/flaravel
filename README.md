# Flaravel

<p align="center">
  <img src="assets/logo.svg" width="200" alt="Flaravel Logo">
</p>

<h1 align="center">Flaravel</h1>
<p align="center">
  <strong>Elegant Laravel-inspired Framework for Flutter</strong>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#features">Features</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#contributing">Contributing</a>
</p>

## Overview

Flaravel brings Laravel's elegant architecture and development patterns to Flutter, providing a robust foundation for building scalable mobile applications. It features a powerful database layer with an Eloquent-like ORM, query builder, migrations, and more.

## Features

### Database Layer
- **Eloquent-like ORM**
  - Active Record pattern
  - Attribute casting with type safety
  - Mass assignment protection with fillable/guarded
  - Model events and global scopes
  - Soft deletes with automatic query scoping
  - Timestamps with customizable columns
  - Rich relationships (HasOne, HasMany, BelongsTo, BelongsToMany)
  - JSON serialization/deserialization
  - Type-safe model creation and updates

- **Advanced Query Builder**
  - Fluent interface with method chaining
  - Complex joins with multiple conditions
  - Advanced where clauses (whereIn, whereNotIn, whereNull, etc.)
  - Aggregates (count, sum, avg, etc.)
  - Union and Union All support
  - Raw queries with parameter binding
  - Sophisticated query caching system
  - Transaction support with rollback
  - Type-safe query results
  - Eager loading optimization

- **Query Cache Management**
  - Intelligent cache invalidation
  - Configurable cache TTL per query
  - Table-aware caching with dependencies
  - Transaction-safe cache updates
  - Memory-efficient cache storage
  - Cache statistics and monitoring

### Performance & Debugging
- **Query Caching**
  - Smart cache key generation
  - Automatic cache invalidation on writes
  - Per-query cache configuration
  - Memory-efficient caching strategies
  - Cache hit/miss statistics

- **Query Logging & Profiling**
  - Detailed query execution logs
  - Performance profiling with timing
  - Memory usage tracking
  - Cache performance metrics
  - Query plan analysis
  - Error tracking with stack traces

### Type Safety & Modern Features
- Full Dart 3.0+ support
  - Sound null safety
  - Strong typing throughout
  - Generic type parameters
  - Extension methods
  - Record types for tuples
  - Pattern matching support

## Installation

Add Flaravel to your pubspec.yaml:

```yaml
dependencies:
  flaravel: ^0.0.1
```

## Quick Start

### Basic Usage

```dart
// Define a model
class User extends Model {
  @override
  String get table => 'users';
  
  @override
  List<String> get fillable => ['name', 'email'];
  
  // Enable soft deletes
  @override
  String? get deletedAtColumn => 'deleted_at';
}

// Use the query builder
final users = await DB()
    .table('users')
    .where('active', true)
    .orderBy('name')
    .get();

// Use the model
final user = await User()
    .where('email', 'john@example.com')
    .first();

// Create with mass assignment
final newUser = await User().create({
  'name': 'John Doe',
  'email': 'john@example.com'
});

// Soft delete
await user.delete(); // Marks as deleted
await user.forceDelete(); // Actually deletes

// Restore soft deleted model
await user.restore();
```

### Advanced Usage Examples

#### Model Definition with Relationships

```dart
class User extends Model {
  @override
  String get table => 'users';
  
  @override
  List<String> get fillable => ['name', 'email', 'settings'];
  
  @override
  Map<String, Type> get casts => {
    'settings': Map<String, dynamic>,
    'last_login': DateTime,
  };
  
  // Relationships
  HasMany<Post> posts() => hasMany(Post);
  HasOne<Profile> profile() => hasOne(Profile);
  
  // Scopes
  static void boot() {
    addGlobalScope('active', (builder) => builder.where('active', true));
  }
}
```

#### Advanced Queries with Caching

```dart
// Complex query with relationship loading and caching
final users = await User()
    .with(['posts', 'profile'])
    .whereHas('posts', (query) {
      query.where('published', true)
           .where('views', '>', 1000);
    })
    .whereNotNull('email_verified_at')
    .orderByDesc('created_at')
    .remember(duration: Duration(minutes: 15))
    .paginate(page: 1, perPage: 20);

// Union queries
final allPosts = await Post()
    .where('type', 'blog')
    .union(
      Post().where('type', 'news')
    )
    .unionAll(
      Post().where('type', 'announcement')
    )
    .orderBy('published_at')
    .get();
```

#### Transaction with Error Handling

```dart
try {
  await DB().transaction((tx) async {
    final user = await tx.table('users')
        .where('id', userId)
        .lockForUpdate()
        .first();
        
    if (user == null) throw UserNotFoundException();
    
    await tx.table('users')
        .where('id', userId)
        .update({'balance': user['balance'] + amount});
        
    await tx.table('transactions').insert({
      'user_id': userId,
      'amount': amount,
      'type': 'credit',
      'status': 'completed'
    });
  });
} on DatabaseException catch (e) {
  // Handle database errors
  logger.error('Transaction failed', e);
  throw TransactionFailedException(e);
}
```

#### Cache Management

```dart
// Configure cache settings
QueryCacheManager.instance
  ..setDefaultTTL(Duration(minutes: 30))
  ..setMaxEntries(1000)
  ..enableStatistics();

// Query with custom cache settings
final posts = await Post()
    .where('status', 'published')
    .remember(
      duration: Duration(hours: 1),
      tags: ['posts', 'public'],
    )
    .get();

// Invalidate specific cache tags
await QueryCacheManager.instance.invalidateTags(['posts']);

// Get cache statistics
final stats = QueryCacheManager.instance.getStatistics();
print('Cache hit rate: ${stats.hitRate}%');
```

## Architecture

Flaravel follows a modular architecture:

```
lib/
├── src/
│   ├── database/
│   │   ├── cache/        # Query caching
│   │   ├── debug/        # Logging & profiling
│   │   ├── drivers/      # Database drivers
│   │   ├── model.dart    # Base model
│   │   ├── migration.dart # Migrations
│   │   └── query_builder.dart # Query builder
│   └── foundation/    # Core framework
└── flaravel.dart     # Main export file
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
