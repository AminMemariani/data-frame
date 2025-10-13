import 'dart:math' as math;
import 'package:collection/collection.dart';

/// A one-dimensional labeled array capable of holding any data type.
/// Similar to pandas Series in Python.
class Series<T> {
  final List<T> _data;
  final List<String> _index;

  /// Creates a new Series with the given data and optional index.
  Series(List<T> data, {List<String>? index})
    : _data = List<T>.from(data),
      _index = index ?? List.generate(data.length, (i) => i.toString());

  /// Creates a Series from a map where keys become the index.
  Series.fromMap(Map<String, T> map)
    : _data = map.values.toList(),
      _index = map.keys.toList();

  /// Creates an empty Series.
  Series.empty() : _data = <T>[], _index = <String>[];

  /// Returns the underlying data as a list.
  List<T> get data => List<T>.unmodifiable(_data);

  /// Returns the index as a list.
  List<String> get index => List<String>.unmodifiable(_index);

  /// Returns the length of the Series.
  int get length => _data.length;

  /// Returns true if the Series is empty.
  bool get isEmpty => _data.isEmpty;

  /// Returns true if the Series is not empty.
  bool get isNotEmpty => _data.isNotEmpty;

  /// Gets the data type of the Series elements.
  Type get dtype => T;

  /// Access element by index position.
  T operator [](int index) => _data[index];

  /// Access element by index label.
  T loc(String label) {
    final position = _index.indexOf(label);
    if (position == -1) {
      throw ArgumentError('Index label "$label" not found');
    }
    return _data[position];
  }

  /// Set element by index position.
  void operator []=(int index, T value) {
    _data[index] = value;
  }

  /// Returns the first n elements.
  Series<T> head([int n = 5]) {
    final endIndex = math.min(n, length);
    return Series<T>(
      _data.sublist(0, endIndex),
      index: _index.sublist(0, endIndex),
    );
  }

  /// Returns the last n elements.
  Series<T> tail([int n = 5]) {
    final startIndex = math.max(0, length - n);
    return Series<T>(
      _data.sublist(startIndex),
      index: _index.sublist(startIndex),
    );
  }

  /// Returns a new Series with the given condition applied.
  Series<T> where(bool Function(T) condition) {
    final filteredData = <T>[];
    final filteredIndex = <String>[];

    for (var i = 0; i < length; i++) {
      if (condition(_data[i])) {
        filteredData.add(_data[i]);
        filteredIndex.add(_index[i]);
      }
    }

    return Series<T>(filteredData, index: filteredIndex);
  }

  /// Maps each element to a new value.
  Series<R> map<R>(R Function(T) transform) {
    return Series<R>(
      _data.map(transform).toList(),
      index: List<String>.from(_index),
    );
  }

  /// Returns a Series with sorted values.
  Series<T> sort([int Function(T, T)? compare]) {
    final pairs = List.generate(length, (i) => MapEntry(_index[i], _data[i]));

    pairs.sort(
      (a, b) =>
          compare?.call(a.value, b.value) ??
          (a.value as Comparable).compareTo(b.value),
    );

    return Series<T>(
      pairs.map((e) => e.value).toList(),
      index: pairs.map((e) => e.key).toList(),
    );
  }

  /// Returns unique values in the Series.
  Series<T> unique() {
    final uniqueData = <T>[];
    final uniqueIndex = <String>[];
    final seen = <T>{};

    for (var i = 0; i < length; i++) {
      if (!seen.contains(_data[i])) {
        seen.add(_data[i]);
        uniqueData.add(_data[i]);
        uniqueIndex.add(_index[i]);
      }
    }

    return Series<T>(uniqueData, index: uniqueIndex);
  }

  /// Returns value counts.
  Map<T, int> valueCounts() {
    final counts = <T, int>{};
    for (final value in _data) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    return counts;
  }

  /// Returns basic statistics for numeric Series.
  Map<String, num> describe() {
    if (T != num && T != int && T != double) {
      throw UnsupportedError('describe() only supports numeric types');
    }

    final numericData = _data.cast<num>();
    final sortedData = numericData.toList()..sort();

    return {
      'count': length,
      'mean': numericData.average,
      'std': _standardDeviation(numericData),
      'min': sortedData.first,
      '25%': _percentile(sortedData, 25),
      '50%': _percentile(sortedData, 50),
      '75%': _percentile(sortedData, 75),
      'max': sortedData.last,
    };
  }

  /// Calculate sum for numeric Series.
  num sum() {
    if (T != num && T != int && T != double) {
      throw UnsupportedError('sum() only supports numeric types');
    }
    return _data.cast<num>().sum;
  }

  /// Calculate mean for numeric Series.
  double mean() {
    if (T != num && T != int && T != double) {
      throw UnsupportedError('mean() only supports numeric types');
    }
    return _data.cast<num>().average;
  }

  /// Calculate standard deviation.
  double std() {
    if (T != num && T != int && T != double) {
      throw UnsupportedError('std() only supports numeric types');
    }
    return _standardDeviation(_data.cast<num>());
  }

  /// Calculate minimum value.
  T min() {
    if (isEmpty) throw StateError('Cannot find min of empty Series');
    return _data.reduce((a, b) => (a as Comparable).compareTo(b) < 0 ? a : b);
  }

  /// Calculate maximum value.
  T max() {
    if (isEmpty) throw StateError('Cannot find max of empty Series');
    return _data.reduce((a, b) => (a as Comparable).compareTo(b) > 0 ? a : b);
  }

  /// Returns null values count.
  int nullCount() {
    return _data.where((element) => element == null).length;
  }

  /// Drops null values.
  Series<T> dropna() {
    final nonNullData = <T>[];
    final nonNullIndex = <String>[];

    for (var i = 0; i < length; i++) {
      if (_data[i] != null) {
        nonNullData.add(_data[i]);
        nonNullIndex.add(_index[i]);
      }
    }

    return Series<T>(nonNullData, index: nonNullIndex);
  }

  /// Fills null values with the given value.
  Series<T> fillna(T value) {
    final filledData = _data.map((e) => e ?? value).toList();
    return Series<T>(filledData, index: List<String>.from(_index));
  }

  /// Returns a string representation of the Series.
  @override
  String toString() {
    if (isEmpty) return 'Empty Series';

    final buffer = StringBuffer();
    final maxIndexWidth = _index.map((e) => e.length).reduce(math.max);
    final maxValueWidth = _data
        .map((e) => e.toString().length)
        .reduce(math.max)
        .clamp(0, 20);

    for (var i = 0; i < math.min(length, 10); i++) {
      final indexStr = _index[i].padLeft(maxIndexWidth);
      final valueStr = _data[i].toString();
      final truncatedValue = valueStr.length > 20
          ? '${valueStr.substring(0, 17)}...'
          : valueStr.padRight(maxValueWidth);

      buffer.writeln('$indexStr    $truncatedValue');
    }

    if (length > 10) {
      buffer.writeln('... (${length - 10} more rows)');
    }

    buffer.writeln('dtype: $T');
    return buffer.toString();
  }

  /// Converts Series to a Map.
  Map<String, T> toMap() {
    return Map.fromIterables(_index, _data);
  }

  /// Converts Series to a List.
  List<T> toList() => List<T>.from(_data);

  // Helper methods
  double _standardDeviation(Iterable<num> values) {
    if (values.isEmpty) return 0.0;
    final mean = values.average;
    final variance =
        values.map((x) => math.pow(x - mean, 2)).sum / values.length;
    return math.sqrt(variance);
  }

  num _percentile(List<num> sortedData, int percentile) {
    final index = (percentile / 100) * (sortedData.length - 1);
    if (index == index.floor()) {
      return sortedData[index.floor()];
    } else {
      final lower = sortedData[index.floor()];
      final upper = sortedData[index.ceil()];
      return lower + (upper - lower) * (index - index.floor());
    }
  }
}
