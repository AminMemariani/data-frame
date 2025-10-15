# Data Frame - Data Analysis Library for Dart

[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.9.2-blue.svg)](https://dart.dev)
[![Tests](https://img.shields.io/badge/tests-87%20passing-brightgreen.svg)](test/)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)](TEST_COVERAGE.md)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Code Quality](https://img.shields.io/badge/code%20quality-A+-brightgreen.svg)](https://dart.dev/tools/linter-rules)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)

**Data Frame** is a comprehensive data manipulation and analysis library for Dart. It provides powerful tools for working with structured data including DataFrames, Series, statistical analysis, mathematical operations, and flexible data I/O.

## Features

### Core Data Structures
- **Series**: One-dimensional labeled data structure for storing and manipulating arrays
- **DataFrame**: Two-dimensional labeled data structure for working with tabular data

### Data Manipulation
- Filtering, sorting, grouping, and transformation
- Joining and merging operations
- Null value handling
- Column and row operations

### Statistical Analysis
- Descriptive statistics
- Hypothesis testing (t-tests, chi-square, ANOVA)
- Correlation and regression analysis
- Confidence intervals
- Normality tests

### Mathematical Operations
- Element-wise operations
- Aggregation functions
- Rolling statistics
- Cumulative operations
- Mathematical functions (abs, sqrt, log, exp, trigonometric)

### Data I/O
- CSV file reading and writing
- JSON file reading and writing
- URL data fetching
- Sample data generation

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  data_frame: ^1.0.0
```

Or use the command line:

```bash
dart pub add data_frame
```

## Quick Start

```dart
import 'package:data_frame/data_frame.dart';

void main() async {
  // Create a DataFrame
  final df = DataFrame({
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'salary': [50000, 60000, 70000],
  });

  // Basic operations
  print(df.head());
  print(df.describe());

  // Filtering
  final highEarners = df.where((row) => (row['salary'] as num) > 55000);
  print(highEarners);

  // Statistical analysis
  final ageStats = Statistics.descriptiveStats(
    Series<num>(df['age'].data.cast<num>())
  );
  print('Age statistics: $ageStats');

  // I/O operations
  await DataIO.toCsv(df, 'output.csv');
  final loaded = await DataIO.readCsv('output.csv');
  print('Loaded ${loaded.length} rows');
}
```

## Core Classes

### Series<T>
A one-dimensional labeled array capable of holding any data type.

```dart
// Create from list
final series = Series<int>([1, 2, 3, 4, 5]);

// Create from map
final series2 = Series<String>.fromMap({'a': 'apple', 'b': 'banana'});

// Basic operations
print(series.sum());    // 15
print(series.mean());   // 3.0
print(series.max());    // 5

// Filtering and transformation
final filtered = series.where((x) => x > 3);  // [4, 5]
final doubled = series.map<int>((x) => x * 2); // [2, 4, 6, 8, 10]
```

### DataFrame
A two-dimensional labeled data structure with columns of potentially different types.

```dart
// Create from map
final df = DataFrame({
  'name': ['Alice', 'Bob', 'Charlie'],
  'age': [25, 30, 35],
  'city': ['NYC', 'LA', 'Chicago'],
});

// Create from records
final records = [
  {'name': 'Alice', 'age': 25},
  {'name': 'Bob', 'age': 30},
];
final df2 = DataFrame.fromRecords(records);

// Access data
print(df['name'][0]);           // 'Alice'
print(df.iloc(1));             // {'name': 'Bob', 'age': 30, 'city': 'LA'}
print(df.shape);               // [3, 3]

// Operations
final adults = df.where((row) => (row['age'] as num) >= 30);
final sorted = df.sortBy(['age']);
final grouped = df.groupBy(['city']);
```

## Statistical Functions

```dart
// Descriptive statistics
final data = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
final stats = Statistics.descriptiveStats(data);
print(stats); // count, mean, std, min, max, quartiles, etc.

// Correlation analysis
final x = Series<num>([1, 2, 3, 4, 5]);
final y = Series<num>([2, 4, 6, 8, 10]);
final corrResult = Statistics.correlationTest(x, y);
print('Correlation: ${corrResult['correlation']}');

// Linear regression
final regression = Statistics.linearRegression(x, y);
print('Slope: ${regression['slope']}');
print('R²: ${regression['r_squared']}');

// Hypothesis testing
final group1 = Series<num>([1, 2, 3, 4, 5]);
final group2 = Series<num>([2, 3, 4, 5, 6]);
final tTestResult = Statistics.tTest(group1, group2);
print('t-statistic: ${tTestResult['t_statistic']}');
print('p-value: ${tTestResult['p_value']}');
```

## Data I/O Operations

```dart
// CSV operations
await DataIO.toCsv(df, 'data.csv');
final loaded = await DataIO.readCsv('data.csv');

// JSON operations
await DataIO.toJson(df, 'data.json');
final jsonData = await DataIO.readJson('data.json');

// URL data fetching
final urlData = await DataIO.readUrl(
  'https://example.com/data.csv',
  format: 'csv'
);

// Sample data generation
final sampleNumeric = DataUtils.createSampleNumeric(rows: 100, columns: 5);
final sampleMixed = DataUtils.createSampleMixed(rows: 50);
final timeSeries = DataUtils.createTimeSeries(days: 30);
```

## Utility Functions

The `DD` class provides convenient factory methods:

```dart
// Create Series
final range = DD.range(0, 10, step: 2);        // [0, 2, 4, 6, 8]
final zeros = DD.zeros(5);                      // [0, 0, 0, 0, 0]
final ones = DD.ones(3);                        // [1, 1, 1]
final random = DD.randn(100);                   // Random normal distribution

// Create date ranges
final dates = DD.dateRange('2024-01-01', '2024-01-07');

// Data concatenation
final concatenated = DD.concat([series1, series2]);
final mergedDf = DD.merge(df1, df2, on: 'id');
```

## Mathematical Operations

```dart
// Element-wise operations
final df1 = DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]});
final added = MathOps.add(df1, 10);           // Add 10 to all values
final multiplied = MathOps.multiply(df1, 2);   // Multiply all by 2

// Mathematical functions
final sqrted = MathOps.sqrt(df1);
final logged = MathOps.log(df1);
final absolute = MathOps.abs(df1);

// Rolling statistics
final rollingMean = MathOps.rollingMean(df1, 3);
final cumSum = MathOps.cumSum(df1);

// Correlation matrix
final corrMatrix = MathOps.corr(df1);
```

## Advanced Features

### Grouping and Aggregation

```dart
final df = DataFrame({
  'category': ['A', 'B', 'A', 'B', 'A'],
  'value': [1, 2, 3, 4, 5],
});

final groups = df.groupBy(['category']);
for (final entry in groups.entries) {
  print('Group ${entry.key}:');
  print(entry.value);
}
```

### Joining DataFrames

```dart
final df1 = DataFrame({
  'id': [1, 2, 3],
  'name': ['Alice', 'Bob', 'Charlie'],
});

final df2 = DataFrame({
  'id': [1, 2, 4],
  'age': [25, 30, 35],
});

final joined = df1.join(df2, on: 'id', how: 'inner');
```

### Data Cleaning

```dart
// Handle null values
final cleaned = df.dropna();                    // Remove rows with nulls
final filled = df.fillna(0);                    // Fill nulls with 0

// Data validation
final info = df.info();                         // Get DataFrame info
final summary = df.summary();                   // Get summary statistics
```

## Performance Considerations

- DaData is optimized for medium-sized datasets (up to millions of rows)
- For very large datasets, consider processing in chunks
- Use appropriate data types to minimize memory usage
- Take advantage of lazy evaluation where possible

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our GitHub repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Examples

📁 **Comprehensive Examples Available**

The `example/` directory contains detailed, real-world examples demonstrating all aspects of the data_frame library:

### 🚀 Getting Started
- **[main.dart](example/main.dart)** - Complete overview with all major features
- **[basic_operations.dart](example/basic_operations.dart)** - DataFrame and Series fundamentals

### 📊 Advanced Analytics
- **[statistical_analysis.dart](example/statistical_analysis.dart)** - Statistical tests, correlation, regression
- **[mathematical_operations.dart](example/mathematical_operations.dart)** - Math functions, rolling statistics, financial calculations

### 🔧 Data Management
- **[data_io_operations.dart](example/data_io_operations.dart)** - CSV, JSON, URL data loading with error handling
- **[advanced_data_manipulation.dart](example/advanced_data_manipulation.dart)** - Grouping, joining, cleaning, time series

### 🎯 Practical Applications
- **[sample_data_generation.dart](example/sample_data_generation.dart)** - Generate test data, simulations, performance testing
- **[real_world_analysis.dart](example/real_world_analysis.dart)** - Complete business intelligence workflow

### 📖 Run the Examples

```bash
# Run the comprehensive overview
dart run example/main.dart

# Run specific examples
dart run example/statistical_analysis.dart
dart run example/real_world_analysis.dart

# See all available examples
ls example/
```

Each example includes:
- ✅ Complete, runnable code
- 📝 Detailed explanations and comments  
- 📊 Sample data and realistic scenarios
- 💡 Best practices and performance tips
- 🧪 Multiple use cases and patterns

Perfect for learning, reference, and adapting to your own projects!

## Testing

DaData comes with a comprehensive test suite covering all functionality:

```bash
# Run all tests
dart test

# Run with coverage
dart test --coverage=coverage

# Run specific test group
dart test -n "Series Tests"
```

**Test Coverage: 87 tests covering 100% of public APIs**

See `TEST_COVERAGE.md` for detailed coverage information.

## Code Quality

```bash
# Run static analysis
dart analyze

# Format code
dart format .
```

**Status**: ✅ No analyzer issues, all tests passing

## API Reference

For complete API documentation, visit [our documentation site](https://dadata.dev/docs) or generate docs locally with `dart doc`.