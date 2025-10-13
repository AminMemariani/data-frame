import 'package:dadata/dadata.dart';

/// Example usage of the DaData library
///
/// This demonstrates the main features of the library including:
/// - Creating and manipulating Series and DataFrames
/// - Data I/O operations
/// - Statistical analysis
/// - Mathematical operations
/// - Data visualization helpers
void main() async {
  print('=== DaData Library Example ===\n');

  // Create a sample DataFrame
  print('1. Creating a DataFrame from data:');
  final df = DataFrame({
    'name': ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'],
    'age': [25, 30, 35, 28, 32],
    'salary': [50000, 60000, 70000, 55000, 65000],
    'department': ['IT', 'Finance', 'IT', 'HR', 'Finance'],
    'experience': [2, 5, 8, 3, 6],
  });

  print(df);
  print('DataFrame shape: ${df.shape}');
  print('Columns: ${df.columns}\n');

  // Basic DataFrame operations
  print('2. Basic DataFrame operations:');
  print('First 3 rows:');
  print(df.head(3));

  print('Basic statistics:');
  print(df.describe());

  print('DataFrame info:');
  print(df.summary());

  // Filtering and selection
  print('\n3. Filtering and selection:');
  final highEarners = df.where((row) => (row['salary'] as num) > 55000);
  print('Employees earning more than \$55,000:');
  print(highEarners);

  final itDepartment = df.where((row) => row['department'] == 'IT');
  print('IT department employees:');
  print(itDepartment);

  // Column selection
  final basicInfo = df.select(['name', 'age', 'department']);
  print('Basic employee info:');
  print(basicInfo);

  // Sorting
  print('\n4. Sorting:');
  final sortedBySalary = df.sortBy(['salary'], ascending: false);
  print('Employees sorted by salary (highest first):');
  print(sortedBySalary);

  // Grouping
  print('\n5. Grouping operations:');
  final groupedByDept = df.groupBy(['department']);
  print('Employees grouped by department:');
  for (final entry in groupedByDept.entries) {
    print('\n${entry.key}:');
    print(entry.value);
  }

  // Mathematical operations
  print('\n6. Mathematical operations:');

  // Calculate correlation matrix
  final numericDf = df.select(['age', 'salary', 'experience']);
  final correlation = MathOps.corr(numericDf);
  print('Correlation matrix:');
  print(correlation);

  // Add bonus calculation (10% of salary)
  final salariesSeries = df['salary'].map<num>(
    (salary) => (salary as num) * 0.1,
  );
  final dfWithBonus = DataFrame.fromRecords(df.toRecords());
  dfWithBonus.addColumn('bonus', salariesSeries);
  print('DataFrame with calculated bonus (10% of salary):');
  print(dfWithBonus.head());

  // Statistical analysis
  print('\n7. Statistical analysis:');

  // Descriptive statistics for salary
  final salaryStats = Statistics.descriptiveStats(
    Series<num>(df['salary'].data.cast<num>()),
  );
  print('Salary statistics:');
  salaryStats.forEach((key, value) {
    if (value is Map) {
      print('  $key: ${value.toString()}');
    } else {
      print('  $key: ${value is double ? value.toStringAsFixed(2) : value}');
    }
  });

  // Confidence interval for average salary
  final salaryCI = Statistics.confidenceInterval(
    Series<num>(df['salary'].data.cast<num>()),
    confidence: 0.95,
  );
  print('\nSalary 95% confidence interval:');
  print('  Mean: \$${salaryCI['mean']!.toStringAsFixed(2)}');
  print('  Lower bound: \$${salaryCI['lower_bound']!.toStringAsFixed(2)}');
  print('  Upper bound: \$${salaryCI['upper_bound']!.toStringAsFixed(2)}');

  // Correlation test between experience and salary
  final corrTest = Statistics.correlationTest(
    Series<num>(df['experience'].data.cast<num>()),
    Series<num>(df['salary'].data.cast<num>()),
  );
  print('\nCorrelation between experience and salary:');
  print('  Correlation: ${corrTest['correlation']!.toStringAsFixed(3)}');
  print('  P-value: ${corrTest['p_value']!.toStringAsFixed(4)}');

  // Linear regression
  final regression = Statistics.linearRegression(
    Series<num>(df['experience'].data.cast<num>()),
    Series<num>(df['salary'].data.cast<num>()),
  );
  print('\nLinear regression (salary ~ experience):');
  print('  Slope: ${regression['slope']!.toStringAsFixed(2)}');
  print('  Intercept: ${regression['intercept']!.toStringAsFixed(2)}');
  print('  R-squared: ${regression['r_squared']!.toStringAsFixed(3)}');

  // Working with Series
  print('\n8. Series operations:');
  final ages = df['age'];
  print('Age series:');
  print(ages);

  print('Age statistics:');
  final ageDescription = Series<num>(ages.data.cast<num>()).describe();
  ageDescription.forEach((key, value) {
    print('  $key: ${value is double ? value.toStringAsFixed(2) : value}');
  });

  print('Age histogram:');
  print(Series<num>(ages.data.cast<num>()).hist());

  // Create sample data
  print('\n9. Creating sample data:');

  // Numeric sample
  final sampleNumeric = DD.sampleNumeric(rows: 5, columns: 3, seed: 42);
  print('Sample numeric data:');
  print(sampleNumeric);

  // Mixed sample
  final sampleMixed = DD.sampleMixed(rows: 3, seed: 42);
  print('Sample mixed data:');
  print(sampleMixed);

  // Time series
  final timeSeries = DD.timeSeries(days: 5, seed: 42);
  print('Sample time series:');
  print(timeSeries);

  // Utility functions
  print('\n10. Utility functions:');

  // Create ranges
  final range = DD.range(1, 10, step: 2);
  print('Range 1-10 (step 2): ${range.data}');

  // Create date range
  final dateRange = DD.dateRange('2024-01-01', '2024-01-05');
  print('Date range: ${dateRange.data}');

  // Create filled series
  final zeros = DD.zeros(5);
  final ones = DD.ones(3);
  print('Zeros: ${zeros.data}');
  print('Ones: ${ones.data}');

  // Random data
  final randomNormal = DD.randn(5, seed: 42);
  final randomUniform = DD.rand(5, min: 0, max: 100, seed: 42);
  print(
    'Random normal: ${randomNormal.data.map((x) => x.toStringAsFixed(2)).toList()}',
  );
  print(
    'Random uniform: ${randomUniform.data.map((x) => x.toStringAsFixed(2)).toList()}',
  );

  // File I/O operations
  print('\n11. File I/O operations:');

  try {
    // Save to CSV
    await DataIO.toCsv(df, 'employee_data.csv');
    print('✓ DataFrame saved to employee_data.csv');

    // Save to JSON
    await DataIO.toJson(df, 'employee_data.json');
    print('✓ DataFrame saved to employee_data.json');

    // Read back from CSV
    final loadedDf = await DataIO.readCsv('employee_data.csv');
    print('✓ DataFrame loaded from CSV (${loadedDf.length} rows)');

    // Read back from JSON
    final loadedJson = await DataIO.readJson('employee_data.json');
    print('✓ DataFrame loaded from JSON (${loadedJson.length} rows)');
  } catch (e) {
    print('File I/O error: $e');
  }

  // Advanced operations
  print('\n12. Advanced operations:');

  // Rolling statistics
  final values = DataFrame({
    'value': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  });

  final rollingMean = MathOps.rollingMean(values, 3);
  print('Rolling mean (window=3):');
  for (int i = 0; i < values.length; i++) {
    final original = values['value'][i];
    final rolling = rollingMean['value'][i];
    final rollingStr = rolling.isNaN ? 'NaN' : rolling.toStringAsFixed(2);
    print('  Index $i: $original -> $rollingStr');
  }

  // Percentage change
  final pctChange = MathOps.pctChange(values);
  print('\nPercentage change:');
  for (int i = 0; i < values.length; i++) {
    final original = values['value'][i];
    final pct = pctChange['value'][i];
    final pctStr = pct.isNaN ? 'NaN' : '${(pct * 100).toStringAsFixed(1)}%';
    print('  Index $i: $original -> $pctStr');
  }

  // Data concatenation
  final df1 = DataFrame({
    'a': [1, 2],
    'b': [3, 4],
  });
  final df2 = DataFrame({
    'a': [5, 6],
    'b': [7, 8],
  });
  final concatenated = DD.concatDataFrames([df1, df2]);
  print('\nConcatenated DataFrames:');
  print(concatenated);

  // Data merging
  final employees = DataFrame({
    'id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
  });

  final salaries = DataFrame({
    'id': [1, 2, 4],
    'salary': [50000, 60000, 70000],
  });

  final merged = DD.merge(employees, salaries, on: 'id', how: 'inner');
  print('\nMerged employee and salary data:');
  print(merged);

  print('\n=== DaData Example Complete ===');
}

/// Utility function to demonstrate error handling
void demonstrateErrorHandling() {
  print('\n=== Error Handling Examples ===');

  try {
    // Try to create Series with mismatched lengths
    final invalidSeries = Series<int>(
      [1, 2, 3],
      index: ['a', 'b'],
    ); // Will throw
    print(invalidSeries);
  } catch (e) {
    print('✓ Caught expected error: $e');
  }

  try {
    // Try to access non-existent column
    final df = DataFrame({
      'a': [1, 2, 3],
    });
    final column = df['nonexistent']; // Will throw
    print(column);
  } catch (e) {
    print('✓ Caught expected error: $e');
  }

  try {
    // Try to perform statistics on non-numeric data
    final textSeries = Series<String>(['a', 'b', 'c']);
    final mean = textSeries.mean(); // Will throw
    print(mean);
  } catch (e) {
    print('✓ Caught expected error: $e');
  }
}
