// ignore_for_file: avoid_print

/// Comprehensive Data Frame library example
///
/// This example demonstrates the core features of the data_frame package:
/// - Creating and manipulating DataFrames and Series
/// - Statistical analysis and hypothesis testing
/// - Data I/O operations
/// - Mathematical operations and transformations
/// - Advanced data manipulation techniques
library;

import 'package:data_frame/data_frame.dart';

void main() async {
  print('=== Data Frame Library - Comprehensive Example ===\n');

  // Basic DataFrame and Series Operations
  await basicOperations();

  // Statistical Analysis
  await statisticalAnalysis();

  // Data I/O Operations
  await dataIOOperations();

  // Mathematical Operations
  await mathematicalOperations();

  // Advanced Data Manipulation
  await advancedDataManipulation();

  // Sample Data Generation
  await sampleDataGeneration();

  // Real-world Analysis Example
  await realWorldAnalysis();
}

/// Demonstrates basic DataFrame and Series operations
Future<void> basicOperations() async {
  print('🔹 BASIC OPERATIONS\n');

  // Create a DataFrame from a map
  final salesData = DataFrame({
    'product': ['Laptop', 'Phone', 'Tablet', 'Watch', 'Headphones'],
    'price': [1299.99, 799.99, 399.99, 249.99, 149.99],
    'quantity': [25, 45, 32, 18, 67],
    'category': [
      'Electronics',
      'Electronics',
      'Electronics',
      'Wearables',
      'Audio',
    ],
  });

  print('📊 Sales Data:');
  print(salesData);
  print('');

  // Basic information
  print('📈 DataFrame Info:');
  print('Shape: ${salesData.shape}');
  print('Columns: ${salesData.columns}');
  print('Length: ${salesData.length}');
  print('');

  // Access columns and rows
  print('💰 Product Prices:');
  print(salesData['price'].head());
  print('');

  print('🏷️ First product details:');
  print(salesData.iloc(0));
  print('');

  // Filtering data
  final expensiveProducts = salesData.where(
    (row) => (row['price'] as num) > 500,
  );
  print('💎 Expensive Products (>\$500):');
  print(expensiveProducts);
  print('');

  // Create and manipulate Series
  final prices = Series<num>([1299.99, 799.99, 399.99, 249.99, 149.99]);
  print('📊 Price Statistics:');
  print('Mean: \$${prices.mean().toStringAsFixed(2)}');
  print('Max: \$${prices.max().toStringAsFixed(2)}');
  print('Min: \$${prices.min().toStringAsFixed(2)}');
  print(
    'Sum: \$${prices.data.cast<num>().fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates statistical analysis capabilities
Future<void> statisticalAnalysis() async {
  print('🔹 STATISTICAL ANALYSIS\n');

  // Create sample data for analysis
  final group1 = Series<num>([23, 25, 28, 22, 26, 24, 27, 29, 21, 25]);
  final group2 = Series<num>([31, 33, 35, 30, 34, 32, 36, 38, 29, 33]);

  print('📊 Group 1 data: ${group1.data}');
  print('📊 Group 2 data: ${group2.data}');
  print('');

  // Descriptive statistics
  final stats1 = Statistics.descriptiveStats(group1);
  final stats2 = Statistics.descriptiveStats(group2);

  print('📈 Group 1 Statistics:');
  print('  Mean: ${stats1['mean']?.toStringAsFixed(2)}');
  print('  Std Dev: ${stats1['std']?.toStringAsFixed(2)}');
  print('  Median: ${stats1['median']?.toStringAsFixed(2)}');
  print('  Q1: ${stats1['q1']?.toStringAsFixed(2)}');
  print('  Q3: ${stats1['q3']?.toStringAsFixed(2)}');
  print('');

  print('📈 Group 2 Statistics:');
  print('  Mean: ${stats2['mean']?.toStringAsFixed(2)}');
  print('  Std Dev: ${stats2['std']?.toStringAsFixed(2)}');
  print('  Median: ${stats2['median']?.toStringAsFixed(2)}');
  print('  Q1: ${stats2['q1']?.toStringAsFixed(2)}');
  print('  Q3: ${stats2['q3']?.toStringAsFixed(2)}');
  print('');

  // T-test
  final tTestResult = Statistics.tTest(group1, group2);
  print('🧪 T-Test Results:');
  print('  t-statistic: ${tTestResult['t_statistic']?.toStringAsFixed(4)}');
  print('  p-value: ${tTestResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  degrees of freedom: ${tTestResult['degrees_of_freedom']?.toStringAsFixed(0)}',
  );
  print('');

  // Correlation analysis
  final x = Series<num>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  final y = Series<num>([
    2.1,
    3.9,
    6.2,
    7.8,
    10.1,
    11.9,
    14.2,
    15.8,
    18.1,
    20.0,
  ]);

  final correlation = Statistics.correlationTest(x, y);
  print('📊 Correlation Analysis:');
  print('  X data: ${x.data}');
  print('  Y data: ${y.data}');
  print(
    '  Correlation coefficient: ${correlation['correlation']?.toStringAsFixed(4)}',
  );
  print('  P-value: ${correlation['p_value']?.toStringAsFixed(6)}');
  print('');

  // Linear regression
  final regression = Statistics.linearRegression(x, y);
  print('📈 Linear Regression:');
  print('  Slope: ${regression['slope']?.toStringAsFixed(4)}');
  print('  Intercept: ${regression['intercept']?.toStringAsFixed(4)}');
  print('  R-squared: ${regression['r_squared']?.toStringAsFixed(4)}');
  print(
    '  Equation: y = ${regression['slope']?.toStringAsFixed(2)}x + ${regression['intercept']?.toStringAsFixed(2)}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates data I/O operations
Future<void> dataIOOperations() async {
  print('🔹 DATA I/O OPERATIONS\n');

  // Create sample data
  final customerData = DataFrame({
    'customer_id': [1001, 1002, 1003, 1004, 1005],
    'name': [
      'Alice Johnson',
      'Bob Smith',
      'Charlie Brown',
      'Diana Prince',
      'Eve Wilson',
    ],
    'age': [28, 34, 45, 29, 37],
    'city': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    'subscription': ['Premium', 'Basic', 'Premium', 'Standard', 'Basic'],
    'monthly_spend': [299.99, 49.99, 199.99, 99.99, 29.99],
  });

  print('💾 Customer Data to Export:');
  print(customerData);
  print('');

  // Export to CSV
  try {
    await DataIO.toCsv(
      customerData,
      '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.csv',
    );
    print('✅ Data exported to CSV successfully');

    // Read back from CSV
    final loadedData = await DataIO.readCsv(
      '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.csv',
    );
    print('📖 Data loaded from CSV:');
    print('  Rows loaded: ${loadedData.length}');
    print('  Columns: ${loadedData.columns}');
    print('');
  } catch (e) {
    print('❌ CSV operations error: $e');
  }

  // Export to JSON
  try {
    await DataIO.toJson(
      customerData,
      '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.json',
    );
    print('✅ Data exported to JSON successfully');

    // Read back from JSON
    final jsonData = await DataIO.readJson(
      '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.json',
    );
    print('📖 Data loaded from JSON:');
    print('  Rows loaded: ${jsonData.length}');
    print('  Columns: ${jsonData.columns}');
    print('');
  } catch (e) {
    print('❌ JSON operations error: $e');
  }

  print('─' * 60);
  print('');
}

/// Demonstrates mathematical operations
Future<void> mathematicalOperations() async {
  print('🔹 MATHEMATICAL OPERATIONS\n');

  // Create sample numeric data
  final mathData = DataFrame({
    'a': [1.0, 2.0, 3.0, 4.0, 5.0],
    'b': [2.5, 3.5, 4.5, 5.5, 6.5],
    'c': [10.0, 20.0, 30.0, 40.0, 50.0],
  });

  print('📊 Original Data:');
  print(mathData);
  print('');

  // Basic arithmetic operations
  final added = MathOps.add(mathData, 10);
  print('➕ Data + 10:');
  print(added);
  print('');

  final multiplied = MathOps.multiply(mathData, 2);
  print('✖️ Data × 2:');
  print(multiplied);
  print('');

  // Mathematical functions
  final sqrtData = MathOps.sqrt(mathData);
  print('√ Square Root:');
  print(sqrtData);
  print('');

  final logData = MathOps.log(mathData);
  print('📈 Natural Logarithm:');
  print(logData);
  print('');

  // Rolling statistics
  final rollingMean = MathOps.rollingMean(mathData, 3);
  print('📊 Rolling Mean (window=3):');
  print(rollingMean);
  print('');

  // Cumulative operations
  final cumSum = MathOps.cumSum(mathData);
  print('📈 Cumulative Sum:');
  print(cumSum);
  print('');

  // Correlation matrix
  final corrMatrix = MathOps.corr(mathData);
  print('🔗 Correlation Matrix:');
  print(corrMatrix);
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced data manipulation
Future<void> advancedDataManipulation() async {
  print('🔹 ADVANCED DATA MANIPULATION\n');

  // Create sample datasets for joining
  final employees = DataFrame({
    'emp_id': [1, 2, 3, 4],
    'name': ['Alice', 'Bob', 'Charlie', 'Diana'],
    'department_id': [101, 102, 101, 103],
  });

  final departments = DataFrame({
    'dept_id': [101, 102, 103, 104],
    'dept_name': ['Engineering', 'Marketing', 'Sales', 'HR'],
    'budget': [500000, 200000, 300000, 150000],
  });

  print('👥 Employees:');
  print(employees);
  print('');

  print('🏢 Departments:');
  print(departments);
  print('');

  // Join operations (need to align column names for joining)
  final employeesForJoin = DataFrame({
    'emp_id': [1, 2, 3, 4],
    'name': ['Alice', 'Bob', 'Charlie', 'Diana'],
    'dept_id': [101, 102, 101, 103],
  });

  final joined = employeesForJoin.join(
    departments,
    on: 'dept_id',
    how: 'inner',
  );
  print('🔗 Joined Data (Employees + Departments):');
  print(joined);
  print('');

  // Grouping operations
  final salesData = DataFrame({
    'region': [
      'North',
      'South',
      'North',
      'East',
      'South',
      'West',
      'North',
      'East',
    ],
    'product': ['A', 'B', 'A', 'C', 'B', 'A', 'C', 'A'],
    'sales': [100, 150, 200, 120, 180, 90, 160, 140],
    'quarter': ['Q1', 'Q1', 'Q2', 'Q1', 'Q2', 'Q1', 'Q2', 'Q2'],
  });

  print('📊 Sales Data for Grouping:');
  print(salesData);
  print('');

  final regionGroups = salesData.groupBy(['region']);
  print('🌍 Sales by Region:');
  for (final entry in regionGroups.entries) {
    final regionSales = entry.value['sales'].data.cast<num>().fold(
      0.0,
      (a, b) => a + b,
    );
    print('  ${entry.key}: \$${regionSales.toStringAsFixed(0)}');
  }
  print('');

  // Sorting
  final sortedByName = employees.sortBy(['name']);
  print('📝 Employees Sorted by Name:');
  print(sortedByName);
  print('');

  // Data cleaning - handling null values
  final dataWithNulls = DataFrame({
    'col1': [1, 2, null, 4, 5],
    'col2': [10, null, 30, 40, null],
    'col3': ['a', 'b', 'c', null, 'e'],
  });

  print('🔧 Data with Null Values:');
  print(dataWithNulls);
  print('');

  final cleaned = dataWithNulls.dropna();
  print('✨ Data After Dropping Nulls:');
  print(cleaned);
  print('');

  final filled = dataWithNulls.fillna(0);
  print('🔧 Data After Filling Nulls with 0:');
  print(filled);
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates sample data generation utilities
Future<void> sampleDataGeneration() async {
  print('🔹 SAMPLE DATA GENERATION\n');

  // Generate various types of Series
  final rangeData = DF.range(0, 10, step: 2);
  print('📊 Range Data (0 to 10, step 2):');
  print(rangeData.data);
  print('');

  final zerosData = DF.zeros(5);
  print('🔢 Zeros (length 5):');
  print(zerosData.data);
  print('');

  final onesData = DF.ones(5);
  print('1️⃣ Ones (length 5):');
  print(onesData.data);
  print('');

  final randomNormal = DF.randn(10, mean: 50, std: 10, seed: 42);
  print('📈 Random Normal Distribution (mean=50, std=10):');
  print(
    'Values: ${randomNormal.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print('Mean: ${randomNormal.mean().toStringAsFixed(2)}');
  print('Std: ${randomNormal.std().toStringAsFixed(2)}');
  print('');

  final randomUniform = DF.rand(10, min: 0, max: 100, seed: 42);
  print('📊 Random Uniform Distribution (0-100):');
  print(
    'Values: ${randomUniform.data.map((x) => x.toStringAsFixed(2)).join(', ')}',
  );
  print('');

  // Date ranges
  final dateRange = DF.dateRange('2024-01-01', '2024-01-07');
  print('📅 Date Range (2024-01-01 to 2024-01-07):');
  print(dateRange.data);
  print('');

  // Sample DataFrames
  final sampleNumeric = DF.sampleNumeric(rows: 5, columns: 3, seed: 42);
  print('📊 Sample Numeric DataFrame (5×3):');
  print(sampleNumeric);
  print('');

  final sampleMixed = DF.sampleMixed(rows: 5, seed: 42);
  print('🎯 Sample Mixed Data DataFrame:');
  print(sampleMixed);
  print('');

  final timeSeries = DF.timeSeries(days: 7, seed: 42);
  print('📈 Time Series Data (7 days):');
  print(timeSeries);
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates a real-world data analysis scenario
Future<void> realWorldAnalysis() async {
  print('🔹 REAL-WORLD ANALYSIS: SALES PERFORMANCE\n');

  // Create realistic sales data
  final salesPerformance = DataFrame({
    'month': [
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
    ],
    'revenue': [
      125000,
      142000,
      158000,
      167000,
      189000,
      203000,
      215000,
      198000,
      176000,
      164000,
      151000,
      187000,
    ],
    'costs': [
      78000,
      86000,
      94000,
      98000,
      107000,
      118000,
      125000,
      119000,
      105000,
      98000,
      89000,
      108000,
    ],
    'customers': [450, 520, 580, 620, 710, 780, 820, 760, 680, 620, 570, 720],
    'conversion_rate': [
      2.3,
      2.7,
      2.9,
      3.1,
      3.5,
      3.8,
      4.1,
      3.9,
      3.4,
      3.1,
      2.8,
      3.6,
    ],
  });

  print('📊 Monthly Sales Performance Data:');
  print(salesPerformance);
  print('');

  // Calculate derived metrics
  final revenueData = salesPerformance['revenue'].data.cast<num>();
  final costsData = salesPerformance['costs'].data.cast<num>();
  final customersData = salesPerformance['customers'].data.cast<num>();

  // Add profit column
  final profits = revenueData
      .asMap()
      .entries
      .map((entry) => entry.value - costsData[entry.key])
      .toList();
  final profitMargins = profits
      .asMap()
      .entries
      .map((entry) => (entry.value / revenueData[entry.key]) * 100)
      .toList();
  final revenuePerCustomer = revenueData
      .asMap()
      .entries
      .map((entry) => entry.value / customersData[entry.key])
      .toList();

  final enhancedData = DataFrame({
    'month': salesPerformance['month'].data,
    'revenue': revenueData,
    'costs': costsData,
    'profit': profits,
    'profit_margin': profitMargins,
    'customers': customersData,
    'revenue_per_customer': revenuePerCustomer,
    'conversion_rate': salesPerformance['conversion_rate'].data,
  });

  print('📈 Enhanced Analysis with Calculated Metrics:');
  print(enhancedData);
  print('');

  // Summary statistics
  print('💼 BUSINESS INSIGHTS:');
  print('─' * 40);

  final totalRevenue = Series<num>(
    revenueData,
  ).data.cast<num>().fold(0.0, (a, b) => a + b);
  final totalCosts = Series<num>(
    costsData,
  ).data.cast<num>().fold(0.0, (a, b) => a + b);
  final totalProfit = totalRevenue - totalCosts;
  final avgProfitMargin = Series<num>(profitMargins).mean();

  print('💰 Financial Summary:');
  print('  Total Revenue: \$${totalRevenue.toStringAsFixed(0)}');
  print('  Total Costs: \$${totalCosts.toStringAsFixed(0)}');
  print('  Total Profit: \$${totalProfit.toStringAsFixed(0)}');
  print('  Average Profit Margin: ${avgProfitMargin.toStringAsFixed(1)}%');
  print('');

  // Find best and worst performing months
  final maxRevenueIndex = revenueData.indexOf(
    revenueData.reduce((a, b) => a > b ? a : b),
  );
  final minRevenueIndex = revenueData.indexOf(
    revenueData.reduce((a, b) => a < b ? a : b),
  );
  final maxProfitIndex = profits.indexOf(
    profits.reduce((a, b) => a > b ? a : b),
  );

  print('🏆 Performance Highlights:');
  print(
    '  Best Revenue Month: ${salesPerformance['month'][maxRevenueIndex]} (\$${revenueData[maxRevenueIndex].toStringAsFixed(0)})',
  );
  print(
    '  Worst Revenue Month: ${salesPerformance['month'][minRevenueIndex]} (\$${revenueData[minRevenueIndex].toStringAsFixed(0)})',
  );
  print(
    '  Best Profit Month: ${salesPerformance['month'][maxProfitIndex]} (\$${profits[maxProfitIndex].toStringAsFixed(0)})',
  );
  print('');

  // Customer analysis
  final avgCustomers = Series<num>(customersData).mean();
  final avgRevenuePerCustomer = Series<num>(revenuePerCustomer).mean();
  final conversionRates = salesPerformance['conversion_rate'].data.cast<num>();
  final avgConversionRate =
      conversionRates.fold(0.0, (a, b) => a + b) / conversionRates.length;

  print('👥 Customer Insights:');
  print('  Average Monthly Customers: ${avgCustomers.toStringAsFixed(0)}');
  print(
    '  Average Revenue per Customer: \$${avgRevenuePerCustomer.toStringAsFixed(2)}',
  );
  print('  Average Conversion Rate: ${avgConversionRate.toStringAsFixed(1)}%');
  print('');

  // Growth analysis
  final q1Revenue = revenueData.take(3).fold(0.0, (a, b) => a + b);
  final q4Revenue = revenueData.skip(9).fold(0.0, (a, b) => a + b);
  final yearOverYearGrowth = ((q4Revenue - q1Revenue) / q1Revenue) * 100;

  print('📈 Growth Analysis:');
  print('  Q1 Revenue: \$${q1Revenue.toStringAsFixed(0)}');
  print('  Q4 Revenue: \$${q4Revenue.toStringAsFixed(0)}');
  print('  Q4 vs Q1 Growth: ${yearOverYearGrowth.toStringAsFixed(1)}%');
  print('');

  // Correlation analysis between metrics
  final revenuesSeries = Series<num>(
    revenueData,
    index: List.generate(revenueData.length, (i) => i.toString()),
  );
  final customersSeries = Series<num>(
    customersData,
    index: List.generate(customersData.length, (i) => i.toString()),
  );
  final conversionSeries = Series<num>(
    salesPerformance['conversion_rate'].data.cast<num>(),
    index: List.generate(
      salesPerformance['conversion_rate'].length,
      (i) => i.toString(),
    ),
  );

  final revenueCustomerCorr = Statistics.correlationTest(
    revenuesSeries,
    customersSeries,
  );
  final revenueConversionCorr = Statistics.correlationTest(
    revenuesSeries,
    conversionSeries,
  );

  print('🔗 Correlation Analysis:');
  print(
    '  Revenue vs Customers: ${revenueCustomerCorr['correlation']?.toStringAsFixed(3)}',
  );
  print(
    '  Revenue vs Conversion Rate: ${revenueConversionCorr['correlation']?.toStringAsFixed(3)}',
  );
  print('');

  // Recommendations
  print('💡 RECOMMENDATIONS:');
  print('─' * 40);
  print('1. Focus on customer acquisition - strong correlation with revenue');
  print('2. Improve conversion rates in low-performing months');
  print('3. Investigate cost spikes in high-revenue months');
  print('4. Maintain momentum from strong Q4 performance');
  print('');

  print('─' * 60);
  print('');
  print(
    '🎉 Analysis Complete! Check example/ folder for more specific examples.',
  );
}
