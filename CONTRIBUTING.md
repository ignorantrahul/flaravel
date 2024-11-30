# Contributing to Flaravel

First off, thank you for considering contributing to Flaravel! It's people like you that make Flaravel such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* Use a clear and descriptive title
* Describe the exact steps which reproduce the problem
* Provide specific examples to demonstrate the steps
* Describe the behavior you observed after following the steps
* Explain which behavior you expected to see instead and why
* Include stack traces and logs

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* Use a clear and descriptive title
* Provide a step-by-step description of the suggested enhancement
* Provide specific examples to demonstrate the steps
* Describe the current behavior and explain which behavior you expected to see instead
* Explain why this enhancement would be useful

### Pull Requests

* Fork the repo and create your branch from `main`
* If you've added code that should be tested, add tests
* Ensure the test suite passes
* Make sure your code follows the existing code style
* Write a convincing description of your PR and why we should land it

## Development Setup

1. Fork and clone the repository
2. Run `flutter pub get` to install dependencies
3. Create a new branch: `git checkout -b my-branch-name`

### Running Tests

```bash
flutter test
```

### Style Guide

* Use 2 spaces for indentation
* Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
* Write clear, readable code with meaningful variable names
* Document public APIs using dartdoc comments

### Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

## Project Structure

```
lib/
├── src/
│   ├── database/        # Database components
│   │   ├── cache/       # Query caching
│   │   ├── debug/       # Logging & profiling
│   │   ├── drivers/     # Database drivers
│   │   ├── model.dart   # Base model
│   │   └── ...
│   └── foundation/      # Core framework
└── flaravel.dart        # Main export file
```

## Testing

We maintain high test coverage. Please add tests for any new features or bug fixes.

### Test Structure

* Unit tests go in `test/unit/`
* Integration tests go in `test/integration/`
* Each feature should have its own test file
* Test files should mirror the structure of `lib/`

### Writing Tests

```dart
void main() {
  group('Feature Name', () {
    test('should do something', () {
      // Arrange
      final sut = SystemUnderTest();
      
      // Act
      final result = sut.doSomething();
      
      // Assert
      expect(result, equals(expectedValue));
    });
  });
}
```

## Documentation

* Document all public APIs
* Use examples in documentation
* Keep README.md up to date
* Update CHANGELOG.md

## Questions?

Feel free to open an issue with your question or reach out to the maintainers directly.

Thank you for contributing! 🎉
