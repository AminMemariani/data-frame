import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'series.dart';

/// A two-dimensional labeled data structure with columns of potentially different types.
/// Similar to pandas DataFrame in Python.
class DataFrame {
  final Map<String, Series<dynamic>> _columns;
  final List<String> _index;

  /// Creates a new DataFrame with the given columns and optional index.
  DataFrame(Map<String, List<dynamic>> data, {List<String>? index})
    : _columns = {},
      _index = index ?? [] {
    if (data.isEmpty) {
      _index.clear();
      return;
    }

    // Validate all columns have the same length
    final firstColumnLength = data.values.first.length;
    for (final entry in data.entries) {
      if (entry.value.length != firstColumnLength) {
        throw ArgumentError(
          'All columns must have the same length. '
          'Column "${entry.key}" has length ${entry.value.length}, '
          'expected $firstColumnLength',
        );
      }
    }

    // Set up index
    if (_index.isEmpty) {
      _index.addAll(List.generate(firstColumnLength, (i) => i.toString()));
    } else if (_index.length != firstColumnLength) {
      throw ArgumentError(
        'Index length (${_index.length}) must match data length ($firstColumnLength)',
      );
    }

    // Create Series for each column
    for (final entry in data.entries) {
      _columns[entry.key] = Series<dynamic>(
        entry.value,
        index: List<String>.from(_index),
      );
    }
  }

  /// Creates a DataFrame from a list of maps (records).
  DataFrame.fromRecords(
    List<Map<String, dynamic>> records, {
    List<String>? index,
  }) : _columns = {},
       _index = [] {
    if (records.isEmpty) return;

    final columns = records.first.keys.toSet();
    for (final record in records.skip(1)) {
      columns.addAll(record.keys);
    }

    final data = <String, List<dynamic>>{};
    for (final column in columns) {
      data[column] = records.map((record) => record[column]).toList();
    }

    final df = DataFrame(data, index: index);
    _columns.addAll(df._columns);
    _index.addAll(df._index);
  }

  /// Creates an empty DataFrame.
  DataFrame.empty() : _columns = {}, _index = [];

  /// Returns the column names.
  List<String> get columns => _columns.keys.toList();

  /// Returns the index.
  List<String> get index => List<String>.unmodifiable(_index);

  /// Returns the shape as [rows, columns].
  List<int> get shape => [_index.length, _columns.length];

  /// Returns the number of rows.
  int get length => _index.length;

  /// Returns true if the DataFrame is empty.
  bool get isEmpty => _columns.isEmpty || _index.isEmpty;

  /// Returns true if the DataFrame is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Access a column by name.
  Series<dynamic> operator [](String columnName) {
    if (!_columns.containsKey(columnName)) {
      throw ArgumentError('Column "$columnName" not found');
    }
    return _columns[columnName]!;
  }

  /// Set a column.
  void operator []=(String columnName, Series<dynamic> series) {
    if (series.length != length && isNotEmpty) {
      throw ArgumentError(
        'Series length (${series.length}) must match DataFrame length ($length)',
      );
    }
    _columns[columnName] = series;
  }

  /// Access a row by index position.
  Map<String, dynamic> iloc(int index) {
    if (index < 0 || index >= length) {
      throw RangeError('Index $index out of range [0, $length)');
    }

    final result = <String, dynamic>{};
    for (final entry in _columns.entries) {
      result[entry.key] = entry.value[index];
    }
    return result;
  }

  /// Access a row by index label.
  Map<String, dynamic> loc(String label) {
    final position = _index.indexOf(label);
    if (position == -1) {
      throw ArgumentError('Index label "$label" not found');
    }
    return iloc(position);
  }

  /// Returns the first n rows.
  DataFrame head([int n = 5]) {
    final endIndex = math.min(n, length);
    final data = <String, List<dynamic>>{};

    for (final entry in _columns.entries) {
      data[entry.key] = entry.value.data.sublist(0, endIndex);
    }

    return DataFrame(data, index: _index.sublist(0, endIndex));
  }

  /// Returns the last n rows.
  DataFrame tail([int n = 5]) {
    final startIndex = math.max(0, length - n);
    final data = <String, List<dynamic>>{};

    for (final entry in _columns.entries) {
      data[entry.key] = entry.value.data.sublist(startIndex);
    }

    return DataFrame(data, index: _index.sublist(startIndex));
  }

  /// Selects columns by name.
  DataFrame select(List<String> columnNames) {
    final data = <String, List<dynamic>>{};

    for (final columnName in columnNames) {
      if (!_columns.containsKey(columnName)) {
        throw ArgumentError('Column "$columnName" not found');
      }
      data[columnName] = _columns[columnName]!.data;
    }

    return DataFrame(data, index: List<String>.from(_index));
  }

  /// Filters rows based on a condition.
  DataFrame where(bool Function(Map<String, dynamic>) condition) {
    final filteredIndices = <int>[];

    for (var i = 0; i < length; i++) {
      final row = iloc(i);
      if (condition(row)) {
        filteredIndices.add(i);
      }
    }

    final data = <String, List<dynamic>>{};
    final newIndex = <String>[];

    for (final entry in _columns.entries) {
      data[entry.key] = filteredIndices.map((i) => entry.value[i]).toList();
    }

    for (final i in filteredIndices) {
      newIndex.add(_index[i]);
    }

    return DataFrame(data, index: newIndex);
  }

  /// Sorts the DataFrame by one or more columns.
  DataFrame sortBy(List<String> columnNames, {bool ascending = true}) {
    final indices = List.generate(length, (i) => i);

    indices.sort((i, j) {
      for (final columnName in columnNames) {
        if (!_columns.containsKey(columnName)) {
          throw ArgumentError('Column "$columnName" not found');
        }

        final column = _columns[columnName]!;
        final valueA = column[i];
        final valueB = column[j];

        int comparison;
        if (valueA == null && valueB == null) {
          comparison = 0;
        } else if (valueA == null) {
          comparison = ascending ? -1 : 1;
        } else if (valueB == null) {
          comparison = ascending ? 1 : -1;
        } else {
          comparison = (valueA as Comparable).compareTo(valueB);
        }

        if (comparison != 0) {
          return ascending ? comparison : -comparison;
        }
      }
      return 0;
    });

    final data = <String, List<dynamic>>{};
    final newIndex = <String>[];

    for (final entry in _columns.entries) {
      data[entry.key] = indices.map((i) => entry.value[i]).toList();
    }

    for (final i in indices) {
      newIndex.add(_index[i]);
    }

    return DataFrame(data, index: newIndex);
  }

  /// Groups the DataFrame by one or more columns.
  Map<dynamic, DataFrame> groupBy(List<String> columnNames) {
    final groups = <String, List<int>>{};

    for (var i = 0; i < length; i++) {
      final keyValues = columnNames.map((col) => _columns[col]![i]).toList();
      final key = keyValues.join('|');
      groups.putIfAbsent(key, () => []).add(i);
    }

    final result = <dynamic, DataFrame>{};

    for (final entry in groups.entries) {
      final indices = entry.value;
      final data = <String, List<dynamic>>{};
      final newIndex = <String>[];

      for (final column in _columns.entries) {
        data[column.key] = indices.map((i) => column.value[i]).toList();
      }

      for (final i in indices) {
        newIndex.add(_index[i]);
      }

      // Create the actual key from the first row of the group
      final firstIndex = indices.first;
      final keyValue = columnNames.length == 1
          ? _columns[columnNames.first]![firstIndex]
          : columnNames.map((col) => _columns[col]![firstIndex]).toList();

      result[keyValue] = DataFrame(data, index: newIndex);
    }

    return result;
  }

  /// Adds a new column.
  void addColumn(String name, Series<dynamic> series) {
    if (series.length != length && isNotEmpty) {
      throw ArgumentError(
        'Series length (${series.length}) must match DataFrame length ($length)',
      );
    }
    _columns[name] = series;
  }

  /// Removes a column.
  void removeColumn(String name) {
    _columns.remove(name);
  }

  /// Drops rows with null values.
  DataFrame dropna({List<String>? subset}) {
    final columnsToCheck = subset ?? columns;

    return where((row) {
      for (final col in columnsToCheck) {
        if (row[col] == null) return false;
      }
      return true;
    });
  }

  /// Fills null values.
  DataFrame fillna(dynamic value, {List<String>? subset}) {
    final columnsToFill = subset ?? columns;
    final data = <String, List<dynamic>>{};

    for (final entry in _columns.entries) {
      if (columnsToFill.contains(entry.key)) {
        data[entry.key] = entry.value.data.map((e) => e ?? value).toList();
      } else {
        data[entry.key] = entry.value.data;
      }
    }

    return DataFrame(data, index: List<String>.from(_index));
  }

  /// Returns basic information about the DataFrame.
  Map<String, dynamic> info() {
    final nonNullCounts = <String, int>{};
    final dtypes = <String, Type>{};

    for (final entry in _columns.entries) {
      nonNullCounts[entry.key] = entry.value.data
          .where((e) => e != null)
          .length;
      dtypes[entry.key] = entry.value.dtype;
    }

    return {
      'shape': shape,
      'columns': columns,
      'non_null_counts': nonNullCounts,
      'dtypes': dtypes,
    };
  }

  /// Returns descriptive statistics for numeric columns.
  DataFrame describe() {
    final numericColumns = <String>[];
    for (final entry in _columns.entries) {
      final sample = entry.value.data.firstWhereOrNull((e) => e != null);
      if (sample is num) {
        numericColumns.add(entry.key);
      }
    }

    if (numericColumns.isEmpty) {
      return DataFrame.empty();
    }

    final stats = ['count', 'mean', 'std', 'min', '25%', '50%', '75%', 'max'];
    final data = <String, List<dynamic>>{};

    for (final col in numericColumns) {
      final series = _columns[col]!
          .where((value) => value is num)
          .map((value) => value as num);
      if (series.isEmpty) continue;

      final description = series.describe();
      data[col] = stats.map((stat) => description[stat]).toList();
    }

    return DataFrame(data, index: stats);
  }

  /// Applies an aggregation function to numeric columns.
  Map<String, dynamic> agg(
    dynamic Function(Series<dynamic>) func, {
    List<String>? subset,
  }) {
    final columnsToProcess = subset ?? columns;
    final result = <String, dynamic>{};

    for (final columnName in columnsToProcess) {
      if (_columns.containsKey(columnName)) {
        try {
          result[columnName] = func(_columns[columnName]!);
        } catch (e) {
          // Skip columns that can't be processed
        }
      }
    }

    return result;
  }

  /// Joins with another DataFrame.
  DataFrame join(DataFrame other, {String on = '', String how = 'inner'}) {
    if (on.isEmpty) {
      throw ArgumentError('Must specify column to join on');
    }

    if (!columns.contains(on) || !other.columns.contains(on)) {
      throw ArgumentError('Join column "$on" not found in both DataFrames');
    }

    final result = <String, List<dynamic>>{};
    final newIndex = <String>[];

    // Initialize result columns
    for (final col in columns) {
      result[col] = <dynamic>[];
    }
    for (final col in other.columns) {
      if (col != on) {
        // Avoid duplicate join column
        result['${col}_right'] = <dynamic>[];
      }
    }

    switch (how.toLowerCase()) {
      case 'inner':
        _performInnerJoin(other, on, result, newIndex);
        break;
      case 'left':
        _performLeftJoin(other, on, result, newIndex);
        break;
      case 'right':
        _performRightJoin(other, on, result, newIndex);
        break;
      default:
        throw ArgumentError('Unsupported join type: $how');
    }

    return DataFrame(result, index: newIndex);
  }

  void _performInnerJoin(
    DataFrame other,
    String on,
    Map<String, List<dynamic>> result,
    List<String> newIndex,
  ) {
    for (var i = 0; i < length; i++) {
      final leftValue = _columns[on]![i];
      for (var j = 0; j < other.length; j++) {
        final rightValue = other._columns[on]![j];
        if (leftValue == rightValue) {
          // Add left row data
          for (final col in columns) {
            result[col]!.add(_columns[col]![i]);
          }
          // Add right row data (excluding join column)
          for (final col in other.columns) {
            if (col != on) {
              result['${col}_right']!.add(other._columns[col]![j]);
            }
          }
          newIndex.add('${_index[i]}_${other._index[j]}');
        }
      }
    }
  }

  void _performLeftJoin(
    DataFrame other,
    String on,
    Map<String, List<dynamic>> result,
    List<String> newIndex,
  ) {
    for (var i = 0; i < length; i++) {
      final leftValue = _columns[on]![i];
      bool found = false;

      for (var j = 0; j < other.length; j++) {
        final rightValue = other._columns[on]![j];
        if (leftValue == rightValue) {
          found = true;
          // Add left row data
          for (final col in columns) {
            result[col]!.add(_columns[col]![i]);
          }
          // Add right row data
          for (final col in other.columns) {
            if (col != on) {
              result['${col}_right']!.add(other._columns[col]![j]);
            }
          }
          newIndex.add('${_index[i]}_${other._index[j]}');
        }
      }

      if (!found) {
        // Add left row with null for right columns
        for (final col in columns) {
          result[col]!.add(_columns[col]![i]);
        }
        for (final col in other.columns) {
          if (col != on) {
            result['${col}_right']!.add(null);
          }
        }
        newIndex.add(_index[i]);
      }
    }
  }

  void _performRightJoin(
    DataFrame other,
    String on,
    Map<String, List<dynamic>> result,
    List<String> newIndex,
  ) {
    for (var j = 0; j < other.length; j++) {
      final rightValue = other._columns[on]![j];
      bool found = false;

      for (var i = 0; i < length; i++) {
        final leftValue = _columns[on]![i];
        if (leftValue == rightValue) {
          found = true;
          // Add left row data
          for (final col in columns) {
            result[col]!.add(_columns[col]![i]);
          }
          // Add right row data
          for (final col in other.columns) {
            if (col != on) {
              result['${col}_right']!.add(other._columns[col]![j]);
            }
          }
          newIndex.add('${_index[i]}_${other._index[j]}');
        }
      }

      if (!found) {
        // Add right row with null for left columns
        for (final col in columns) {
          result[col]!.add(null);
        }
        for (final col in other.columns) {
          if (col != on) {
            result['${col}_right']!.add(other._columns[col]![j]);
          }
        }
        newIndex.add(other._index[j]);
      }
    }
  }

  /// Converts DataFrame to a list of maps.
  List<Map<String, dynamic>> toRecords() {
    final records = <Map<String, dynamic>>[];
    for (var i = 0; i < length; i++) {
      records.add(iloc(i));
    }
    return records;
  }

  /// Converts DataFrame to a CSV string.
  String toCsv({String separator = ','}) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(columns.join(separator));

    // Data rows
    for (var i = 0; i < length; i++) {
      final row = columns
          .map((col) => _columns[col]![i]?.toString() ?? '')
          .join(separator);
      buffer.writeln(row);
    }

    return buffer.toString();
  }

  @override
  String toString() {
    if (isEmpty) return 'Empty DataFrame';

    final buffer = StringBuffer();
    final displayRows = math.min(length, 10);
    final displayCols = math.min(columns.length, 5);

    // Calculate column widths
    final colWidths = <String, int>{};
    final displayColumns = columns.take(displayCols).toList();

    for (final col in displayColumns) {
      colWidths[col] = math.max(
        col.length,
        _columns[col]!.data
            .take(displayRows)
            .map((e) => e.toString().length)
            .reduce(math.max)
            .clamp(0, 20),
      );
    }

    // Header
    final indexWidth = _index
        .take(displayRows)
        .map((e) => e.length)
        .reduce(math.max);
    buffer.write(' '.padLeft(indexWidth + 2));
    for (final col in displayColumns) {
      buffer.write(col.padRight(colWidths[col]! + 2));
    }
    if (columns.length > displayCols) {
      buffer.write('...');
    }
    buffer.writeln();

    // Data rows
    for (var i = 0; i < displayRows; i++) {
      buffer.write(_index[i].padLeft(indexWidth));
      buffer.write('  ');

      for (final col in displayColumns) {
        final value = _columns[col]![i]?.toString() ?? 'null';
        final truncated = value.length > 20
            ? '${value.substring(0, 17)}...'
            : value;
        buffer.write(truncated.padRight(colWidths[col]! + 2));
      }

      if (columns.length > displayCols) {
        buffer.write('...');
      }
      buffer.writeln();
    }

    if (length > displayRows) {
      buffer.writeln('... (${length - displayRows} more rows)');
    }

    buffer.writeln();
    buffer.writeln('[$length rows x ${columns.length} columns]');

    return buffer.toString();
  }
}
