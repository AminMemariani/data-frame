// ignore_for_file: avoid_print

/// Data I/O Operations Example
///
/// This example demonstrates data input/output capabilities:
/// - Reading and writing CSV files
/// - Reading and writing JSON files
/// - Fetching data from URLs
/// - Handling different data formats and options
/// - Error handling and data validation
library;


import 'package:collection/collection.dart';
import 'package:data_frame/data_frame.dart';
import 'dart:io';

void main() async {
  print('=== Data I/O Operations with Data Frame ===\n');

  // CSV operations
  await csvOperations();

  // JSON operations
  await jsonOperations();

  // URL data fetching
  await urlDataFetching();

  // Advanced I/O options
  await advancedIOOptions();

  // Error handling
  await errorHandlingExamples();

  // Cleanup
  await cleanup();
}

/// Demonstrates CSV file operations
Future<void> csvOperations() async {
  print('🔹 CSV FILE OPERATIONS\n');

  // Create sample sales data
  final salesData = DataFrame({
    'date': [
      '2024-01-01',
      '2024-01-02',
      '2024-01-03',
      '2024-01-04',
      '2024-01-05',
    ],
    'product': ['Laptop', 'Phone', 'Tablet', 'Monitor', 'Keyboard'],
    'category': [
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Accessories',
    ],
    'price': [1299.99, 799.99, 399.99, 299.99, 79.99],
    'quantity': [5, 12, 8, 15, 25],
    'revenue': [6499.95, 9599.88, 3199.92, 4499.85, 1999.75],
    'region': ['North', 'South', 'East', 'West', 'North'],
  });

  print('📊 Sample Sales Data to Export:');
  print(salesData);
  print('');

  final csvPath =
      '/Users/cyberhonig/FlutterProjects/data-frame/example/sales_data.csv';

  try {
    // Export to CSV
    print('💾 Exporting to CSV...');
    await DataIO.toCsv(salesData, csvPath);
    print('✅ Successfully exported to: $csvPath');

    // Check if file exists and show size
    final file = File(csvPath);
    if (await file.exists()) {
      final fileSize = await file.length();
      print('📄 File size: $fileSize bytes');
    }
    print('');

    // Read back from CSV
    print('📖 Reading CSV file...');
    final loadedData = await DataIO.readCsv(csvPath);

    print('✅ Successfully loaded CSV data:');
    print('  Rows: ${loadedData.length}');
    print('  Columns: ${loadedData.columns.length}');
    print('  Column names: ${loadedData.columns}');
    print('');

    print('📋 First few rows of loaded data:');
    print(loadedData.head(3));
    print('');

    // Verify data integrity
    print('🔍 Data Integrity Check:');
    final originalRevenue = salesData['revenue'].sum();
    final loadedRevenue = loadedData['revenue'].data.cast<num>().sum;
    print('  Original total revenue: \$${originalRevenue.toStringAsFixed(2)}');
    print('  Loaded total revenue: \$${loadedRevenue.toStringAsFixed(2)}');
    print(
      '  Data integrity: ${(originalRevenue - loadedRevenue).abs() < 0.01 ? '✅ Verified' : '❌ Failed'}',
    );
    print('');
  } catch (e) {
    print('❌ CSV operation failed: $e');
    print('');
  }

  print('─' * 60);
  print('');
}

/// Demonstrates JSON file operations
Future<void> jsonOperations() async {
  print('🔹 JSON FILE OPERATIONS\n');

  // Create customer data with mixed types
  final customerData = DataFrame({
    'customer_id': [1001, 1002, 1003, 1004, 1005],
    'name': [
      'Alice Johnson',
      'Bob Smith',
      'Charlie Brown',
      'Diana Prince',
      'Eve Wilson',
    ],
    'email': [
      'alice@email.com',
      'bob@email.com',
      'charlie@email.com',
      'diana@email.com',
      'eve@email.com',
    ],
    'age': [28, 34, 45, 29, 37],
    'city': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    'subscription_type': ['Premium', 'Basic', 'Premium', 'Standard', 'Basic'],
    'monthly_spend': [299.99, 49.99, 199.99, 99.99, 29.99],
    'active': [true, true, false, true, true],
    'join_date': [
      '2023-01-15',
      '2023-03-22',
      '2022-11-08',
      '2023-07-14',
      '2023-09-30',
    ],
  });

  print('👥 Customer Data to Export:');
  print(customerData);
  print('');

  final jsonPath =
      '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.json';

  try {
    // Export to JSON (records format)
    print('💾 Exporting to JSON (records format)...');
    await DataIO.toJson(customerData, jsonPath, orient: 'records');
    print('✅ Successfully exported to: $jsonPath');

    // Show a preview of the JSON content
    final file = File(jsonPath);
    if (await file.exists()) {
      final content = await file.readAsString();
      final preview = content.length > 200
          ? '${content.substring(0, 200)}...'
          : content;
      print('📄 JSON preview:');
      print(preview);
      print('');
    }

    // Read back from JSON
    print('📖 Reading JSON file...');
    final loadedData = await DataIO.readJson(jsonPath, orient: 'records');

    print('✅ Successfully loaded JSON data:');
    print('  Rows: ${loadedData.length}');
    print('  Columns: ${loadedData.columns.length}');
    print('  Column names: ${loadedData.columns}');
    print('');

    print('📋 Loaded customer data:');
    print(loadedData);
    print('');

    // Data type verification
    print('🔍 Data Type Check:');
    print('  customer_id type: ${loadedData['customer_id'].dtype}');
    print('  monthly_spend type: ${loadedData['monthly_spend'].dtype}');
    print('  active type: ${loadedData['active'].dtype}');
    print('');
  } catch (e) {
    print('❌ JSON operation failed: $e');
    print('');
  }

  // Try different JSON orientations
  try {
    print('📄 Trying different JSON orientations...');

    // Values orientation
    final valuesPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_values.json';
    await DataIO.toJson(customerData.head(3), valuesPath, orient: 'values');
    print('✅ Exported values orientation to: $valuesPath');

    // Index orientation
    final indexPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_index.json';
    await DataIO.toJson(customerData.head(3), indexPath, orient: 'index');
    print('✅ Exported index orientation to: $indexPath');

    print('');
  } catch (e) {
    print('❌ Alternative JSON formats failed: $e');
    print('');
  }

  print('─' * 60);
  print('');
}

/// Demonstrates URL data fetching
Future<void> urlDataFetching() async {
  print('🔹 URL DATA FETCHING\n');

  print('🌐 Attempting to fetch data from URLs...');
  print('(Note: These examples may fail if URLs are not accessible)');
  print('');

  // Example URLs (these might not be accessible in all environments)
  final testUrls = [
    'https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv',
    'https://jsonplaceholder.typicode.com/users',
  ];

  for (final url in testUrls) {
    try {
      print('🔗 Trying to fetch: $url');

      if (url.endsWith('.csv')) {
        print('  Format: CSV');
        final data = await DataIO.readUrl(url, format: 'csv');
        print(
          '  ✅ Success! Loaded ${data.length} rows, ${data.columns.length} columns',
        );
        print(
          '  📊 Columns: ${data.columns.take(5).join(', ')}${data.columns.length > 5 ? '...' : ''}',
        );
        print('  📋 Sample data:');
        print(data.head(2));
      } else if (url.contains('json')) {
        print('  Format: JSON');
        final data = await DataIO.readUrl(url, format: 'json');
        print(
          '  ✅ Success! Loaded ${data.length} rows, ${data.columns.length} columns',
        );
        print('  📊 Columns: ${data.columns.join(', ')}');
        print('  📋 Sample data:');
        print(data.head(2));
      }

      print('');
    } catch (e) {
      print('  ❌ Failed to fetch data: $e');
      print(
        '  💡 This is normal in restricted environments or when URLs change',
      );
      print('');
    }
  }

  // Demonstrate error handling for invalid URLs
  try {
    print('🔗 Testing invalid URL handling...');
    await DataIO.readUrl(
      'https://invalid-url-that-does-not-exist.com/data.csv',
      format: 'csv',
    );
    print('  ❌ This should not appear');
  } catch (e) {
    print(
      '  ✅ Correctly caught error for invalid URL: ${e.toString().substring(0, 80)}...',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced I/O options
Future<void> advancedIOOptions() async {
  print('🔹 ADVANCED I/O OPTIONS\n');

  // Create data with special characters and null values
  final complexData = DataFrame({
    'id': [1, 2, 3, 4, 5],
    'name': [
      'John "Johnny" Doe',
      'Jane, Smith',
      'Bob\\Wilson',
      'Alice\'s Data',
      'Mike & Co',
    ],
    'description': [
      'Product A, with features',
      'Product B\nMulti-line',
      'Product C',
      null,
      'Product E',
    ],
    'price': [10.99, null, 25.50, 15.75, 8.99],
    'tags': ['tag1,tag2', 'tag3', null, 'tag4,tag5,tag6', 'tag7'],
  });

  print('📊 Complex Data with Special Characters:');
  print(complexData);
  print('');

  // CSV with different separators
  print('📝 CSV WITH DIFFERENT SEPARATORS:');

  try {
    // Semicolon separator
    final semicolonPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/data_semicolon.csv';
    await DataIO.toCsv(complexData, semicolonPath, separator: ';');
    print('✅ Exported with semicolon separator');

    final loadedSemicolon = await DataIO.readCsv(semicolonPath, separator: ';');
    print('✅ Successfully read semicolon-separated data');
    print('  Rows: ${loadedSemicolon.length}');
    print('');

    // Tab separator
    final tabPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/data_tab.csv';
    await DataIO.toCsv(complexData, tabPath, separator: '\t');
    print('✅ Exported with tab separator');

    final loadedTab = await DataIO.readCsv(tabPath, separator: '\t');
    print('✅ Successfully read tab-separated data');
    print('  Rows: ${loadedTab.length}');
    print('');
  } catch (e) {
    print('❌ Advanced separator options failed: $e');
    print('');
  }

  // Custom column names and data types
  print('🏷️ CUSTOM COLUMN NAMES AND DATA TYPES:');

  try {
    // Create CSV without headers
    final noHeaderData = [
      '1,Product A,19.99',
      '2,Product B,29.99',
      '3,Product C,39.99',
    ];

    final noHeaderPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/no_header.csv';
    await File(noHeaderPath).writeAsString(noHeaderData.join('\n'));

    // Read with custom column names
    final customColumns = ['product_id', 'product_name', 'price'];
    final loadedCustom = await DataIO.readCsv(
      noHeaderPath,
      hasHeader: false,
      columnNames: customColumns,
    );

    print('✅ Successfully read CSV with custom column names:');
    print(loadedCustom);
    print('');
  } catch (e) {
    print('❌ Custom column operations failed: $e');
    print('');
  }

  // Handling large datasets (simulation)
  print('📏 HANDLING DIFFERENT DATA SIZES:');

  try {
    // Create a larger dataset
    final largeData = DataFrame({
      'id': List.generate(1000, (i) => i + 1),
      'value': List.generate(1000, (i) => (i * 1.5).toStringAsFixed(2)),
      'category': List.generate(1000, (i) => 'Category ${i % 10}'),
      'timestamp': List.generate(1000, (i) => '2024-01-${(i % 28) + 1}:02d}'),
    });

    print('📊 Created large dataset: ${largeData.shape}');

    final largePath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/large_data.csv';
    final stopwatch = Stopwatch()..start();

    await DataIO.toCsv(largeData, largePath);
    final writeTime = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    final loadedLarge = await DataIO.readCsv(largePath);
    final readTime = stopwatch.elapsedMilliseconds;

    print('⏱️ Performance metrics:');
    print('  Write time: ${writeTime}ms');
    print('  Read time: ${readTime}ms');
    print('  Rows loaded: ${loadedLarge.length}');
    print('  Columns loaded: ${loadedLarge.columns.length}');
    print('');
  } catch (e) {
    print('❌ Large data handling failed: $e');
    print('');
  }

  print('─' * 60);
  print('');
}

/// Demonstrates error handling in I/O operations
Future<void> errorHandlingExamples() async {
  print('🔹 ERROR HANDLING EXAMPLES\n');

  print('🚨 Testing various error conditions...');
  print('');

  // Test 1: Non-existent file
  try {
    print('Test 1: Reading non-existent file');
    await DataIO.readCsv(
      '/Users/cyberhonig/FlutterProjects/data-frame/example/non_existent.csv',
    );
    print('  ❌ This should not appear');
  } catch (e) {
    print('  ✅ Correctly caught file not found error');
    print('  📝 Error: ${e.toString().substring(0, 100)}...');
  }
  print('');

  // Test 2: Invalid file permissions (simulation)
  try {
    print('Test 2: Writing to protected directory');
    final protectedData = DataFrame({
      'test': [1, 2, 3],
    });
    await DataIO.toCsv(protectedData, '/root/protected.csv');
    print('  ❌ This should not appear in most systems');
  } catch (e) {
    print('  ✅ Correctly caught permission error');
    print('  📝 Error type: ${e.runtimeType}');
  }
  print('');

  // Test 3: Malformed CSV
  try {
    print('Test 3: Reading malformed CSV');
    const malformedCsv = '''
name,age,city
John,25,New York
Jane,30
Bob,35,Chicago,Extra
''';

    final malformedPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/malformed.csv';
    await File(malformedPath).writeAsString(malformedCsv);

    final data = await DataIO.readCsv(malformedPath);
    print('  ⚠️ Loaded malformed CSV: ${data.length} rows');
    print('  📊 Data preview:');
    print(data);
  } catch (e) {
    print('  ✅ Correctly caught malformed CSV error');
    print('  📝 Error: ${e.toString().substring(0, 100)}...');
  }
  print('');

  // Test 4: Invalid JSON
  try {
    print('Test 4: Reading invalid JSON');
    const invalidJson = '{"name": "John", "age": 25, invalid}';

    final invalidJsonPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/invalid.json';
    await File(invalidJsonPath).writeAsString(invalidJson);

    await DataIO.readJson(invalidJsonPath);
    print('  ❌ This should not appear');
  } catch (e) {
    print('  ✅ Correctly caught invalid JSON error');
    print('  📝 Error: ${e.toString().substring(0, 100)}...');
  }
  print('');

  // Test 5: Empty data handling
  try {
    print('Test 5: Handling empty data');
    final emptyData = DataFrame.empty();
    final emptyPath =
        '/Users/cyberhonig/FlutterProjects/data-frame/example/empty.csv';

    await DataIO.toCsv(emptyData, emptyPath);
    final loadedEmpty = await DataIO.readCsv(emptyPath);

    print('  ✅ Successfully handled empty data');
    print('  📊 Loaded shape: ${loadedEmpty.shape}');
    print('  📝 Is empty: ${loadedEmpty.isEmpty}');
  } catch (e) {
    print('  ❌ Empty data handling failed: $e');
  }
  print('');

  print('💡 Error Handling Best Practices:');
  print('  • Always wrap I/O operations in try-catch blocks');
  print('  • Check file existence before reading');
  print('  • Validate data structure after loading');
  print('  • Handle network timeouts for URL operations');
  print('  • Use appropriate file permissions');
  print('');

  print('─' * 60);
  print('');
}

/// Clean up temporary files
Future<void> cleanup() async {
  print('🔹 CLEANUP\n');

  final filesToClean = [
    '/Users/cyberhonig/FlutterProjects/data-frame/example/sales_data.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_data.json',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_values.json',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/customer_index.json',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/data_semicolon.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/data_tab.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/no_header.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/large_data.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/malformed.csv',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/invalid.json',
    '/Users/cyberhonig/FlutterProjects/data-frame/example/empty.csv',
  ];

  var cleanedCount = 0;

  for (final filePath in filesToClean) {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        cleanedCount++;
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  print('🧹 Cleaned up $cleanedCount temporary files');
  print('');
  print('─' * 60);
  print('');
  print('✨ Data I/O operations example complete!');
  print('💡 Key takeaways:');
  print('  • CSV and JSON are fully supported with various options');
  print('  • URL fetching works for accessible endpoints');
  print('  • Custom separators and column names are supported');
  print('  • Always implement proper error handling');
  print('  • Consider performance for large datasets');
}
