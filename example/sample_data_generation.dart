// ignore_for_file: avoid_print

/// Sample Data Generation Example
///
/// This example demonstrates various ways to generate sample data:
/// - Creating Series with different patterns (ranges, random, filled)
/// - Generating DataFrames with sample data
/// - Creating time series data
/// - Simulating different data distributions
/// - Building realistic datasets for testing and analysis
library;

import 'package:collection/collection.dart';
import 'package:data_frame/data_frame.dart';
import 'dart:math' as math;

void main() {
  print('=== Sample Data Generation with Data Frame ===\n');

  // Basic series generation
  basicSeriesGeneration();

  // Random data generation
  randomDataGeneration();

  // Time series generation
  timeSeriesGeneration();

  // Structured data generation
  structuredDataGeneration();

  // Realistic dataset simulation
  realisticDatasetSimulation();

  // Advanced data patterns
  advancedDataPatterns();

  // Performance testing data
  performanceTestingData();
}

/// Demonstrates basic series generation methods
void basicSeriesGeneration() {
  print('🔹 BASIC SERIES GENERATION\n');

  // Range series
  print('📊 RANGE SERIES:');

  final simpleRange = DF.range(0, 10);
  print('Simple range (0-10): ${simpleRange.data}');

  final stepRange = DF.range(0, 20, step: 3);
  print('Step range (0-20, step 3): ${stepRange.data}');

  final negativeRange = DF.range(-5, 5);
  print('Negative to positive (-5 to 5): ${negativeRange.data}');

  final decimalRange = DF.range(0, 10, step: 2);
  print('Even numbers (0-10, step 2): ${decimalRange.data}');
  print('');

  // Filled series
  print('🔢 FILLED SERIES:');

  final zeros = DF.zeros(8);
  print('Zeros (length 8): ${zeros.data}');

  final ones = DF.ones(6);
  print('Ones (length 6): ${ones.data}');

  final constantValues = DF.full(5, 42);
  print('Constant 42 (length 5): ${constantValues.data}');

  final stringConstants = DF.full(4, 'Hello');
  print('String constants: ${stringConstants.data}');
  print('');

  // Custom index series
  print('🏷️ CUSTOM INDEX SERIES:');

  final indexedSeries = Series<int>(
    [10, 20, 30, 40, 50],
    index: ['first', 'second', 'third', 'fourth', 'fifth'],
  );
  print('Custom indexed series:');
  print('  Values: ${indexedSeries.data}');
  print('  Index: ${indexedSeries.index}');
  print('  Access by label "third": ${indexedSeries.loc('third')}');
  print('');

  // Series from map
  print('🗺️ SERIES FROM MAP:');

  final mapSeries = DF.seriesFromMap({
    'apple': 5,
    'banana': 3,
    'orange': 8,
    'grape': 12,
  });
  print('Fruit quantities: ${mapSeries.data}');
  print('Index (fruits): ${mapSeries.index}');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates random data generation
void randomDataGeneration() {
  print('🔹 RANDOM DATA GENERATION\n');

  // Normal distribution
  print('📊 NORMAL DISTRIBUTION:');

  final normalData = DF.randn(15, mean: 100, std: 15, seed: 42);
  print('Normal distribution (μ=100, σ=15):');
  print(
    '  Values: ${normalData.data.map((x) => x.toStringAsFixed(1)).join(', ')}',
  );
  print('  Sample mean: ${normalData.mean().toStringAsFixed(2)}');
  print('  Sample std: ${normalData.std().toStringAsFixed(2)}');
  print('');

  // Uniform distribution
  print('📈 UNIFORM DISTRIBUTION:');

  final uniformData = DF.rand(12, min: 0, max: 100, seed: 42);
  print('Uniform distribution (0-100):');
  print(
    '  Values: ${uniformData.data.map((x) => x.toStringAsFixed(1)).join(', ')}',
  );
  print('  Min: ${uniformData.min()}');
  print('  Max: ${uniformData.max()}');
  print('  Mean: ${uniformData.mean().toStringAsFixed(2)}');
  print('');

  // Different distribution comparisons
  print('📊 DISTRIBUTION COMPARISON:');
  print('Distribution Type | Mean    | Std Dev | Min     | Max     | Skewness');
  print('─' * 70);

  final distributions = [
    ('Normal(50,10)', DF.randn(100, mean: 50, std: 10, seed: 123)),
    ('Normal(50,20)', DF.randn(100, mean: 50, std: 20, seed: 123)),
    ('Uniform(0,100)', DF.rand(100, min: 0, max: 100, seed: 123)),
    ('Uniform(25,75)', DF.rand(100, min: 25, max: 75, seed: 123)),
  ];

  for (final (name, data) in distributions) {
    final mean = data.mean();
    final std = data.std();
    final min = data.min();
    final max = data.max();

    // Calculate skewness (simplified)
    final values = data.data;
    final skewnessSum = values
        .map((x) => math.pow((x - mean) / std, 3))
        .fold(0.0, (a, b) => a + b);
    final skewness = skewnessSum / values.length;

    print(
      '${name.padRight(16)} | ${mean.toStringAsFixed(2).padLeft(7)} | ${std.toStringAsFixed(2).padLeft(7)} | ${min.toStringAsFixed(2).padLeft(7)} | ${max.toStringAsFixed(2).padLeft(7)} | ${skewness.toStringAsFixed(3).padLeft(8)}',
    );
  }
  print('');

  // Random sampling with different seeds
  print('🎲 REPRODUCIBLE RANDOM DATA:');

  print('Same seed produces identical data:');
  final random1 = DF.randn(8, seed: 42);
  final random2 = DF.randn(8, seed: 42);
  print(
    '  Seed 42 (1st): ${random1.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print(
    '  Seed 42 (2nd): ${random2.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print('  Identical: ${random1.data.toString() == random2.data.toString()}');
  print('');

  print('Different seeds produce different data:');
  final random3 = DF.randn(8, seed: 100);
  final random4 = DF.randn(8, seed: 200);
  print(
    '  Seed 100: ${random3.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print(
    '  Seed 200: ${random4.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates time series generation
void timeSeriesGeneration() {
  print('🔹 TIME SERIES GENERATION\n');

  // Date ranges
  print('📅 DATE RANGES:');

  final dailyDates = DF.dateRange('2024-01-01', '2024-01-10');
  print('Daily dates (2024-01-01 to 2024-01-10):');
  print('  ${dailyDates.data.join(', ')}');
  print('');

  final weeklyDates = DF.dateRange('2024-01-01', '2024-02-01', freq: 'W');
  print('Weekly dates (2024-01-01 to 2024-02-01):');
  print('  ${weeklyDates.data.join(', ')}');
  print('');

  final monthlyDates = DF.dateRange('2024-01-01', '2024-12-01', freq: 'M');
  print('Monthly dates (2024-01-01 to 2024-12-01):');
  print('  ${monthlyDates.data.join(', ')}');
  print('');

  // Time series with patterns
  print('📈 TIME SERIES WITH PATTERNS:');

  final timeSeries = DF.timeSeries(days: 30, seed: 42);
  print('Generated time series (30 days):');
  print(timeSeries.head(10));
  print('... (20 more rows)');
  print('');

  // Custom time series with seasonal patterns
  print('🌊 SEASONAL TIME SERIES:');

  final seasonalData = <Map<String, dynamic>>[];
  final baseDate = DateTime(2024, 1, 1);

  for (var i = 0; i < 365; i++) {
    final date = baseDate.add(Duration(days: i));
    final dayOfYear = i + 1;

    // Seasonal temperature pattern
    final seasonalTemp = 20 + 15 * math.sin(2 * math.pi * dayOfYear / 365);
    final noise = (math.Random(42 + i).nextDouble() - 0.5) * 5;
    final temperature = seasonalTemp + noise;

    // Seasonal sales pattern (higher in winter/summer)
    final seasonalSales =
        1000 +
        500 * math.sin(2 * math.pi * dayOfYear / 365 + math.pi) +
        200 * math.sin(4 * math.pi * dayOfYear / 365);
    final salesNoise = (math.Random(100 + i).nextDouble() - 0.5) * 200;
    final sales = seasonalSales + salesNoise;

    seasonalData.add({
      'date': date.toIso8601String().split('T')[0],
      'day_of_year': dayOfYear,
      'temperature': temperature,
      'sales': sales,
      'month': date.month,
      'quarter': ((date.month - 1) ~/ 3) + 1,
    });
  }

  final seasonalDF = DataFrame.fromRecords(seasonalData);
  print('Seasonal data sample (every 30 days):');
  print('Date       | Day | Temp | Sales | Month | Quarter');
  print('─' * 55);

  for (var i = 0; i < 12; i++) {
    final idx = i * 30;
    if (idx < seasonalDF.length) {
      final date = seasonalDF['date'][idx];
      final day = seasonalDF['day_of_year'][idx];
      final temp = seasonalDF['temperature'][idx] as num;
      final sales = seasonalDF['sales'][idx] as num;
      final month = seasonalDF['month'][idx];
      final quarter = seasonalDF['quarter'][idx];

      print(
        '$date | ${day.toString().padLeft(3)} | ${temp.toStringAsFixed(1).padLeft(4)} | ${sales.toStringAsFixed(0).padLeft(5)} | ${month.toString().padLeft(5)} | ${quarter.toString().padLeft(7)}',
      );
    }
  }
  print('');

  // Trend analysis of generated data
  print('📊 SEASONAL PATTERN ANALYSIS:');

  final temperatures = seasonalDF['temperature'].data.cast<num>();
  final tempSeries = Series<num>(temperatures);

  print('Temperature statistics:');
  print('  Annual mean: ${tempSeries.mean().toStringAsFixed(2)}°C');
  print('  Min temperature: ${tempSeries.min().toStringAsFixed(2)}°C');
  print('  Max temperature: ${tempSeries.max().toStringAsFixed(2)}°C');
  print(
    '  Temperature range: ${(tempSeries.max() - tempSeries.min()).toStringAsFixed(2)}°C',
  );
  print('');

  // Monthly averages
  final monthlyTemps = <int, List<num>>{};
  for (var i = 0; i < seasonalDF.length; i++) {
    final month = seasonalDF['month'][i] as int;
    final temp = seasonalDF['temperature'][i] as num;

    if (!monthlyTemps.containsKey(month)) {
      monthlyTemps[month] = [];
    }
    monthlyTemps[month]!.add(temp);
  }

  print('Monthly temperature averages:');
  print('Month | Avg Temp | Days');
  print('─' * 25);

  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  for (var month = 1; month <= 12; month++) {
    if (monthlyTemps.containsKey(month)) {
      final temps = monthlyTemps[month]!;
      final avgTemp = temps.average;
      print(
        '${monthNames[month - 1].padRight(5)} | ${avgTemp.toStringAsFixed(2).padLeft(8)} | ${temps.length.toString().padLeft(4)}',
      );
    }
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates structured data generation
void structuredDataGeneration() {
  print('🔹 STRUCTURED DATA GENERATION\n');

  // Sample numeric DataFrame
  print('📊 SAMPLE NUMERIC DATAFRAME:');

  final numericSample = DF.sampleNumeric(rows: 8, columns: 4, seed: 42);
  print('Generated numeric DataFrame (8×4):');
  print(numericSample);
  print('');

  print('Numeric data statistics:');
  for (final column in numericSample.columns) {
    final columnData = numericSample[column].data.cast<num>();
    final series = Series<num>(columnData);
    print(
      '  $column: mean=${series.mean().toStringAsFixed(2)}, std=${series.std().toStringAsFixed(2)}',
    );
  }
  print('');

  // Sample mixed DataFrame
  print('🎯 SAMPLE MIXED DATAFRAME:');

  final mixedSample = DF.sampleMixed(rows: 10, seed: 42);
  print('Generated mixed data DataFrame (10 rows):');
  print(mixedSample);
  print('');

  // Custom structured data
  print('🏗️ CUSTOM STRUCTURED DATA:');

  // Generate employee data
  final names = [
    'Alice',
    'Bob',
    'Charlie',
    'Diana',
    'Eve',
    'Frank',
    'Grace',
    'Henry',
  ];
  final departments = ['Engineering', 'Sales', 'Marketing', 'HR'];
  final cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'];

  final employeeData = <Map<String, dynamic>>[];
  final random = math.Random(42);

  for (var i = 0; i < 20; i++) {
    final name = names[random.nextInt(names.length)];
    final department = departments[random.nextInt(departments.length)];
    final city = cities[random.nextInt(cities.length)];
    final age = 22 + random.nextInt(40); // Age 22-62
    final salary = 40000 + random.nextInt(80000); // Salary 40k-120k
    final yearsExp = random.nextInt(20); // Experience 0-20 years

    employeeData.add({
      'employee_id': 1000 + i,
      'name':
          '$name ${String.fromCharCode(65 + random.nextInt(26))}${String.fromCharCode(65 + random.nextInt(26))}',
      'department': department,
      'city': city,
      'age': age,
      'salary': salary,
      'years_experience': yearsExp,
      'performance_score': (60 + random.nextInt(40)).toDouble(), // Score 60-100
    });
  }

  final employeeDF = DataFrame.fromRecords(employeeData);
  print('Generated employee dataset (first 10 rows):');
  print(employeeDF.head(10));
  print('');

  // Analyze generated data
  print('📈 GENERATED DATA ANALYSIS:');

  final deptGroups = employeeDF.groupBy(['department']);
  print('Employees by department:');
  for (final entry in deptGroups.entries) {
    final dept = entry.key;
    final deptData = entry.value;
    final avgSalary = deptData['salary'].data.cast<num>().average;
    final avgAge = deptData['age'].data.cast<num>().average;

    print(
      '  $dept: ${deptData.length} employees, avg salary \$${avgSalary.toStringAsFixed(0)}, avg age ${avgAge.toStringAsFixed(1)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates realistic dataset simulation
void realisticDatasetSimulation() {
  print('🔹 REALISTIC DATASET SIMULATION\n');

  // E-commerce transaction simulation
  print('🛒 E-COMMERCE TRANSACTION SIMULATION:');

  final products = [
    {'name': 'Laptop', 'category': 'Electronics', 'price': 899.99},
    {'name': 'Phone', 'category': 'Electronics', 'price': 699.99},
    {'name': 'Tablet', 'category': 'Electronics', 'price': 399.99},
    {'name': 'Headphones', 'category': 'Audio', 'price': 149.99},
    {'name': 'Speaker', 'category': 'Audio', 'price': 199.99},
    {'name': 'Book', 'category': 'Media', 'price': 19.99},
    {'name': 'Magazine', 'category': 'Media', 'price': 4.99},
    {'name': 'T-Shirt', 'category': 'Clothing', 'price': 24.99},
    {'name': 'Jeans', 'category': 'Clothing', 'price': 79.99},
    {'name': 'Shoes', 'category': 'Clothing', 'price': 129.99},
  ];

  final transactionData = <Map<String, dynamic>>[];
  final random = math.Random(42);
  final startDate = DateTime(2024, 1, 1);

  for (var i = 0; i < 100; i++) {
    final product = products[random.nextInt(products.length)];
    final transactionDate = startDate.add(Duration(days: random.nextInt(90)));
    final quantity = 1 + random.nextInt(5);
    final basePrice = product['price'] as double;
    final discountFactor =
        0.8 + random.nextDouble() * 0.4; // 80%-120% of base price
    final actualPrice = basePrice * discountFactor;
    final customerId = 1000 + random.nextInt(50); // 50 unique customers

    transactionData.add({
      'transaction_id': 'TXN${(10000 + i).toString()}',
      'customer_id': customerId,
      'product_name': product['name'],
      'category': product['category'],
      'quantity': quantity,
      'unit_price': actualPrice,
      'total_amount': actualPrice * quantity,
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
      'month': transactionDate.month,
      'day_of_week': transactionDate.weekday,
    });
  }

  final transactionDF = DataFrame.fromRecords(transactionData);
  print('E-commerce transactions (first 10):');
  print(transactionDF.head(10));
  print('');

  // Transaction analysis
  print('💰 TRANSACTION ANALYSIS:');

  final categoryGroups = transactionDF.groupBy(['category']);
  print('Sales by category:');
  print('Category    | Transactions | Total Revenue | Avg Transaction');
  print('─' * 60);

  for (final entry in categoryGroups.entries) {
    final category = entry.key;
    final categoryData = entry.value;
    final totalRevenue = categoryData['total_amount'].data.cast<num>().sum;
    final avgTransaction = totalRevenue / categoryData.length;

    print(
      '${category.padRight(11)} | ${categoryData.length.toString().padLeft(12)} | \$${totalRevenue.toStringAsFixed(0).padLeft(12)} | \$${avgTransaction.toStringAsFixed(0).padLeft(14)}',
    );
  }
  print('');

  // Customer behavior analysis
  print('👥 CUSTOMER BEHAVIOR ANALYSIS:');

  final customerGroups = transactionDF.groupBy(['customer_id']);
  final customerStats = <Map<String, dynamic>>[];

  for (final entry in customerGroups.entries) {
    final customerId = entry.key;
    final customerData = entry.value;
    final totalSpent = customerData['total_amount'].data.cast<num>().sum;
    final transactionCount = customerData.length;
    final avgOrderValue = totalSpent / transactionCount;
    final uniqueCategories = customerData['category'].data.toSet().length;

    customerStats.add({
      'customer_id': customerId,
      'total_spent': totalSpent,
      'transaction_count': transactionCount,
      'avg_order_value': avgOrderValue,
      'unique_categories': uniqueCategories,
    });
  }

  // Sort by total spent
  customerStats.sort(
    (a, b) => (b['total_spent'] as num).compareTo(a['total_spent'] as num),
  );

  print('Top 10 customers by spending:');
  print('Customer | Total Spent | Orders | Avg Order | Categories');
  print('─' * 55);

  for (var i = 0; i < 10 && i < customerStats.length; i++) {
    final stats = customerStats[i];
    print(
      '${stats['customer_id'].toString().padLeft(8)} | \$${(stats['total_spent'] as num).toStringAsFixed(0).padLeft(10)} | ${stats['transaction_count'].toString().padLeft(6)} | \$${(stats['avg_order_value'] as num).toStringAsFixed(0).padLeft(8)} | ${stats['unique_categories'].toString().padLeft(10)}',
    );
  }
  print('');

  // Time-based analysis
  print('📅 TIME-BASED SALES ANALYSIS:');

  final monthlyGroups = transactionDF.groupBy(['month']);
  print('Monthly sales performance:');
  print('Month | Transactions | Revenue  | Avg Daily Sales');
  print('─' * 45);

  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Keys may be strings or ints depending on grouping; normalize to int
  final sortedMonths =
      monthlyGroups.keys.map((k) => k is int ? k : int.parse(k)).toList()
    ..sort();
  for (final month in sortedMonths) {
    final dynamic key = monthlyGroups.containsKey(month)
        ? month
        : month.toString();
    final monthData = monthlyGroups[key]!;
    final monthRevenue = monthData['total_amount'].data.cast<num>().sum;
    final avgDailySales = monthRevenue / 30; // Approximate

    print(
      '${monthNames[month - 1].padLeft(5)} | ${monthData.length.toString().padLeft(12)} | \$${monthRevenue.toStringAsFixed(0).padLeft(7)} | \$${avgDailySales.toStringAsFixed(0).padLeft(14)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced data patterns
void advancedDataPatterns() {
  print('🔹 ADVANCED DATA PATTERNS\n');

  // Correlated data generation
  print('🔗 CORRELATED DATA GENERATION:');

  final baseValues = DF.randn(50, mean: 100, std: 15, seed: 42);

  // Generate correlated variables
  final stronglyCorrelated = baseValues.data
      .map((x) => x + DF.randn(1, mean: 0, std: 5, seed: 43).data[0])
      .toList();
  final moderatelyCorrelated = baseValues.data
      .map((x) => x * 0.7 + DF.randn(1, mean: 30, std: 10, seed: 44).data[0])
      .toList();
  final negativelyCorrelated = baseValues.data
      .map((x) => 200 - x + DF.randn(1, mean: 0, std: 8, seed: 45).data[0])
      .toList();
  final uncorrelated = DF.randn(50, mean: 100, std: 15, seed: 46).data;

  final correlatedData = DataFrame({
    'base': baseValues.data,
    'strong_positive': stronglyCorrelated,
    'moderate_positive': moderatelyCorrelated,
    'negative': negativelyCorrelated,
    'uncorrelated': uncorrelated,
  });

  print('Correlated data sample (first 10 rows):');
  print(correlatedData.head(10));
  print('');

  // Calculate correlation matrix
  print('Correlation matrix:');
  final correlationMatrix = MathOps.corr(correlatedData);
  print(correlationMatrix);
  print('');

  // Hierarchical data generation
  print('🏗️ HIERARCHICAL DATA GENERATION:');

  final hierarchicalData = <Map<String, dynamic>>[];
  final regions = ['North', 'South', 'East', 'West'];
  final cities = {
    'North': ['New York', 'Boston', 'Philadelphia'],
    'South': ['Miami', 'Atlanta', 'Houston'],
    'East': ['Chicago', 'Detroit', 'Cleveland'],
    'West': ['Los Angeles', 'San Francisco', 'Seattle'],
  };

  final random = math.Random(42);

  for (final region in regions) {
    final regionCities = cities[region]!;
    for (final city in regionCities) {
      for (var store = 1; store <= 3; store++) {
        final baseSales = 1000 + random.nextInt(2000);
        final regionMultiplier = region == 'West'
            ? 1.2
            : region == 'North'
            ? 1.1
            : 1.0;
        final adjustedSales = (baseSales * regionMultiplier).round();

        hierarchicalData.add({
          'region': region,
          'city': city,
          'store_id':
              'S${region[0]}${city.substring(0, 2).toUpperCase()}$store',
          'monthly_sales': adjustedSales,
          'employees': 5 + random.nextInt(15),
          'sq_footage': 1000 + random.nextInt(3000),
        });
      }
    }
  }

  final hierarchicalDF = DataFrame.fromRecords(hierarchicalData);
  print('Hierarchical store data (first 10 stores):');
  print(hierarchicalDF.head(10));
  print('');

  // Analyze hierarchy
  print('📊 HIERARCHICAL ANALYSIS:');

  final regionGroups = hierarchicalDF.groupBy(['region']);
  print('Performance by region:');
  print('Region | Stores | Total Sales | Avg Sales | Total Employees');
  print('─' * 58);

  for (final entry in regionGroups.entries) {
    final region = entry.key;
    final regionData = entry.value;
    final totalSales = regionData['monthly_sales'].data.cast<num>().sum;
    final avgSales = totalSales / regionData.length;
    final totalEmployees = regionData['employees'].data.cast<num>().sum;

    print(
      '${region.padRight(6)} | ${regionData.length.toString().padLeft(6)} | \$${totalSales.toString().padLeft(10)} | \$${avgSales.toStringAsFixed(0).padLeft(8)} | ${totalEmployees.toString().padLeft(15)}',
    );
  }
  print('');

  // Time series with anomalies
  print('🚨 TIME SERIES WITH ANOMALIES:');

  final anomalyData = <Map<String, dynamic>>[];
  final baseDate = DateTime(2024, 1, 1);

  for (var day = 0; day < 90; day++) {
    final date = baseDate.add(Duration(days: day));
    var value = 100 + 20 * math.sin(2 * math.pi * day / 30); // Monthly cycle
    value += (math.Random(42 + day).nextDouble() - 0.5) * 10; // Noise

    // Inject anomalies
    if (day == 15 || day == 45 || day == 75) {
      value *= 2.5; // Spike anomaly
    } else if (day == 30 || day == 60) {
      value *= 0.3; // Dip anomaly
    }

    anomalyData.add({
      'date': date.toIso8601String().split('T')[0],
      'value': value,
      'is_anomaly':
          day == 15 || day == 30 || day == 45 || day == 60 || day == 75,
    });
  }

  final anomalyDF = DataFrame.fromRecords(anomalyData);

  print('Time series with injected anomalies (showing anomaly days):');
  print('Date       | Value  | Anomaly');
  print('─' * 30);

  for (var i = 0; i < anomalyDF.length; i++) {
    final isAnomaly = anomalyDF['is_anomaly'][i] as bool;
    if (isAnomaly) {
      final date = anomalyDF['date'][i];
      final value = anomalyDF['value'][i] as num;
      print('$date | ${value.toStringAsFixed(1).padLeft(6)} | 🚨 YES');
    }
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates performance testing data generation
void performanceTestingData() {
  print('🔹 PERFORMANCE TESTING DATA GENERATION\n');

  // Large dataset generation
  print('⚡ LARGE DATASET GENERATION:');

  final sizes = [1000, 5000, 10000];

  for (final size in sizes) {
    final stopwatch = Stopwatch()..start();

    // Generate large numeric dataset
    final largeData = DF.sampleNumeric(rows: size, columns: 10, seed: 42);

    final generationTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    // Perform basic operations
    final meanCol1 = Series<num>(
      largeData[largeData.columns[0]].data.cast<num>(),
    ).mean();
    final sumCol2 = Series<num>(
      largeData[largeData.columns[1]].data.cast<num>(),
    ).sum();

    final operationTime = stopwatch.elapsedMilliseconds;

    print('Dataset size $size×10:');
    print('  Generation time: ${generationTime}ms');
    print('  Basic operations time: ${operationTime}ms');
    print('  Memory estimate: ~${(size * 10 * 8)} bytes');
    print('  Sample mean: ${meanCol1.toStringAsFixed(2)}');
    print('  Sample sum: ${sumCol2.toStringAsFixed(0)}');
    print('');
  }

  // Stress test data generation
  print('🔥 STRESS TEST SCENARIOS:');

  print('1. Many columns, few rows:');
  final wideData = DF.sampleNumeric(rows: 100, columns: 50, seed: 42);
  print('   Shape: ${wideData.shape}');
  print('   First few column names: ${wideData.columns.take(5).join(', ')}...');
  print('');

  print('2. Few columns, many rows:');
  final longData = DF.sampleNumeric(rows: 5000, columns: 3, seed: 42);
  print('   Shape: ${longData.shape}');
  print('   Column statistics:');
  for (final col in longData.columns) {
    final colData = longData[col].data.cast<num>();
    final series = Series<num>(colData);
    print(
      '     $col: min=${series.min().toStringAsFixed(2)}, max=${series.max().toStringAsFixed(2)}',
    );
  }
  print('');

  print('3. Mixed data types at scale:');
  final mixedLarge = DF.sampleMixed(rows: 2000, seed: 42);
  print('   Shape: ${mixedLarge.shape}');
  print('   Columns: ${mixedLarge.columns.join(', ')}');
  print(
    '   Sample data types: ${mixedLarge.columns.map((col) => '$col: ${mixedLarge[col].dtype}').join(', ')}',
  );
  print('');

  // Memory usage estimation
  print('💾 MEMORY USAGE ESTIMATION:');

  final memoryTests = [
    ('Small (100×5)', 100, 5),
    ('Medium (1K×10)', 1000, 10),
    ('Large (10K×20)', 10000, 20),
    ('XLarge (50K×10)', 50000, 10),
  ];

  print('Dataset Size        | Est. Memory | Generation Time | Access Time');
  print('─' * 68);

  for (final (description, rows, cols) in memoryTests) {
    final estimatedMemory = rows * cols * 8; // 8 bytes per double

    final stopwatch = Stopwatch()..start();
    DF.sampleNumeric(rows: rows, columns: cols, seed: 42);
    final genTime = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    // Access first element
    final accessTime = stopwatch.elapsedMilliseconds;

    print(
      '${description.padRight(19)} | ${(estimatedMemory / 1024).toStringAsFixed(0).padLeft(9)} KB | ${genTime.toString().padLeft(13)}ms | ${accessTime.toString().padLeft(9)}ms',
    );
  }
  print('');

  // Data generation patterns benchmark
  print('🏃 DATA GENERATION PATTERNS BENCHMARK:');

  final patterns = [
    ('Zeros', () => DF.zeros(10000)),
    ('Ones', () => DF.ones(10000)),
    ('Range', () => DF.range(0, 10000)),
    ('Random Uniform', () => DF.rand(10000, seed: 42)),
    ('Random Normal', () => DF.randn(10000, seed: 42)),
  ];

  print('Pattern         | Time (ms) | Memory Est. | Min Value | Max Value');
  print('─' * 65);

  for (final (name, generator) in patterns) {
    final stopwatch = Stopwatch()..start();
    final data = generator();
    final time = stopwatch.elapsedMilliseconds;

    final memoryEst = data.length * 8; // 8 bytes per number
    final minVal = data.min();
    final maxVal = data.max();

    print(
      '${name.padRight(15)} | ${time.toString().padLeft(9)} | ${(memoryEst / 1024).toStringAsFixed(0).padLeft(9)} KB | ${minVal.toStringAsFixed(2).padLeft(9)} | ${maxVal.toStringAsFixed(2).padLeft(9)}',
    );
  }
  print('');

  print('💡 Performance Tips:');
  print('• Use seeds for reproducible data generation');
  print('• Consider memory constraints for large datasets');
  print('• Pre-allocate data structures when possible');
  print('• Use appropriate data types to minimize memory usage');
  print('• Profile your specific use cases for optimal performance');
  print('');

  print('─' * 60);
  print('');
  print('🎉 Sample data generation example complete!');
  print(
    'This example shows how to generate various types of sample data for testing, analysis, and prototyping.',
  );
}
