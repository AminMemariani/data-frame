// ignore_for_file: avoid_print

/// Basic DataFrame and Series Operations Example
///
/// This example demonstrates fundamental operations with DataFrames and Series:
/// - Creating DataFrames and Series from various data sources
/// - Accessing and manipulating data
/// - Basic filtering and transformations
/// - Summary statistics and information
library;


import 'package:data_frame/data_frame.dart';

void main() {
  print('=== Basic DataFrame and Series Operations ===\n');

  // Creating DataFrames and Series
  createDataStructures();

  // Accessing and manipulating data
  accessAndManipulateData();

  // Filtering and transformations
  filteringAndTransformations();

  // Summary and information
  summaryAndInformation();
}

/// Demonstrates various ways to create DataFrames and Series
void createDataStructures() {
  print('🔹 CREATING DATA STRUCTURES\n');

  // Create DataFrame from map
  final productData = DataFrame({
    'product_id': [1, 2, 3, 4, 5],
    'name': ['Laptop', 'Mouse', 'Keyboard', 'Monitor', 'Webcam'],
    'price': [999.99, 29.99, 79.99, 199.99, 59.99],
    'in_stock': [true, true, false, true, true],
  });

  print('📊 DataFrame from Map:');
  print(productData);
  print('');

  // Create DataFrame from records
  final customerRecords = [
    {'id': 1, 'name': 'Alice', 'age': 28, 'city': 'New York'},
    {'id': 2, 'name': 'Bob', 'age': 34, 'city': 'Los Angeles'},
    {'id': 3, 'name': 'Charlie', 'age': 42, 'city': 'Chicago'},
  ];

  final customers = DataFrame.fromRecords(customerRecords);
  print('👥 DataFrame from Records:');
  print(customers);
  print('');

  // Create Series from list
  final prices = Series<double>([999.99, 29.99, 79.99, 199.99, 59.99]);
  print('💰 Series from List:');
  print('Values: ${prices.data}');
  print('Index: ${prices.index}');
  print('');

  // Create Series from map
  final productMap = {
    'laptop': 999.99,
    'mouse': 29.99,
    'keyboard': 79.99,
    'monitor': 199.99,
    'webcam': 59.99,
  };

  final productPrices = Series<double>.fromMap(productMap);
  print('🏷️ Series from Map:');
  print('Values: ${productPrices.data}');
  print('Index: ${productPrices.index}');
  print('');

  // Create DataFrame with custom index
  final customIndexData = DataFrame(
    {
      'temperature': [22.5, 25.1, 21.8, 26.3, 24.7],
      'humidity': [65, 58, 72, 55, 61],
    },
    index: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  );

  print('🌡️ DataFrame with Custom Index:');
  print(customIndexData);
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates data access and manipulation methods
void accessAndManipulateData() {
  print('🔹 ACCESSING AND MANIPULATING DATA\n');

  final salesData = DataFrame({
    'rep_name': ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'],
    'region': ['North', 'South', 'East', 'West', 'North'],
    'sales': [95000, 87000, 102000, 78000, 91000],
    'target': [90000, 85000, 100000, 80000, 90000],
  });

  print('📊 Sales Data:');
  print(salesData);
  print('');

  // Column access
  print('👤 Sales Representative Names:');
  print(salesData['rep_name']);
  print('');

  // Row access by position
  print('📋 First sales record (iloc):');
  print(salesData.iloc(0));
  print('');

  print('📋 Last sales record (iloc):');
  print(salesData.iloc(salesData.length - 1));
  print('');

  // Multiple column access
  print('💼 Sales and Target Columns:');
  final salesAndTarget = DataFrame({
    'sales': salesData['sales'].data,
    'target': salesData['target'].data,
  });
  print(salesAndTarget);
  print('');

  // Series operations
  final salesSeries = salesData['sales'];
  print('📈 Sales Series Operations:');
  print('First 3 values: ${salesSeries.head(3).data}');
  print('Last 2 values: ${salesSeries.tail(2).data}');
  print('Element at index 2: ${salesSeries[2]}');
  print('');

  // DataFrame shape and info
  print('📏 DataFrame Properties:');
  print('Shape: ${salesData.shape}');
  print('Columns: ${salesData.columns}');
  print('Index: ${salesData.index}');
  print('Length: ${salesData.length}');
  print('Is empty: ${salesData.isEmpty}');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates filtering and transformation operations
void filteringAndTransformations() {
  print('🔹 FILTERING AND TRANSFORMATIONS\n');

  final employeeData = DataFrame({
    'name': ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'],
    'department': [
      'Engineering',
      'Sales',
      'Engineering',
      'Marketing',
      'Sales',
      'Engineering',
    ],
    'salary': [75000, 65000, 80000, 60000, 70000, 85000],
    'years_experience': [5, 3, 7, 2, 4, 8],
  });

  print('👥 Employee Data:');
  print(employeeData);
  print('');

  // Filtering DataFrame
  print('🔍 FILTERING OPERATIONS:');

  // Filter by salary
  final highEarners = employeeData.where(
    (row) => (row['salary'] as num) > 70000,
  );
  print('💰 High earners (salary > 70k):');
  print(highEarners);
  print('');

  // Filter by department
  final engineers = employeeData.where(
    (row) => row['department'] == 'Engineering',
  );
  print('👨‍💻 Engineering Department:');
  print(engineers);
  print('');

  // Complex filtering
  final seniorEngineers = employeeData.where(
    (row) =>
        row['department'] == 'Engineering' &&
        (row['years_experience'] as num) >= 7,
  );
  print('🎯 Senior Engineers (7+ years experience):');
  print(seniorEngineers);
  print('');

  // Series filtering
  print('📊 SERIES FILTERING:');

  final salaries = employeeData['salary'];
  final highSalaries = salaries.where((salary) => (salary as num) > 70000);
  print('💵 High salaries: ${highSalaries.data}');

  final experienceLevels = employeeData['years_experience'];
  final experienced = experienceLevels.where((years) => (years as num) >= 5);
  print('🎓 Experienced employees (5+ years): ${experienced.data}');
  print('');

  // Series transformations
  print('🔄 TRANSFORMATIONS:');

  // Map transformation
  final salaryInK = salaries.map<String>(
    (salary) => '${(salary as num) / 1000}k',
  );
  print('💰 Salaries in K format: ${salaryInK.data}');

  // String transformations
  final names = employeeData['name'];
  final upperNames = names.map<String>(
    (name) => (name as String).toUpperCase(),
  );
  print('📝 Names in uppercase: ${upperNames.data}');

  // Numeric transformations
  final bonuses = salaries.map<num>((salary) => (salary as num) * 0.1);
  print('🎁 Calculated bonuses (10% of salary): ${bonuses.data}');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates summary statistics and information methods
void summaryAndInformation() {
  print('🔹 SUMMARY STATISTICS AND INFORMATION\n');

  final performanceData = DataFrame({
    'employee': ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'],
    'q1_sales': [23500, 19800, 25100, 21200, 24800],
    'q2_sales': [26200, 22100, 27300, 19500, 25900],
    'q3_sales': [24800, 20900, 26800, 22800, 26200],
    'q4_sales': [28100, 24300, 29200, 25100, 27800],
  });

  print('📊 Quarterly Performance Data:');
  print(performanceData);
  print('');

  // DataFrame information
  print('📋 DATAFRAME INFORMATION:');
  print(performanceData.summary());
  print('');

  // Series statistics
  print('📈 SERIES STATISTICS:');

  final q1Sales = performanceData['q1_sales'];
  print('Q1 Sales Statistics:');
  final q1SalesNumeric = Series<num>(q1Sales.data.cast<num>());
  print('  Sum: ${q1SalesNumeric.sum()}');
  print('  Mean: ${q1SalesNumeric.mean().toStringAsFixed(2)}');
  print('  Min: ${q1SalesNumeric.min()}');
  print('  Max: ${q1SalesNumeric.max()}');
  print('  Standard Deviation: ${q1SalesNumeric.std().toStringAsFixed(2)}');
  print('');

  // Calculate total sales per employee
  final totalSales = <num>[];
  for (var i = 0; i < performanceData.length; i++) {
    final total =
        (performanceData['q1_sales'][i] as num) +
        (performanceData['q2_sales'][i] as num) +
        (performanceData['q3_sales'][i] as num) +
        (performanceData['q4_sales'][i] as num);
    totalSales.add(total);
  }

  final totalSalesSeries = Series<num>(totalSales);
  print('💰 Total Annual Sales Statistics:');
  print('  Total: ${totalSalesSeries.sum()}');
  print(
    '  Average per employee: ${totalSalesSeries.mean().toStringAsFixed(2)}',
  );
  print('  Best performer: ${totalSalesSeries.max()}');
  print('  Range: ${totalSalesSeries.max() - totalSalesSeries.min()}');
  print('');

  // Display best and worst performers
  final maxIndex = totalSales.indexOf(totalSalesSeries.max());
  final minIndex = totalSales.indexOf(totalSalesSeries.min());

  print('🏆 Performance Highlights:');
  print(
    '  Best Performer: ${performanceData['employee'][maxIndex]} (${totalSales[maxIndex]})',
  );
  print(
    '  Needs Support: ${performanceData['employee'][minIndex]} (${totalSales[minIndex]})',
  );
  print('');

  // Quarterly comparison
  print('📊 Quarterly Analysis:');
  final quarters = ['q1_sales', 'q2_sales', 'q3_sales', 'q4_sales'];
  for (final quarter in quarters) {
    final quarterSeries = performanceData[quarter];
    final quarterSeriesNumeric = Series<num>(quarterSeries.data.cast<num>());
    print(
      '  $quarter: Avg = ${quarterSeriesNumeric.mean().toStringAsFixed(0)}, Total = ${quarterSeriesNumeric.sum()}',
    );
  }
  print('');

  print('─' * 60);
  print('');
  print('✨ Basic operations example complete!');
  print('Next: Try statistical_analysis.dart for advanced analytics');
}
