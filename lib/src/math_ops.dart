import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'dataframe.dart';
import 'series.dart';

/// Mathematical operations and aggregation functions for data analysis.
class MathOps {
  /// Calculates correlation matrix for numeric columns in a DataFrame.
  static DataFrame corr(DataFrame df, {String method = 'pearson'}) {
    final numericColumns = <String>[];
    for (final column in df.columns) {
      final sample = df[column].data.firstWhereOrNull((e) => e != null);
      if (sample is num) {
        numericColumns.add(column);
      }
    }

    if (numericColumns.isEmpty) {
      throw ArgumentError('No numeric columns found for correlation');
    }

    final correlationData = <String, List<double>>{};

    for (final col1 in numericColumns) {
      final correlations = <double>[];
      for (final col2 in numericColumns) {
        final correlation = _calculateCorrelation(
          df[col1].data.whereType<num>().toList(),
          df[col2].data.whereType<num>().toList(),
          method: method,
        );
        correlations.add(correlation);
      }
      correlationData[col1] = correlations;
    }

    return DataFrame(
      correlationData.cast<String, List<dynamic>>(),
      index: numericColumns,
    );
  }

  /// Calculates covariance matrix for numeric columns in a DataFrame.
  static DataFrame cov(DataFrame df) {
    final numericColumns = <String>[];
    for (final column in df.columns) {
      final sample = df[column].data.firstWhereOrNull((e) => e != null);
      if (sample is num) {
        numericColumns.add(column);
      }
    }

    if (numericColumns.isEmpty) {
      throw ArgumentError('No numeric columns found for covariance');
    }

    final covarianceData = <String, List<double>>{};

    for (final col1 in numericColumns) {
      final covariances = <double>[];
      for (final col2 in numericColumns) {
        final covariance = _calculateCovariance(
          df[col1].data.whereType<num>().toList(),
          df[col2].data.whereType<num>().toList(),
        );
        covariances.add(covariance);
      }
      covarianceData[col1] = covariances;
    }

    return DataFrame(
      covarianceData.cast<String, List<dynamic>>(),
      index: numericColumns,
    );
  }

  /// Performs element-wise operations between DataFrames or DataFrame and scalar.
  static DataFrame add(DataFrame df1, dynamic df2) {
    return _performElementWiseOperation(df1, df2, (a, b) => a + b);
  }

  static DataFrame subtract(DataFrame df1, dynamic df2) {
    return _performElementWiseOperation(df1, df2, (a, b) => a - b);
  }

  static DataFrame multiply(DataFrame df1, dynamic df2) {
    return _performElementWiseOperation(df1, df2, (a, b) => a * b);
  }

  static DataFrame divide(DataFrame df1, dynamic df2) {
    return _performElementWiseOperation(
      df1,
      df2,
      (a, b) => b != 0 ? a / b : double.nan,
    );
  }

  static DataFrame power(DataFrame df1, dynamic df2) {
    return _performElementWiseOperation(
      df1,
      df2,
      (a, b) => math.pow(a.toDouble(), b.toDouble()),
    );
  }

  /// Applies mathematical functions to numeric columns.
  static DataFrame abs(DataFrame df) {
    return _applyMathFunction(df, (x) => x.abs());
  }

  static DataFrame sqrt(DataFrame df) {
    return _applyMathFunction(df, (x) => math.sqrt(x.toDouble()));
  }

  static DataFrame log(DataFrame df, {double base = math.e}) {
    return _applyMathFunction(
      df,
      (x) => math.log(x.toDouble()) / math.log(base),
    );
  }

  static DataFrame exp(DataFrame df) {
    return _applyMathFunction(df, (x) => math.exp(x.toDouble()));
  }

  static DataFrame sin(DataFrame df) {
    return _applyMathFunction(df, (x) => math.sin(x.toDouble()));
  }

  static DataFrame cos(DataFrame df) {
    return _applyMathFunction(df, (x) => math.cos(x.toDouble()));
  }

  static DataFrame tan(DataFrame df) {
    return _applyMathFunction(df, (x) => math.tan(x.toDouble()));
  }

  /// Calculates rolling statistics.
  static DataFrame rollingMean(DataFrame df, int window, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final rollingMeans = <double>[];

      for (var i = 0; i < values.length; i++) {
        if (i < window - 1) {
          rollingMeans.add(double.nan);
        } else {
          final windowValues = values.sublist(i - window + 1, i + 1);
          final mean = windowValues.average;
          rollingMeans.add(mean);
        }
      }

      result[col] = rollingMeans;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  static DataFrame rollingSum(DataFrame df, int window, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final rollingSums = <double>[];

      for (var i = 0; i < values.length; i++) {
        if (i < window - 1) {
          rollingSums.add(double.nan);
        } else {
          final windowValues = values.sublist(i - window + 1, i + 1);
          final sum = windowValues.sum;
          rollingSums.add(sum.toDouble());
        }
      }

      result[col] = rollingSums;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  static DataFrame rollingStd(DataFrame df, int window, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final rollingStds = <double>[];

      for (var i = 0; i < values.length; i++) {
        if (i < window - 1) {
          rollingStds.add(double.nan);
        } else {
          final windowValues = values.sublist(i - window + 1, i + 1);
          final mean = windowValues.average;
          final variance =
              windowValues.map((x) => math.pow(x - mean, 2)).sum /
              windowValues.length;
          final std = math.sqrt(variance);
          rollingStds.add(std);
        }
      }

      result[col] = rollingStds;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  /// Calculates cumulative statistics.
  static DataFrame cumSum(DataFrame df, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final cumSums = <double>[];
      double runningSum = 0;

      for (final value in values) {
        runningSum += value;
        cumSums.add(runningSum);
      }

      result[col] = cumSums;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  static DataFrame cumProd(DataFrame df, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final cumProds = <double>[];
      double runningProd = 1;

      for (final value in values) {
        runningProd *= value;
        cumProds.add(runningProd);
      }

      result[col] = cumProds;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  /// Calculates percentage change between consecutive values.
  static DataFrame pctChange(DataFrame df, {int periods = 1, String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final pctChanges = <double>[];

      for (var i = 0; i < values.length; i++) {
        if (i < periods) {
          pctChanges.add(double.nan);
        } else {
          final current = values[i];
          final previous = values[i - periods];
          if (previous != 0) {
            pctChanges.add((current - previous) / previous);
          } else {
            pctChanges.add(double.nan);
          }
        }
      }

      result[col] = pctChanges;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  /// Calculates differences between consecutive values.
  static DataFrame diff(DataFrame df, {int periods = 1, String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<double>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final values = series.data.cast<num>().toList();
      final diffs = <double>[];

      for (var i = 0; i < values.length; i++) {
        if (i < periods) {
          diffs.add(double.nan);
        } else {
          final current = values[i];
          final previous = values[i - periods];
          diffs.add((current - previous).toDouble());
        }
      }

      result[col] = diffs;
    }

    return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
  }

  /// Clips values to specified bounds.
  static DataFrame clip(
    DataFrame df, {
    num? lower,
    num? upper,
    String? column,
  }) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<dynamic>>{};

    for (final col in columnsToProcess) {
      final series = df[col];
      final clippedValues = series.data.map((value) {
        if (value is! num) return value;

        num clipped = value;
        if (lower != null && clipped < lower) clipped = lower;
        if (upper != null && clipped > upper) clipped = upper;
        return clipped;
      }).toList();

      result[col] = clippedValues;
    }

    return DataFrame(result, index: df.index);
  }

  /// Rounds numeric values to specified decimal places.
  static DataFrame round(DataFrame df, int decimals, {String? column}) {
    final columnsToProcess = column != null ? [column] : df.columns;
    final result = <String, List<dynamic>>{};
    final multiplier = math.pow(10, decimals);

    for (final col in columnsToProcess) {
      final series = df[col];
      final roundedValues = series.data.map((value) {
        if (value is! num) return value;
        return (value * multiplier).round() / multiplier;
      }).toList();

      result[col] = roundedValues;
    }

    return DataFrame(result, index: df.index);
  }

  // Helper methods
  static double _calculateCorrelation(
    List<num> x,
    List<num> y, {
    String method = 'pearson',
  }) {
    if (x.length != y.length || x.isEmpty) {
      return double.nan;
    }

    switch (method.toLowerCase()) {
      case 'pearson':
        return _pearsonCorrelation(x, y);
      case 'spearman':
        return _spearmanCorrelation(x, y);
      default:
        throw ArgumentError('Unsupported correlation method: $method');
    }
  }

  static double _pearsonCorrelation(List<num> x, List<num> y) {
    final n = x.length;
    if (n == 0) return double.nan;

    final meanX = x.average;
    final meanY = y.average;

    double numerator = 0;
    double sumSqX = 0;
    double sumSqY = 0;

    for (var i = 0; i < n; i++) {
      final dx = x[i] - meanX;
      final dy = y[i] - meanY;
      numerator += dx * dy;
      sumSqX += dx * dx;
      sumSqY += dy * dy;
    }

    final denominator = math.sqrt(sumSqX * sumSqY);
    return denominator != 0 ? numerator / denominator : double.nan;
  }

  static double _spearmanCorrelation(List<num> x, List<num> y) {
    final rankedX = _rankData(x);
    final rankedY = _rankData(y);
    return _pearsonCorrelation(rankedX, rankedY);
  }

  static List<double> _rankData(List<num> data) {
    final indexed = data.asMap().entries.toList();
    indexed.sort((a, b) => a.value.compareTo(b.value));

    final ranks = List<double>.filled(data.length, 0);
    var currentRank = 1.0;

    for (var i = 0; i < indexed.length; i++) {
      var tieCount = 1;
      final currentValue = indexed[i].value;

      // Count ties
      while (i + tieCount < indexed.length &&
          indexed[i + tieCount].value == currentValue) {
        tieCount++;
      }

      // Assign average rank to tied values
      final averageRank = currentRank + (tieCount - 1) / 2;
      for (var j = 0; j < tieCount; j++) {
        ranks[indexed[i + j].key] = averageRank;
      }

      currentRank += tieCount;
      i += tieCount - 1;
    }

    return ranks;
  }

  static double _calculateCovariance(List<num> x, List<num> y) {
    if (x.length != y.length || x.isEmpty) {
      return double.nan;
    }

    final n = x.length;
    final meanX = x.average;
    final meanY = y.average;

    double covariance = 0;
    for (var i = 0; i < n; i++) {
      covariance += (x[i] - meanX) * (y[i] - meanY);
    }

    return covariance / (n - 1);
  }

  static DataFrame _performElementWiseOperation(
    DataFrame df1,
    dynamic df2,
    dynamic Function(dynamic, dynamic) operation,
  ) {
    final result = <String, List<dynamic>>{};

    if (df2 is DataFrame) {
      // DataFrame-DataFrame operation
      final commonColumns = df1.columns.toSet().intersection(
        df2.columns.toSet(),
      );

      for (final col in commonColumns) {
        final values1 = df1[col].data;
        final values2 = df2[col].data;
        final resultValues = <dynamic>[];

        final length = math.min(values1.length, values2.length);
        for (var i = 0; i < length; i++) {
          if (values1[i] is num && values2[i] is num) {
            resultValues.add(operation(values1[i], values2[i]));
          } else {
            resultValues.add(null);
          }
        }

        result[col] = resultValues;
      }
    } else if (df2 is num) {
      // DataFrame-scalar operation
      for (final col in df1.columns) {
        final values = df1[col].data;
        final resultValues = values.map((value) {
          if (value is num) {
            return operation(value, df2);
          }
          return null;
        }).toList();

        result[col] = resultValues;
      }
    } else {
      throw ArgumentError(
        'Unsupported operation between DataFrame and ${df2.runtimeType}',
      );
    }

    return DataFrame(result, index: df1.index);
  }

  static DataFrame _applyMathFunction(
    DataFrame df,
    dynamic Function(num) func,
  ) {
    final result = <String, List<dynamic>>{};

    for (final col in df.columns) {
      final series = df[col];
      final resultValues = series.data.map((value) {
        if (value is num) {
          return func(value);
        }
        return null;
      }).toList();

      result[col] = resultValues;
    }

    return DataFrame(result, index: df.index);
  }
}

/// Extended mathematical operations for Series.
extension SeriesMathOps on Series {
  /// Calculates correlation with another Series.
  double corr(Series other, {String method = 'pearson'}) {
    return MathOps._calculateCorrelation(
      data.whereType<num>().toList(),
      other.data.whereType<num>().toList(),
      method: method,
    );
  }

  /// Calculates covariance with another Series.
  double cov(Series other) {
    return MathOps._calculateCovariance(
      data.whereType<num>().toList(),
      other.data.whereType<num>().toList(),
    );
  }

  /// Element-wise addition.
  Series<num> operator +(dynamic other) {
    if (other is num) {
      return map((value) => (value as num) + other);
    } else if (other is Series) {
      final result = <num>[];
      final length = math.min(data.length, other.data.length);
      for (var i = 0; i < length; i++) {
        result.add((data[i] as num) + (other.data[i] as num));
      }
      return Series<num>(result, index: index.take(length).toList());
    }
    throw ArgumentError('Unsupported operation');
  }

  /// Element-wise subtraction.
  Series<num> operator -(dynamic other) {
    if (other is num) {
      return map((value) => (value as num) - other);
    } else if (other is Series) {
      final result = <num>[];
      final length = math.min(data.length, other.data.length);
      for (var i = 0; i < length; i++) {
        result.add((data[i] as num) - (other.data[i] as num));
      }
      return Series<num>(result, index: index.take(length).toList());
    }
    throw ArgumentError('Unsupported operation');
  }

  /// Element-wise multiplication.
  Series<num> operator *(dynamic other) {
    if (other is num) {
      return map((value) => (value as num) * other);
    } else if (other is Series) {
      final result = <num>[];
      final length = math.min(data.length, other.data.length);
      for (var i = 0; i < length; i++) {
        result.add((data[i] as num) * (other.data[i] as num));
      }
      return Series<num>(result, index: index.take(length).toList());
    }
    throw ArgumentError('Unsupported operation');
  }

  /// Element-wise division.
  Series<num> operator /(dynamic other) {
    if (other is num) {
      return map((value) => (value as num) / other);
    } else if (other is Series) {
      final result = <num>[];
      final length = math.min(data.length, other.data.length);
      for (var i = 0; i < length; i++) {
        final divisor = other.data[i] as num;
        result.add(divisor != 0 ? (data[i] as num) / divisor : double.nan);
      }
      return Series<num>(result, index: index.take(length).toList());
    }
    throw ArgumentError('Unsupported operation');
  }
}
