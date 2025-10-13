import 'dart:io';
import 'dart:math' as math;
import 'package:dadata/dadata.dart';
import 'package:test/test.dart';

void main() {
  group('Series Tests', () {
    test('creates series with data and index', () {
      final series = Series<int>(
        [1, 2, 3, 4, 5],
        index: ['a', 'b', 'c', 'd', 'e'],
      );
      expect(series.length, equals(5));
      expect(series[0], equals(1));
      expect(series.loc('a'), equals(1));
      expect(series.index, equals(['a', 'b', 'c', 'd', 'e']));
    });

    test('creates series from map', () {
      final series = Series<String>.fromMap({
        'a': 'apple',
        'b': 'banana',
        'c': 'cherry',
      });
      expect(series.length, equals(3));
      expect(series.loc('a'), equals('apple'));
    });

    test('performs basic statistics', () {
      final series = Series<num>([1, 2, 3, 4, 5]);
      expect(series.sum(), equals(15));
      expect(series.mean(), equals(3.0));
      expect(series.min(), equals(1));
      expect(series.max(), equals(5));
    });

    test('filters series', () {
      final series = Series<int>([1, 2, 3, 4, 5]);
      final filtered = series.where((x) => x > 3);
      expect(filtered.data, equals([4, 5]));
    });

    test('maps series', () {
      final series = Series<int>([1, 2, 3]);
      final mapped = series.map<int>((x) => x * 2);
      expect(mapped.data, equals([2, 4, 6]));
    });

    test('sorts series', () {
      final series = Series<int>([3, 1, 4, 1, 5]);
      final sorted = series.sort();
      expect(sorted.data, equals([1, 1, 3, 4, 5]));
    });

    test('gets unique values', () {
      final series = Series<int>([1, 2, 2, 3, 3, 3]);
      final unique = series.unique();
      expect(unique.data, equals([1, 2, 3]));
    });

    test('counts values', () {
      final series = Series<String>(['a', 'b', 'a', 'c', 'b', 'a']);
      final counts = series.valueCounts();
      expect(counts['a'], equals(3));
      expect(counts['b'], equals(2));
      expect(counts['c'], equals(1));
    });

    test('handles null values', () {
      final series = Series<int?>([1, null, 3, null, 5]);
      expect(series.nullCount(), equals(2));

      final dropped = series.dropna();
      expect(dropped.data, equals([1, 3, 5]));

      final filled = series.fillna(0);
      expect(filled.data, equals([1, 0, 3, 0, 5]));
    });
  });

  group('DataFrame Tests', () {
    test('creates dataframe from map', () {
      final df = DataFrame({
        'name': ['Alice', 'Bob', 'Charlie'],
        'age': [25, 30, 35],
        'city': ['NYC', 'LA', 'Chicago'],
      });

      expect(df.length, equals(3));
      expect(df.columns, equals(['name', 'age', 'city']));
      expect(df['name'][0], equals('Alice'));
      expect(df.shape, equals([3, 3]));
    });

    test('creates dataframe from records', () {
      final records = [
        {'name': 'Alice', 'age': 25},
        {'name': 'Bob', 'age': 30},
        {'name': 'Charlie', 'age': 35},
      ];
      final df = DataFrame.fromRecords(records);

      expect(df.length, equals(3));
      expect(df['name'][1], equals('Bob'));
    });

    test('accesses rows by position and label', () {
      final df = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });

      final row = df.iloc(1);
      expect(row['a'], equals(2));
      expect(row['b'], equals(5));
    });

    test('selects columns', () {
      final df = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
        'c': [7, 8, 9],
      });

      final selected = df.select(['a', 'c']);
      expect(selected.columns, equals(['a', 'c']));
      expect(selected.length, equals(3));
    });

    test('filters dataframe', () {
      final df = DataFrame({
        'name': ['Alice', 'Bob', 'Charlie'],
        'age': [25, 30, 35],
      });

      final filtered = df.where((row) => row['age'] >= 30);
      expect(filtered.length, equals(2));
      expect(filtered['name'].data, equals(['Bob', 'Charlie']));
    });

    test('sorts dataframe', () {
      final df = DataFrame({
        'name': ['Alice', 'Charlie', 'Bob'],
        'age': [25, 35, 30],
      });

      final sorted = df.sortBy(['age']);
      expect(sorted['name'].data, equals(['Alice', 'Bob', 'Charlie']));
    });

    test('groups dataframe', () {
      final df = DataFrame({
        'category': ['A', 'B', 'A', 'B', 'A'],
        'value': [1, 2, 3, 4, 5],
      });

      final groups = df.groupBy(['category']);
      expect(groups.keys.length, equals(2));
      expect(groups['A']!.length, equals(3));
      expect(groups['B']!.length, equals(2));
    });

    test('adds and removes columns', () {
      final df = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });

      df.addColumn('c', Series<int>([7, 8, 9]));
      expect(df.columns.length, equals(3));

      df.removeColumn('b');
      expect(df.columns, equals(['a', 'c']));
    });

    test('handles null values', () {
      final df = DataFrame({
        'a': [1, null, 3],
        'b': [null, 5, 6],
      });

      final dropped = df.dropna();
      expect(dropped.length, equals(1));

      final filled = df.fillna(0);
      expect(filled['a'][1], equals(0));
      expect(filled['b'][0], equals(0));
    });

    test('joins dataframes', () {
      final df1 = DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie'],
      });

      final df2 = DataFrame({
        'id': [1, 2, 4],
        'age': [25, 30, 35],
      });

      final joined = df1.join(df2, on: 'id');
      expect(joined.length, equals(2)); // Inner join
      expect(joined.columns.contains('age_right'), isTrue);
    });

    test('describes dataframe', () {
      final df = DataFrame({
        'a': [1, 2, 3, 4, 5],
        'b': [1.1, 2.2, 3.3, 4.4, 5.5],
      });

      final description = df.describe();
      expect(description.columns.contains('a'), isTrue);
      expect(description.columns.contains('b'), isTrue);
    });
  });

  group('Mathematical Operations Tests', () {
    test('calculates correlation matrix', () {
      final df = DataFrame({
        'a': [1, 2, 3, 4, 5],
        'b': [2, 4, 6, 8, 10],
        'c': [5, 4, 3, 2, 1],
      });

      final corr = MathOps.corr(df);
      expect(corr['a'][0], closeTo(1.0, 0.001)); // Self-correlation
      expect(
        corr['a'][1],
        closeTo(1.0, 0.001),
      ); // Perfect positive correlation with b
      expect(
        corr['a'][2],
        closeTo(-1.0, 0.001),
      ); // Perfect negative correlation with c
    });

    test('performs element-wise operations', () {
      final df = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });

      final added = MathOps.add(df, 10);
      expect(added['a'].data, equals([11, 12, 13]));

      final multiplied = MathOps.multiply(df, 2);
      expect(multiplied['a'].data, equals([2, 4, 6]));
    });

    test('calculates rolling statistics', () {
      final df = DataFrame({
        'value': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      });

      final rollingMean = MathOps.rollingMean(df, 3, column: 'value');
      expect(rollingMean['value'][2], equals(2.0)); // (1+2+3)/3
      expect(rollingMean['value'][4], equals(4.0)); // (3+4+5)/3
    });

    test('calculates cumulative statistics', () {
      final df = DataFrame({
        'value': [1, 2, 3, 4, 5],
      });

      final cumSum = MathOps.cumSum(df, column: 'value');
      expect(cumSum['value'].data, equals([1, 3, 6, 10, 15]));

      final cumProd = MathOps.cumProd(df, column: 'value');
      expect(cumProd['value'].data, equals([1, 2, 6, 24, 120]));
    });

    test('calculates percentage change', () {
      final df = DataFrame({
        'value': [100, 110, 99, 108.9],
      });

      final pctChange = MathOps.pctChange(df, column: 'value');
      expect(pctChange['value'][1], closeTo(0.1, 0.001)); // 10% increase
      expect(pctChange['value'][2], closeTo(-0.1, 0.001)); // 10% decrease
    });
  });

  group('Statistical Tests', () {
    test('performs t-test', () {
      final series1 = Series<num>([1, 2, 3, 4, 5]);
      final series2 = Series<num>([2, 3, 4, 5, 6]);

      final result = Statistics.tTest(series1, series2);
      expect(result.containsKey('t_statistic'), isTrue);
      expect(result.containsKey('p_value'), isTrue);
      expect(result.containsKey('degrees_of_freedom'), isTrue);
    });

    test('performs one-sample t-test', () {
      final series = Series<num>([1, 2, 3, 4, 5]);

      final result = Statistics.oneSampleTTest(series, 3.0);
      expect(result.containsKey('t_statistic'), isTrue);
      expect(result.containsKey('p_value'), isTrue);
    });

    test('performs correlation test', () {
      final x = Series<num>([1, 2, 3, 4, 5]);
      final y = Series<num>([2, 4, 6, 8, 10]);

      final result = Statistics.correlationTest(x, y);
      expect(result['correlation'], closeTo(1.0, 0.001));
      expect(result.containsKey('p_value'), isTrue);
    });

    test('performs linear regression', () {
      final x = Series<num>([1, 2, 3, 4, 5]);
      final y = Series<num>([2, 4, 6, 8, 10]);

      final result = Statistics.linearRegression(x, y);
      expect(result['slope'], closeTo(2.0, 0.001));
      expect(result['intercept'], closeTo(0.0, 0.001));
      expect(result['r_squared'], closeTo(1.0, 0.001));
    });

    test('calculates confidence interval', () {
      final series = Series<num>([1, 2, 3, 4, 5]);

      final ci = Statistics.confidenceInterval(series, confidence: 0.95);
      expect(ci.containsKey('mean'), isTrue);
      expect(ci.containsKey('lower_bound'), isTrue);
      expect(ci.containsKey('upper_bound'), isTrue);
      expect(ci['lower_bound']! < ci['mean']!, isTrue);
      expect(ci['mean']! < ci['upper_bound']!, isTrue);
    });

    test('calculates descriptive statistics', () {
      final series = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      final stats = Statistics.descriptiveStats(series);
      expect(stats['count'], equals(10));
      expect(stats['mean'], equals(5.5));
      expect(stats['min'], equals(1));
      expect(stats['max'], equals(10));
      expect(stats['median'], equals(5.5));
    });
  });

  group('I/O Tests', () {
    test('converts dataframe to/from records', () {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final records = df.toRecords();
      expect(records.length, equals(2));
      expect(records[0]['name'], equals('Alice'));

      final df2 = DataFrame.fromRecords(records);
      expect(df2.length, equals(2));
      expect(df2['name'][0], equals('Alice'));
    });

    test('converts dataframe to CSV string', () {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final csv = df.toCsv();
      final lines = csv.split('\n');
      expect(lines[0], equals('name,age'));
      expect(lines[1], equals('Alice,25'));
      expect(lines[2], equals('Bob,30'));
    });

    test('creates sample data', () {
      final numeric = DataUtils.createSampleNumeric(rows: 10, columns: 3);
      expect(numeric.length, equals(10));
      expect(numeric.columns.length, equals(3));

      final mixed = DataUtils.createSampleMixed(rows: 5);
      expect(mixed.length, equals(5));
      expect(mixed.columns.contains('name'), isTrue);
      expect(mixed.columns.contains('age'), isTrue);

      final timeSeries = DataUtils.createTimeSeries(days: 7);
      expect(timeSeries.length, equals(7));
      expect(timeSeries.columns.contains('date'), isTrue);
    });
  });

  group('Utility Functions Tests', () {
    test('creates range series', () {
      final range = DD.range(0, 10, step: 2);
      expect(range.data, equals([0, 2, 4, 6, 8]));
    });

    test('creates date range', () {
      final dates = DD.dateRange('2023-01-01', '2023-01-05');
      expect(dates.length, equals(5));
      expect(dates.data[0], equals('2023-01-01'));
      expect(dates.data[4], equals('2023-01-05'));
    });

    test('creates filled series', () {
      final zeros = DD.zeros(5);
      expect(zeros.data, equals([0, 0, 0, 0, 0]));

      final ones = DD.ones(3);
      expect(ones.data, equals([1, 1, 1]));

      final filled = DD.full<String>(4, 'test');
      expect(filled.data, equals(['test', 'test', 'test', 'test']));
    });

    test('creates random series', () {
      final randn = DD.randn(100, seed: 42);
      expect(randn.length, equals(100));

      final rand = DD.rand(50, min: 0, max: 10, seed: 42);
      expect(rand.length, equals(50));
      expect(rand.data.every((x) => x >= 0 && x <= 10), isTrue);
    });

    test('concatenates series', () {
      final s1 = Series<int>([1, 2, 3]);
      final s2 = Series<int>([4, 5, 6]);

      final concatenated = DD.concat([s1, s2]);
      expect(concatenated.data, equals([1, 2, 3, 4, 5, 6]));
    });

    test('concatenates dataframes', () {
      final df1 = DataFrame({
        'a': [1, 2],
        'b': [3, 4],
      });
      final df2 = DataFrame({
        'a': [5, 6],
        'b': [7, 8],
      });

      final concatenated = DD.concatDataFrames([df1, df2]);
      expect(concatenated.length, equals(4));
      expect(concatenated['a'].data, equals([1, 2, 5, 6]));
    });

    test('merges dataframes', () {
      final df1 = DataFrame({
        'id': [1, 2],
        'name': ['Alice', 'Bob'],
      });
      final df2 = DataFrame({
        'id': [1, 2],
        'age': [25, 30],
      });

      final merged = DD.merge(df1, df2, on: 'id');
      expect(merged.length, equals(2));
      expect(merged.columns.contains('name'), isTrue);
      expect(merged.columns.contains('age_right'), isTrue);
    });
  });

  group('File I/O Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('dadata_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('writes and reads CSV file', () async {
      final df = DataFrame({
        'name': ['Alice', 'Bob', 'Charlie'],
        'age': [25, 30, 35],
        'salary': [50000.0, 60000.0, 70000.0],
      });

      final csvPath = '${tempDir.path}/test.csv';
      await DataIO.toCsv(df, csvPath);

      expect(File(csvPath).existsSync(), isTrue);

      final loaded = await DataIO.readCsv(csvPath);
      expect(loaded.length, equals(3));
      expect(loaded.columns, equals(['name', 'age', 'salary']));
      expect(loaded['name'][0], equals('Alice'));
    });

    test('writes and reads JSON file', () async {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final jsonPath = '${tempDir.path}/test.json';
      await DataIO.toJson(df, jsonPath);

      expect(File(jsonPath).existsSync(), isTrue);

      final loaded = await DataIO.readJson(jsonPath);
      expect(loaded.length, equals(2));
      expect(loaded['name'][0], equals('Alice'));
    });
  });

  group('Extended Series Tests', () {
    test('head and tail operations', () {
      final series = Series<int>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      final head = series.head(3);
      expect(head.data, equals([1, 2, 3]));
      expect(head.length, equals(3));

      final tail = series.tail(3);
      expect(tail.data, equals([8, 9, 10]));
      expect(tail.length, equals(3));

      // Test default parameters
      final defaultHead = series.head();
      expect(defaultHead.length, equals(5));

      final defaultTail = series.tail();
      expect(defaultTail.length, equals(5));
    });

    test('string representation', () {
      final series = Series<int>([1, 2, 3]);
      final str = series.toString();
      expect(str.contains('dtype: int'), isTrue);
      expect(str.contains('1'), isTrue);
      expect(str.contains('2'), isTrue);
      expect(str.contains('3'), isTrue);

      // Test empty series
      final empty = Series<int>.empty();
      expect(empty.toString(), equals('Empty Series'));
    });

    test('loc and index operations', () {
      final series = Series<String>(['a', 'b', 'c'], index: ['x', 'y', 'z']);

      expect(series.loc('x'), equals('a'));
      expect(series.loc('y'), equals('b'));
      expect(series.loc('z'), equals('c'));

      expect(() => series.loc('invalid'), throwsArgumentError);
    });

    test('to map and list conversion', () {
      final series = Series<String>(['apple', 'banana'], index: ['a', 'b']);

      final map = series.toMap();
      expect(map, equals({'a': 'apple', 'b': 'banana'}));

      final list = series.toList();
      expect(list, equals(['apple', 'banana']));
    });
  });

  group('Extended DataFrame Tests', () {
    test('empty dataframe operations', () {
      final df = DataFrame.empty();
      expect(df.isEmpty, isTrue);
      expect(df.isNotEmpty, isFalse);
      expect(df.length, equals(0));
      expect(df.columns.isEmpty, isTrue);
      expect(df.shape, equals([0, 0]));

      final str = df.toString();
      expect(str, equals('Empty DataFrame'));
    });

    test('dataframe info and summary', () {
      final df = DataFrame({
        'a': [1, null, 3],
        'b': ['x', 'y', null],
      });

      final info = df.info();
      expect(info['shape'], equals([3, 2]));
      expect(info['columns'], equals(['a', 'b']));
      expect(info['non_null_counts']['a'], equals(2));
      expect(info['non_null_counts']['b'], equals(2));

      final summary = df.summary();
      expect(summary.contains('DataFrame Summary'), isTrue);
      expect(summary.contains('Shape: 3 rows × 2 columns'), isTrue);
    });

    test('advanced join operations', () {
      final df1 = DataFrame({
        'id': [1, 2, 3],
        'name': ['A', 'B', 'C'],
      });
      final df2 = DataFrame({
        'id': [2, 3, 4],
        'value': [20, 30, 40],
      });

      // Left join
      final leftJoin = df1.join(df2, on: 'id', how: 'left');
      expect(leftJoin.length, equals(3));
      expect(leftJoin.columns.contains('value_right'), isTrue);

      // Right join
      final rightJoin = df1.join(df2, on: 'id', how: 'right');
      expect(rightJoin.length, equals(3));
    });

    test('aggregation operations', () {
      final df = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });

      final aggResult = df.agg((series) {
        try {
          // Cast to numeric series for sum operation
          final numericSeries = Series<num>(series.data.cast<num>());
          return numericSeries.sum();
        } catch (e) {
          return null;
        }
      });
      expect(aggResult['a'], equals(6));
      expect(aggResult['b'], equals(15));

      // Test with subset
      final subsetAgg = df.agg((series) {
        try {
          // Cast to numeric series for mean operation
          final numericSeries = Series<num>(series.data.cast<num>());
          return numericSeries.mean();
        } catch (e) {
          return null;
        }
      }, subset: ['a']);
      expect(subsetAgg.containsKey('a'), isTrue);
      expect(subsetAgg.containsKey('b'), isFalse);
    });

    test('column assignment and validation', () {
      final df = DataFrame({
        'a': [1, 2, 3],
      });

      // Valid assignment
      df['b'] = Series<int>([4, 5, 6]);
      expect(df.columns, equals(['a', 'b']));

      // Invalid assignment (wrong length)
      expect(() => df['c'] = Series<int>([1]), throwsArgumentError);
    });

    test('csv string conversion', () {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final csv = df.toCsv();
      final lines = csv.trim().split('\n');
      expect(lines[0], equals('name,age'));
      expect(lines[1], equals('Alice,25'));
      expect(lines[2], equals('Bob,30'));

      // Test with custom separator
      final csvCustom = df.toCsv(separator: ';');
      expect(csvCustom.contains('name;age'), isTrue);
    });
  });

  group('Advanced Mathematical Operations Tests', () {
    test('covariance matrix', () {
      final df = DataFrame({
        'a': [1, 2, 3, 4, 5],
        'b': [2, 4, 6, 8, 10],
        'c': [5, 4, 3, 2, 1],
      });

      final cov = MathOps.cov(df);
      expect(cov.columns.contains('a'), isTrue);
      expect(cov.columns.contains('b'), isTrue);
      expect(cov.columns.contains('c'), isTrue);

      // Self-covariance should be variance
      expect(cov['a'][0], greaterThan(0));
    });

    test('mathematical function applications', () {
      final df = DataFrame({
        'values': [1, 4, 9, 16, 25],
      });

      // Test sqrt
      final sqrtDf = MathOps.sqrt(df);
      expect(sqrtDf['values'][0], equals(1.0));
      expect(sqrtDf['values'][1], equals(2.0));

      // Test abs
      final negDf = DataFrame({
        'values': [-1, -2, 3, -4],
      });
      final absDf = MathOps.abs(negDf);
      expect(absDf['values'].data.every((x) => x >= 0), isTrue);

      // Test log
      final logDf = MathOps.log(df);
      expect(logDf['values'][0], equals(0.0)); // log(1) = 0

      // Test exp
      final expDf = MathOps.exp(
        DataFrame({
          'values': [0, 1, 2],
        }),
      );
      expect(expDf['values'][0], closeTo(1.0, 0.001)); // exp(0) = 1
    });

    test('trigonometric functions', () {
      final df = DataFrame({
        'angles': [0, math.pi / 2, math.pi],
      });

      final sinDf = MathOps.sin(df);
      expect(sinDf['angles'][0], closeTo(0.0, 0.001));
      expect(sinDf['angles'][1], closeTo(1.0, 0.001));

      final cosDf = MathOps.cos(df);
      expect(cosDf['angles'][0], closeTo(1.0, 0.001));
      expect(cosDf['angles'][2], closeTo(-1.0, 0.001));

      final tanDf = MathOps.tan(df);
      expect(tanDf['angles'][0], closeTo(0.0, 0.001));
    });

    test('advanced rolling operations', () {
      final df = DataFrame({
        'values': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      });

      // Rolling sum
      final rollingSum = MathOps.rollingSum(df, 3);
      expect(rollingSum['values'][2], equals(6.0)); // 1+2+3
      expect(rollingSum['values'][4], equals(12.0)); // 3+4+5

      // Rolling std
      final rollingStd = MathOps.rollingStd(df, 3);
      expect(rollingStd['values'][2], greaterThan(0));
    });

    test('data clipping and rounding', () {
      final df = DataFrame({
        'values': [-5, 0, 5, 10, 15],
      });

      // Test clipping
      final clipped = MathOps.clip(df, lower: 0, upper: 10);
      expect(clipped['values'][0], equals(0)); // -5 clipped to 0
      expect(clipped['values'][4], equals(10)); // 15 clipped to 10

      // Test rounding
      final floatDf = DataFrame({
        'values': [1.234, 2.567, 3.891],
      });
      final rounded = MathOps.round(floatDf, 2);
      expect(rounded['values'][0], equals(1.23));
      expect(rounded['values'][1], equals(2.57));
    });

    test('dataframe operations with scalars and other dataframes', () {
      final df1 = DataFrame({
        'a': [1, 2, 3],
        'b': [4, 5, 6],
      });
      final df2 = DataFrame({
        'a': [1, 1, 1],
        'b': [2, 2, 2],
      });

      // DataFrame + DataFrame
      final added = MathOps.add(df1, df2);
      expect(added['a'].data, equals([2, 3, 4]));
      expect(added['b'].data, equals([6, 7, 8]));

      // DataFrame - DataFrame
      final subtracted = MathOps.subtract(df1, df2);
      expect(subtracted['a'].data, equals([0, 1, 2]));

      // DataFrame * DataFrame
      final multiplied = MathOps.multiply(df1, df2);
      expect(multiplied['a'].data, equals([1, 2, 3]));
      expect(multiplied['b'].data, equals([8, 10, 12]));

      // DataFrame / DataFrame
      final divided = MathOps.divide(df1, df2);
      expect(divided['a'].data, equals([1, 2, 3]));
      expect(divided['b'].data, equals([2, 2.5, 3]));
    });
  });

  group('Comprehensive Statistical Tests', () {
    test('ANOVA test', () {
      final group1 = Series<num>([1, 2, 3, 4, 5]);
      final group2 = Series<num>([2, 3, 4, 5, 6]);
      final group3 = Series<num>([3, 4, 5, 6, 7]);

      final result = Statistics.anova([group1, group2, group3]);
      expect(result.containsKey('f_statistic'), isTrue);
      expect(result.containsKey('p_value'), isTrue);
      expect(result.containsKey('df_between'), isTrue);
      expect(result.containsKey('df_within'), isTrue);
      expect(result.containsKey('ss_between'), isTrue);
      expect(result.containsKey('ss_within'), isTrue);

      expect(result['df_between'], equals(2.0)); // 3 groups - 1
      expect(result['df_within'], equals(12.0)); // 15 total - 3 groups
    });

    test('chi-square test of independence', () {
      final df = DataFrame({
        'category1': ['A', 'A', 'B', 'B', 'A', 'B'],
        'category2': ['X', 'Y', 'X', 'Y', 'X', 'Y'],
      });

      final result = Statistics.chiSquareTest(df, 'category1', 'category2');
      expect(result.containsKey('chi_square'), isTrue);
      expect(result.containsKey('p_value'), isTrue);
      expect(result.containsKey('degrees_of_freedom'), isTrue);

      expect(result['degrees_of_freedom'], equals(1.0)); // (2-1) * (2-1)
    });

    test('normality tests', () {
      final normalData = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      // Shapiro-Wilk test
      final shapiro = Statistics.normalityTest(normalData, test: 'shapiro');
      expect(shapiro.containsKey('statistic'), isTrue);
      expect(shapiro.containsKey('p_value'), isTrue);

      // Jarque-Bera test
      final jarque = Statistics.normalityTest(normalData, test: 'jarque');
      expect(jarque.containsKey('statistic'), isTrue);
      expect(jarque.containsKey('p_value'), isTrue);

      // Anderson-Darling test
      final anderson = Statistics.normalityTest(normalData, test: 'anderson');
      expect(anderson.containsKey('statistic'), isTrue);
      expect(anderson.containsKey('p_value'), isTrue);
    });

    test('confidence intervals with different confidence levels', () {
      final data = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      final ci95 = Statistics.confidenceInterval(data, confidence: 0.95);
      final ci99 = Statistics.confidenceInterval(data, confidence: 0.99);

      expect(ci95['confidence_level'], equals(0.95));
      expect(ci99['confidence_level'], equals(0.99));

      // 99% CI should be wider than 95% CI
      final width95 = ci95['upper_bound']! - ci95['lower_bound']!;
      final width99 = ci99['upper_bound']! - ci99['lower_bound']!;
      expect(width99, greaterThan(width95));
    });

    test('descriptive statistics comprehensive', () {
      final data = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      final stats = Statistics.descriptiveStats(data, confidence: 0.95);
      expect(stats['count'], equals(10));
      expect(stats['mean'], equals(5.5));
      expect(stats['median'], equals(5.5));
      expect(stats['min'], equals(1));
      expect(stats['max'], equals(10));
      expect(stats['q1'], equals(3.25));
      expect(stats['q3'], equals(7.75));
      expect(stats['iqr'], equals(4.5));
      expect(stats['range'], equals(9));
      expect(stats.containsKey('skewness'), isTrue);
      expect(stats.containsKey('kurtosis'), isTrue);
      expect(stats.containsKey('confidence_interval'), isTrue);
      expect(stats.containsKey('coefficient_of_variation'), isTrue);

      // Empty series
      final emptyStats = Statistics.descriptiveStats(Series<num>([]));
      expect(emptyStats['count'], equals(0));
    });
  });

  group('Extended I/O Operations Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('dadata_extended_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('CSV with different options', () async {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final csvPath = '${tempDir.path}/test_options.csv';

      // Test with index
      await DataIO.toCsv(df, csvPath, writeIndex: true);
      final withIndex = await DataIO.readCsv(csvPath);
      expect(withIndex.columns.contains('Index'), isTrue);

      // Test with custom separator
      await DataIO.toCsv(df, csvPath, separator: ';');
      final content = File(csvPath).readAsStringSync();
      expect(content.contains('name;age'), isTrue);

      // Test without header
      await DataIO.toCsv(df, csvPath, writeHeader: false);
      final noHeader = await DataIO.readCsv(csvPath, hasHeader: false);
      expect(noHeader.columns, equals(['Column_0', 'Column_1']));
    });

    test('JSON with different orientations', () async {
      final df = DataFrame({
        'name': ['Alice', 'Bob'],
        'age': [25, 30],
      });

      final jsonPath = '${tempDir.path}/test_orient.json';

      // Test columns orientation
      await DataIO.toJson(df, jsonPath, orient: 'columns');
      final columnsData = await DataIO.readJson(jsonPath, orient: 'columns');
      expect(columnsData.length, equals(2));

      // Test index orientation
      await DataIO.toJson(df, jsonPath, orient: 'index');
      final indexData = await DataIO.readJson(jsonPath, orient: 'index');
      expect(indexData.length, equals(2));

      // Test with writeIndex
      await DataIO.toJson(df, jsonPath, writeIndex: true);
      final content = File(jsonPath).readAsStringSync();
      expect(content.contains('_index'), isTrue);
    });

    test('export function with different formats', () async {
      final df = DataFrame({
        'data': [1, 2, 3],
      });

      // Test CSV export
      final csvPath = '${tempDir.path}/export_test.csv';
      await DataIO.export(df, csvPath);
      expect(File(csvPath).existsSync(), isTrue);

      // Test JSON export
      final jsonPath = '${tempDir.path}/export_test.json';
      await DataIO.export(df, jsonPath);
      expect(File(jsonPath).existsSync(), isTrue);

      // Test unsupported format
      expect(
        () async => await DataIO.export(df, 'test.xyz'),
        throwsArgumentError,
      );
    });

    test('error handling in I/O operations', () async {
      // Test reading non-existent file
      expect(
        () async => await DataIO.readCsv('non_existent.csv'),
        throwsA(isA<FileSystemException>()),
      );

      expect(
        () async => await DataIO.readJson('non_existent.json'),
        throwsA(isA<FileSystemException>()),
      );

      // Test invalid JSON format
      final invalidJsonPath = '${tempDir.path}/invalid.json';
      File(invalidJsonPath).writeAsStringSync('invalid json');

      expect(
        () async => await DataIO.readJson(invalidJsonPath),
        throwsA(isA<FormatException>()),
      );
    });

    test('sample data generation with options', () {
      // Test numeric with seed
      final numeric1 = DataUtils.createSampleNumeric(
        rows: 5,
        columns: 3,
        seed: 42,
      );
      final numeric2 = DataUtils.createSampleNumeric(
        rows: 5,
        columns: 3,
        seed: 42,
      );
      expect(
        numeric1['column_0'][0],
        equals(numeric2['column_0'][0]),
      ); // Same seed = same data

      // Test mixed data
      final mixed = DataUtils.createSampleMixed(rows: 10, seed: 123);
      expect(mixed.length, equals(10));
      expect(mixed.columns.contains('name'), isTrue);
      expect(mixed.columns.contains('category'), isTrue);
      expect(mixed.columns.contains('active'), isTrue);

      // Test time series
      final start = DateTime(2023, 1, 1);
      final timeSeries = DataUtils.createTimeSeries(
        start: start,
        days: 7,
        seed: 456,
      );
      expect(timeSeries.length, equals(7));
      expect(timeSeries['date'][0], equals('2023-01-01'));
    });

    test('fromQueryResult function', () {
      final queryResult = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'},
      ];

      final df = DataIO.fromQueryResult(queryResult);
      expect(df.length, equals(2));
      expect(df.columns, equals(['id', 'name']));

      // With custom index
      final dfWithIndex = DataIO.fromQueryResult(
        queryResult,
        index: ['row1', 'row2'],
      );
      expect(dfWithIndex.index, equals(['row1', 'row2']));
    });
  });

  group('Series Extensions Tests', () {
    test('mathematical operations on series', () {
      final series1 = Series<num>([1, 2, 3]);
      final series2 = Series<num>([2, 2, 2]);

      // Addition
      final added = series1 + series2;
      expect(added.data, equals([3, 4, 5]));

      final addedScalar = series1 + 10;
      expect(addedScalar.data, equals([11, 12, 13]));

      // Subtraction
      final subtracted = series1 - series2;
      expect(subtracted.data, equals([-1, 0, 1]));

      // Multiplication
      final multiplied = series1 * series2;
      expect(multiplied.data, equals([2, 4, 6]));

      // Division
      final divided = series1 / series2;
      expect(divided.data, equals([0.5, 1, 1.5]));

      // Division by zero handling
      final divByZero = series1 / Series<num>([0, 1, 2]);
      expect(divByZero.data[0].isNaN, isTrue);
    });

    test('correlation and covariance between series', () {
      final x = Series<num>([1, 2, 3, 4, 5]);
      final y = Series<num>([2, 4, 6, 8, 10]);

      final correlation = x.corr(y);
      expect(correlation, closeTo(1.0, 0.001)); // Perfect positive correlation

      final covariance = x.cov(y);
      expect(covariance, greaterThan(0)); // Positive covariance

      // Test with different correlation methods
      final spearmanCorr = x.corr(y, method: 'spearman');
      expect(spearmanCorr, closeTo(1.0, 0.001));
    });

    test('histogram for series', () {
      final series = Series<num>([1, 2, 3, 4, 5, 1, 2, 3, 4, 5]);

      final hist = series.hist(bins: 5);
      expect(hist.contains('Histogram'), isTrue);
      expect(hist.contains('Range: 1 - 5'), isTrue);
      expect(hist.contains('*'), isTrue); // Should contain histogram bars

      // Test non-numeric series
      final textSeries = Series<String>(['a', 'b', 'c']);
      final textHist = textSeries.hist();
      expect(textHist, equals('Histogram only supports numeric data'));
    });
  });

  group('DataFrame Extensions Tests', () {
    test('dataframe plotting helper', () {
      final df = DataFrame({
        'x': [1, 2, 3, 4, 5],
        'y': [2, 4, 6, 8, 10],
        'z': [1, 3, 5, 7, 9],
      });

      final plot = df.plot(x: 'x', y: 'y', kind: 'scatter');
      expect(plot.contains('Plot: y vs x (scatter)'), isTrue);
      expect(plot.contains('X range: 1 - 5'), isTrue);
      expect(plot.contains('Y range: 2 - 10'), isTrue);
      expect(plot.contains('Correlation:'), isTrue);

      // Test error cases
      final noColumns = df.plot(x: 'invalid', y: 'y');
      expect(noColumns.contains('not found'), isTrue);

      final missingParams = df.plot();
      expect(missingParams.contains('requires both x and y'), isTrue);
    });
  });

  group('Utility Classes Tests', () {
    test('DD utility functions comprehensive', () {
      // Test seriesFromMap
      final seriesFromMap = DD.seriesFromMap({'a': 1, 'b': 2, 'c': 3});
      expect(seriesFromMap.length, equals(3));
      expect(seriesFromMap.loc('a'), equals(1));

      // Test dataFrameFromRecords
      final dfFromRecords = DD.dataFrameFromRecords([
        {'name': 'Alice', 'age': 25},
        {'name': 'Bob', 'age': 30},
      ]);
      expect(dfFromRecords.length, equals(2));
      expect(dfFromRecords.columns, equals(['name', 'age']));

      // Test dateRange with different frequencies
      final dailyRange = DD.dateRange('2023-01-01', '2023-01-03', freq: 'D');
      expect(dailyRange.length, equals(3));

      final weeklyRange = DD.dateRange('2023-01-01', '2023-01-15', freq: 'W');
      expect(weeklyRange.length, equals(3)); // 1st, 8th, 15th

      // Test monthly range
      final monthlyRange = DD.dateRange('2023-01-01', '2023-03-01', freq: 'M');
      expect(monthlyRange.length, equals(3)); // Jan, Feb, Mar

      // Test invalid frequency
      expect(
        () => DD.dateRange('2023-01-01', '2023-01-03', freq: 'X'),
        throwsArgumentError,
      );
    });

    test('advanced data concatenation', () {
      final df1 = DataFrame({
        'a': [1, 2],
        'b': [3, 4],
      });
      final df2 = DataFrame({
        'a': [5, 6],
        'c': [7, 8],
      }); // Different columns

      final concatenated = DD.concatDataFrames([df1, df2], ignoreIndex: true);
      expect(concatenated.length, equals(4));
      expect(concatenated.columns.length, equals(3)); // a, b, c
      expect(concatenated.index, equals(['0', '1', '2', '3']));

      // Test with original indices
      final withOriginalIndex = DD.concatDataFrames([
        df1,
        df2,
      ], ignoreIndex: false);
      expect(withOriginalIndex.index, equals(['0', '1', '0', '1']));
    });

    test('normal distribution generation', () {
      final normalData = DD.randn(1000, mean: 100, std: 15, seed: 42);
      expect(normalData.length, equals(1000));

      // Check approximate mean and std (should be close due to large sample)
      final mean = normalData.data.reduce((a, b) => a + b) / normalData.length;
      expect(mean, closeTo(100, 5)); // Within 5 units of target mean

      // Test with different parameters
      final smallSample = DD.randn(10, mean: 0, std: 1, seed: 123);
      expect(smallSample.length, equals(10));
    });

    test('uniform distribution generation', () {
      final uniformData = DD.rand(100, min: 10, max: 20, seed: 42);
      expect(uniformData.length, equals(100));
      expect(uniformData.data.every((x) => x >= 10 && x <= 20), isTrue);

      // Test default parameters
      final defaultUniform = DD.rand(50, seed: 456);
      expect(defaultUniform.data.every((x) => x >= 0 && x <= 1), isTrue);
    });

    test('series concatenation with index handling', () {
      final s1 = Series<int>([1, 2], index: ['a', 'b']);
      final s2 = Series<int>([3, 4], index: ['c', 'd']);

      // Preserve index
      final preserveIndex = DD.concat([s1, s2], ignoreIndex: false);
      expect(preserveIndex.index, equals(['a', 'b', 'c', 'd']));

      // Ignore index
      final ignoreIndex = DD.concat([s1, s2], ignoreIndex: true);
      expect(ignoreIndex.index, equals(['0', '1', '2', '3']));
    });
  });

  group('Error Handling Tests', () {
    test('series error conditions', () {
      // Index length mismatch
      expect(
        () => Series<int>([1, 2, 3], index: ['a', 'b']),
        throwsArgumentError,
      );

      // Invalid loc access
      final series = Series<int>([1, 2, 3]);
      expect(() => series.loc('invalid'), throwsArgumentError);

      // Statistics on non-numeric data
      final textSeries = Series<String>(['a', 'b', 'c']);
      expect(() => textSeries.sum(), throwsA(isA<UnsupportedError>()));
      expect(() => textSeries.mean(), throwsA(isA<UnsupportedError>()));
      expect(() => textSeries.std(), throwsA(isA<UnsupportedError>()));

      // Empty series operations
      final emptySeries = Series<int>([]);
      expect(() => emptySeries.min(), throwsStateError);
      expect(() => emptySeries.max(), throwsStateError);
    });

    test('dataframe error conditions', () {
      // Mismatched column lengths
      expect(
        () => DataFrame({
          'a': [1, 2, 3],
          'b': [4, 5], // Different length
        }),
        throwsArgumentError,
      );

      // Invalid column access
      final df = DataFrame({
        'a': [1, 2, 3],
      });
      expect(() => df['invalid'], throwsArgumentError);

      // Invalid row access
      expect(() => df.iloc(10), throwsRangeError);
      expect(() => df.loc('invalid'), throwsArgumentError);

      // Join without common column
      final df2 = DataFrame({
        'b': [1, 2, 3],
      });
      expect(() => df.join(df2, on: 'c'), throwsArgumentError);
    });

    test('statistical test error conditions', () {
      // Insufficient data for t-test
      final smallSeries = Series<num>([1]);
      expect(
        () => Statistics.tTest(smallSeries, smallSeries),
        throwsArgumentError,
      );

      // Mismatched series lengths for correlation
      final s1 = Series<num>([1, 2, 3]);
      final s2 = Series<num>([1, 2]);
      expect(() => Statistics.correlationTest(s1, s2), throwsArgumentError);

      // Invalid normality test
      expect(
        () => Statistics.normalityTest(s1, test: 'invalid'),
        throwsArgumentError,
      );

      // ANOVA with too few groups
      expect(() => Statistics.anova([s1]), throwsArgumentError);
    });

    test('mathematical operations error conditions', () {
      // Non-numeric data for correlation
      final df = DataFrame({
        'text': ['a', 'b', 'c'],
      });
      expect(() => MathOps.corr(df), throwsArgumentError);

      // Unsupported correlation method through Series
      final s1 = Series<num>([1, 2, 3]);
      final s2 = Series<num>([1, 2, 3]);
      expect(() => s1.corr(s2, method: 'invalid'), throwsArgumentError);

      // Unsupported join type
      final df1 = DataFrame({
        'id': [1, 2],
        'a': [1, 2],
      });
      final df2 = DataFrame({
        'id': [1, 2],
        'b': [3, 4],
      });
      expect(
        () => df1.join(df2, on: 'id', how: 'invalid'),
        throwsArgumentError,
      );
    });
  });

  group('Edge Cases Tests', () {
    test('empty and single-element operations', () {
      // Empty DataFrame operations
      final emptyDf = DataFrame.empty();
      final info = emptyDf.info();
      expect(info['shape'], equals([0, 0]));

      // Single element series
      final singleSeries = Series<int>([42]);
      expect(singleSeries.sum(), equals(42));
      expect(singleSeries.mean(), equals(42.0));
      expect(singleSeries.min(), equals(42));
      expect(singleSeries.max(), equals(42));

      // Single row DataFrame
      final singleRowDf = DataFrame({
        'a': [1],
      });
      expect(singleRowDf.length, equals(1));
      expect(singleRowDf.iloc(0)['a'], equals(1));
    });

    test('null and mixed data handling', () {
      // All null series
      final nullSeries = Series<int?>([null, null, null]);
      expect(nullSeries.nullCount(), equals(3));
      expect(nullSeries.dropna().isEmpty, isTrue);

      // Mixed null data in DataFrame
      final mixedDf = DataFrame({
        'numbers': [1, null, 3, null],
        'strings': ['a', null, 'c', 'd'],
      });

      final droppedAny = mixedDf.dropna();
      expect(droppedAny.length, equals(2)); // Only rows 0 and 2 have no nulls

      final droppedSubset = mixedDf.dropna(subset: ['numbers']);
      expect(droppedSubset.length, equals(2)); // Only check 'numbers' column
    });

    test('large index values and special characters', () {
      // Large numeric indices
      final largeSeries = Series<int>(
        [1, 2, 3],
        index: ['999999999999', 'index_with_underscores', 'special!@#\$%'],
      );
      expect(largeSeries.loc('999999999999'), equals(1));
      expect(largeSeries.loc('special!@#\$%'), equals(3));

      // DataFrame with special column names
      final specialDf = DataFrame({
        'column with spaces': [1, 2],
        '123numeric_start': [3, 4],
        'üñíçødé': [5, 6],
      });
      expect(specialDf['column with spaces'][0], equals(1));
      expect(specialDf['üñíçødé'][1], equals(6));
    });

    test('extreme mathematical values', () {
      // Very large numbers
      final largeDf = DataFrame({
        'big_numbers': [1e100, 2e100, 3e100],
      });
      final sum = Series<num>(largeDf['big_numbers'].data.cast<num>()).sum();
      expect(sum, closeTo(6e100, 1e97)); // Use tolerance for very large numbers

      // Very small numbers
      final smallDf = DataFrame({
        'tiny_numbers': [1e-100, 2e-100, 3e-100],
      });
      expect(
        Series<num>(smallDf['tiny_numbers'].data.cast<num>()).sum(),
        greaterThan(0),
      );

      // Mixed with infinity and NaN (if supported)
      final specialDf = DataFrame({
        'special': [1.0, double.infinity, double.negativeInfinity],
      });
      expect(specialDf['special'][1].isInfinite, isTrue);
      expect(specialDf['special'][2].isInfinite, isTrue);
    });
  });
}
