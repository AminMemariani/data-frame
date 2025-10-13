/// Dart Pandas - A comprehensive data manipulation and analysis library for Dart
///
/// Dart Pandas provides pandas-like functionality for Dart, enabling powerful
/// data analysis, manipulation, and statistical operations.
///
/// ## Key Components
///
/// - [Series]: One-dimensional labeled data structure
/// - [DataFrame]: Two-dimensional labeled data structure
/// - [DataIO]: Input/output operations for CSV, JSON, and other formats
/// - [MathOps]: Mathematical operations and aggregations
/// - [Statistics]: Statistical analysis and hypothesis testing
///
/// ## Example Usage
///
/// ```dart
/// import 'package:dart_pandas/dart_pandas.dart';
///
/// void main() async {
///   // Create a DataFrame
///   final df = DataFrame({
///     'name': ['Alice', 'Bob', 'Charlie'],
///     'age': [25, 30, 35],
///     'salary': [50000, 60000, 70000],
///   });
///
///   // Basic operations
///   print(df.head());
///   print(df.describe());
///
///   // Filtering
///   final adults = df.where((row) => row['age'] >= 30);
///
///   // Statistical analysis
///   final stats = Statistics.descriptiveStats(df['salary']);
///   print('Salary statistics: $stats');
///
///   // I/O operations
///   await DataIO.toCsv(df, 'output.csv');
///   final loaded = await DataIO.readCsv('output.csv');
/// }
/// ```
library;

// Core data structures
export 'src/series.dart';
export 'src/dataframe.dart';

// I/O operations
export 'src/io.dart';

// Mathematical operations
export 'src/math_ops.dart';

// Statistical functions
export 'src/statistics.dart';

// Utility functions and factory methods

import 'src/series.dart';
import 'src/dataframe.dart';
import 'src/io.dart';
import 'src/statistics.dart';
import 'dart:math' as math;

/// Utility functions for creating and manipulating data structures
class DD {
  /// Creates a Series from a list of values
  static Series<T> series<T>(List<T> data, {List<String>? index}) {
    return Series<T>(data, index: index);
  }

  /// Creates a Series from a map
  static Series<T> seriesFromMap<T>(Map<String, T> map) {
    return Series<T>.fromMap(map);
  }

  /// Creates a DataFrame from a map of columns
  static DataFrame dataFrame(
    Map<String, List<dynamic>> data, {
    List<String>? index,
  }) {
    return DataFrame(data, index: index);
  }

  /// Creates a DataFrame from a list of records
  static DataFrame dataFrameFromRecords(
    List<Map<String, dynamic>> records, {
    List<String>? index,
  }) {
    return DataFrame.fromRecords(records, index: index);
  }

  /// Creates a range of integers as a Series
  static Series<int> range(int start, int end, {int step = 1}) {
    final values = <int>[];
    for (var i = start; i < end; i += step) {
      values.add(i);
    }
    return Series<int>(values);
  }

  /// Creates a Series of dates
  static Series<String> dateRange(
    String start,
    String end, {
    String freq = 'D',
  }) {
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);
    final dates = <String>[];

    var current = startDate;
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current.toIso8601String().split('T')[0]);

      switch (freq.toLowerCase()) {
        case 'd':
          current = current.add(const Duration(days: 1));
          break;
        case 'w':
          current = current.add(const Duration(days: 7));
          break;
        case 'm':
          current = DateTime(current.year, current.month + 1, current.day);
          break;
        default:
          throw ArgumentError('Unsupported frequency: $freq');
      }
    }

    return Series<String>(dates);
  }

  /// Creates a Series filled with a constant value
  static Series<T> full<T>(int length, T value, {List<String>? index}) {
    return Series<T>(List.filled(length, value), index: index);
  }

  /// Creates a Series of zeros
  static Series<num> zeros(int length, {List<String>? index}) {
    return Series<num>(List.filled(length, 0), index: index);
  }

  /// Creates a Series of ones
  static Series<num> ones(int length, {List<String>? index}) {
    return Series<num>(List.filled(length, 1), index: index);
  }

  /// Creates a Series with normally distributed random numbers
  static Series<double> randn(
    int length, {
    double mean = 0.0,
    double std = 1.0,
    int? seed,
  }) {
    final random = seed != null ? math.Random(seed) : math.Random();
    final values = <double>[];

    for (var i = 0; i < length; i++) {
      // Box-Muller transform for normal distribution
      if (i % 2 == 0) {
        final u1 = random.nextDouble();
        final u2 = random.nextDouble();
        final z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
        final z1 = math.sqrt(-2 * math.log(u1)) * math.sin(2 * math.pi * u2);

        values.add(mean + std * z0);
        if (i + 1 < length) {
          values.add(mean + std * z1);
        }
      }
    }

    return Series<double>(values.take(length).toList());
  }

  /// Creates a Series with uniformly distributed random numbers
  static Series<double> rand(
    int length, {
    double min = 0.0,
    double max = 1.0,
    int? seed,
  }) {
    final random = seed != null ? math.Random(seed) : math.Random();
    final values = List.generate(
      length,
      (_) => min + random.nextDouble() * (max - min),
    );
    return Series<double>(values);
  }

  /// Concatenates multiple Series into one
  static Series<T> concat<T>(
    List<Series<T>> seriesList, {
    bool ignoreIndex = false,
  }) {
    final allData = <T>[];
    final allIndex = <String>[];

    for (final series in seriesList) {
      allData.addAll(series.data);
      if (ignoreIndex) {
        allIndex.addAll(
          List.generate(series.length, (i) => (allIndex.length + i).toString()),
        );
      } else {
        allIndex.addAll(series.index);
      }
    }

    return Series<T>(allData, index: allIndex);
  }

  /// Concatenates multiple DataFrames
  static DataFrame concatDataFrames(
    List<DataFrame> dataFrames, {
    bool ignoreIndex = false,
    int axis = 0,
  }) {
    if (dataFrames.isEmpty) return DataFrame.empty();

    if (axis == 0) {
      // Concatenate rows
      final allColumns = <String>{};
      for (final df in dataFrames) {
        allColumns.addAll(df.columns);
      }

      final data = <String, List<dynamic>>{};
      final newIndex = <String>[];

      for (final column in allColumns) {
        data[column] = <dynamic>[];
      }

      var indexCounter = 0;
      for (final df in dataFrames) {
        for (var i = 0; i < df.length; i++) {
          if (ignoreIndex) {
            newIndex.add(indexCounter.toString());
            indexCounter++;
          } else {
            newIndex.add(df.index[i]);
          }

          for (final column in allColumns) {
            if (df.columns.contains(column)) {
              data[column]!.add(df[column][i]);
            } else {
              data[column]!.add(null);
            }
          }
        }
      }

      return DataFrame(data, index: newIndex);
    } else {
      // Concatenate columns
      throw UnimplementedError('Column concatenation not yet implemented');
    }
  }

  /// Merges two DataFrames on a common column
  static DataFrame merge(
    DataFrame left,
    DataFrame right, {
    required String on,
    String how = 'inner',
  }) {
    return left.join(right, on: on, how: how);
  }

  /// Reads a CSV file
  static Future<DataFrame> readCsv(
    String filePath, {
    String separator = ',',
    bool hasHeader = true,
    List<String>? columnNames,
    Map<String, Type>? dtypes,
  }) {
    return DataIO.readCsv(
      filePath,
      separator: separator,
      hasHeader: hasHeader,
      columnNames: columnNames,
      dtypes: dtypes,
    );
  }

  /// Reads a JSON file
  static Future<DataFrame> readJson(
    String filePath, {
    String orient = 'records',
  }) {
    return DataIO.readJson(filePath, orient: orient);
  }

  /// Reads data from a URL
  static Future<DataFrame> readUrl(
    String url, {
    String format = 'csv',
    Map<String, dynamic>? options,
  }) {
    return DataIO.readUrl(url, format: format, options: options);
  }

  /// Creates sample numeric data
  static DataFrame sampleNumeric({int rows = 100, int columns = 5, int? seed}) {
    return DataUtils.createSampleNumeric(
      rows: rows,
      columns: columns,
      seed: seed,
    );
  }

  /// Creates sample mixed data
  static DataFrame sampleMixed({int rows = 100, int? seed}) {
    return DataUtils.createSampleMixed(rows: rows, seed: seed);
  }

  /// Creates time series data
  static DataFrame timeSeries({DateTime? start, int days = 30, int? seed}) {
    return DataUtils.createTimeSeries(start: start, days: days, seed: seed);
  }
}

/// Extension methods for enhanced DataFrame functionality
extension DataFrameExtensions on DataFrame {
  /// Quick statistical summary
  String summary() {
    final buffer = StringBuffer();
    buffer.writeln('DataFrame Summary');
    buffer.writeln('================');
    buffer.writeln('Shape: ${shape[0]} rows × ${shape[1]} columns');
    buffer.writeln('Columns: ${columns.join(', ')}');
    buffer.writeln();
    buffer.writeln('Memory usage: ~${(length * columns.length * 8)} bytes');
    buffer.writeln('Non-null counts:');

    for (final column in columns) {
      final nonNull = this[column].data.where((e) => e != null).length;
      buffer.writeln('  $column: $nonNull non-null');
    }

    return buffer.toString();
  }

  /// Quick visualization helper (returns string representation)
  String plot({String? x, String? y, String kind = 'scatter'}) {
    if (x == null || y == null) {
      return 'Plot requires both x and y columns';
    }

    if (!columns.contains(x) || !columns.contains(y)) {
      return 'Columns $x or $y not found';
    }

    final buffer = StringBuffer();
    buffer.writeln('Plot: $y vs $x ($kind)');
    buffer.writeln('=' * 30);

    // Simple ASCII scatter plot for numeric data
    if (kind == 'scatter') {
      final xData = this[x].data.cast<num>().toList();
      final yData = this[y].data.cast<num>().toList();

      if (xData.isNotEmpty && yData.isNotEmpty) {
        final xMin = xData.reduce(math.min);
        final xMax = xData.reduce(math.max);
        final yMin = yData.reduce(math.min);
        final yMax = yData.reduce(math.max);

        buffer.writeln('X range: $xMin - $xMax');
        buffer.writeln('Y range: $yMin - $yMax');
        buffer.writeln('Points: ${xData.length}');

        // Simple correlation
        final correlation = Statistics.correlationTest(
          Series<num>(
            xData,
            index: List.generate(xData.length, (i) => i.toString()),
          ),
          Series<num>(
            yData,
            index: List.generate(yData.length, (i) => i.toString()),
          ),
        );
        buffer.writeln(
          'Correlation: ${correlation['correlation']?.toStringAsFixed(3)}',
        );
      }
    }

    return buffer.toString();
  }
}

/// Extension methods for Series
extension SeriesExtensions on Series {
  /// String representation for numeric series
  String hist({int bins = 10}) {
    if (dtype != num && dtype != int && dtype != double) {
      return 'Histogram only supports numeric data';
    }

    final numericData = data.cast<num>().toList();
    if (numericData.isEmpty) return 'No numeric data';

    numericData.sort();
    final min = numericData.first;
    final max = numericData.last;
    final range = max - min;
    final binWidth = range / bins;

    final binCounts = List.filled(bins, 0);

    for (final value in numericData) {
      var binIndex = ((value - min) / binWidth).floor();
      if (binIndex >= bins) binIndex = bins - 1;
      binCounts[binIndex]++;
    }

    final buffer = StringBuffer();
    buffer.writeln('Histogram for ${dtype.toString()} Series');
    buffer.writeln('Range: $min - $max');

    final maxCount = binCounts.reduce(math.max);
    for (var i = 0; i < bins; i++) {
      final binStart = min + i * binWidth;
      final binEnd = min + (i + 1) * binWidth;
      final count = binCounts[i];
      final bar = '*' * ((count * 20) ~/ maxCount);

      buffer.writeln(
        '${binStart.toStringAsFixed(1)}-${binEnd.toStringAsFixed(1)}: $count $bar',
      );
    }

    return buffer.toString();
  }
}
