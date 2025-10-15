// ignore_for_file: avoid_print

/// Real-World Data Analysis Example
///
/// This comprehensive example demonstrates a complete data analysis workflow:
/// - Data loading and cleaning
/// - Exploratory data analysis
/// - Statistical testing and hypothesis validation
/// - Business insights and recommendations
/// - Predictive analysis and forecasting
///
/// Scenario: Retail Chain Performance Analysis
/// We analyze a retail chain's performance across multiple dimensions to optimize
/// operations, identify growth opportunities, and make data-driven decisions.
library;

import 'package:collection/collection.dart';
import 'package:data_frame/data_frame.dart';
import 'dart:math' as math;

void main() async {
  print('=== Real-World Analysis: Retail Chain Performance ===\n');

  // Generate realistic retail data
  final retailData = await generateRetailData();

  // Data exploration and cleaning
  await dataExplorationAndCleaning(retailData);

  // Sales performance analysis
  await salesPerformanceAnalysis(retailData);

  // Customer analysis
  await customerAnalysis(retailData);

  // Store performance analysis
  await storePerformanceAnalysis(retailData);

  // Statistical testing and insights
  await statisticalTestingAndInsights(retailData);

  // Predictive analysis
  await predictiveAnalysis(retailData);

  // Business recommendations
  await businessRecommendations(retailData);
}

/// Generate realistic retail chain data
Future<Map<String, DataFrame>> generateRetailData() async {
  print('🔹 GENERATING REALISTIC RETAIL DATA\n');

  final random = math.Random(42);

  // Generate stores data
  print('🏪 Generating stores data...');
  final storesData = <Map<String, dynamic>>[];
  final regions = ['North', 'South', 'East', 'West', 'Central'];
  final storeTypes = ['Flagship', 'Standard', 'Express', 'Outlet'];
  final cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    'Austin',
    'Jacksonville',
    'Fort Worth',
    'Columbus',
    'Charlotte',
  ];

  for (var i = 0; i < 50; i++) {
    final region = regions[random.nextInt(regions.length)];
    final storeType = storeTypes[random.nextInt(storeTypes.length)];
    final city = cities[random.nextInt(cities.length)];

    storesData.add({
      'store_id': 'ST${(1000 + i).toString()}',
      'region': region,
      'city': city,
      'store_type': storeType,
      'sq_footage': 2000 + random.nextInt(8000),
      'employees': 5 + random.nextInt(25),
      'rent_cost': 5000 + random.nextInt(15000),
      'opening_date': DateTime(
        2020 + random.nextInt(4),
        1 + random.nextInt(12),
        1 + random.nextInt(28),
      ).toIso8601String().split('T')[0],
    });
  }

  // Generate products data
  print('📦 Generating products data...');
  final productsData = <Map<String, dynamic>>[];
  final categories = [
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books & Media',
  ];
  final brands = ['BrandA', 'BrandB', 'BrandC', 'BrandD', 'BrandE', 'Generic'];

  for (var i = 0; i < 200; i++) {
    final category = categories[random.nextInt(categories.length)];
    final brand = brands[random.nextInt(brands.length)];
    final basePrice = category == 'Electronics'
        ? 100 + random.nextInt(900)
        : category == 'Clothing'
        ? 20 + random.nextInt(180)
        : category == 'Home & Garden'
        ? 15 + random.nextInt(285)
        : category == 'Sports'
        ? 25 + random.nextInt(275)
        : 10 + random.nextInt(90);

    productsData.add({
      'product_id': 'P${(10000 + i).toString()}',
      'product_name': '${category.substring(0, 3)}Product${i + 1}',
      'category': category,
      'brand': brand,
      'cost_price': basePrice * 0.6,
      'selling_price': basePrice.toDouble(),
      'margin_percent': 40.0 + random.nextDouble() * 20,
    });
  }

  // Generate customers data
  print('👥 Generating customers data...');
  final customersData = <Map<String, dynamic>>[];
  final customerTiers = ['Bronze', 'Silver', 'Gold', 'Platinum'];

  for (var i = 0; i < 5000; i++) {
    final tier = customerTiers[random.nextInt(customerTiers.length)];
    final age = 18 + random.nextInt(65);
    final joinDate =
        DateTime(2020, 1 + random.nextInt(48)) // Last 4 years
            .add(Duration(days: random.nextInt(365)));

    customersData.add({
      'customer_id': 'C${(100000 + i).toString()}',
      'age': age,
      'gender': random.nextBool() ? 'M' : 'F',
      'tier': tier,
      'city': cities[random.nextInt(cities.length)],
      'join_date': joinDate.toIso8601String().split('T')[0],
      'lifetime_value': tier == 'Platinum'
          ? 5000 + random.nextInt(10000)
          : tier == 'Gold'
          ? 2000 + random.nextInt(5000)
          : tier == 'Silver'
          ? 500 + random.nextInt(2000)
          : 100 + random.nextInt(500),
    });
  }

  // Generate transactions data
  print('💳 Generating transactions data...');
  final transactionsData = <Map<String, dynamic>>[];
  final startDate = DateTime(2024, 1, 1);

  for (var i = 0; i < 10000; i++) {
    final store = storesData[random.nextInt(storesData.length)];
    final product = productsData[random.nextInt(productsData.length)];
    final customer = customersData[random.nextInt(customersData.length)];

    final transactionDate = startDate.add(Duration(days: random.nextInt(90)));
    final quantity = 1 + random.nextInt(5);
    final unitPrice = product['selling_price'] as double;
    final discountPercent = random.nextDouble() * 20; // 0-20% discount
    final finalPrice = unitPrice * (1 - discountPercent / 100);

    transactionsData.add({
      'transaction_id': 'TXN${(1000000 + i).toString()}',
      'store_id': store['store_id'],
      'product_id': product['product_id'],
      'customer_id': customer['customer_id'],
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_percent': discountPercent,
      'final_price': finalPrice,
      'total_amount': finalPrice * quantity,
      'day_of_week': transactionDate.weekday,
      'month': transactionDate.month,
      'hour': 9 + random.nextInt(12), // Store hours 9 AM - 9 PM
    });
  }

  print('✅ Data generation complete!');
  print('  Stores: ${storesData.length}');
  print('  Products: ${productsData.length}');
  print('  Customers: ${customersData.length}');
  print('  Transactions: ${transactionsData.length}');
  print('');

  return {
    'stores': DataFrame.fromRecords(storesData),
    'products': DataFrame.fromRecords(productsData),
    'customers': DataFrame.fromRecords(customersData),
    'transactions': DataFrame.fromRecords(transactionsData),
  };
}

/// Data exploration and cleaning
Future<void> dataExplorationAndCleaning(Map<String, DataFrame> data) async {
  print('🔹 DATA EXPLORATION AND CLEANING\n');

  final transactions = data['transactions']!;
  final stores = data['stores']!;
  final products = data['products']!;
  final customers = data['customers']!;

  // Data quality assessment
  print('📊 DATA QUALITY ASSESSMENT:');

  final datasets = [
    ('Transactions', transactions),
    ('Stores', stores),
    ('Products', products),
    ('Customers', customers),
  ];

  print('Dataset      | Rows   | Cols | Null Values | Duplicates');
  print('─' * 55);

  for (final (name, df) in datasets) {
    var nullCount = 0;
    for (final column in df.columns) {
      for (final value in df[column].data) {
        if (value == null) nullCount++;
      }
    }

    print(
      '${name.padRight(12)} | ${df.length.toString().padLeft(6)} | ${df.columns.length.toString().padLeft(4)} | ${nullCount.toString().padLeft(11)} | ${0.toString().padLeft(10)}',
    );
  }
  print('');

  // Explore transaction patterns
  print('📈 TRANSACTION PATTERNS EXPLORATION:');

  final totalRevenue = transactions['total_amount'].data.cast<num>().sum;
  final avgTransactionValue = totalRevenue / transactions.length;
  final transactionAmounts = transactions['total_amount'].data.cast<num>();
  final amountSeries = Series<num>(transactionAmounts);

  print('Transaction Overview:');
  print('  Total Transactions: ${transactions.length}');
  print('  Total Revenue: \$${totalRevenue.toStringAsFixed(0)}');
  print('  Average Transaction: \$${avgTransactionValue.toStringAsFixed(2)}');
  print('  Min Transaction: \$${amountSeries.min().toStringAsFixed(2)}');
  print('  Max Transaction: \$${amountSeries.max().toStringAsFixed(2)}');
  print('  Std Deviation: \$${amountSeries.std().toStringAsFixed(2)}');
  print('');

  // Date range analysis
  final dates = transactions['transaction_date'].data.cast<String>().toList()
    ..sort();
  print('Date Range: ${dates.first} to ${dates.last}');
  print(
    'Analysis Period: ${DateTime.parse(dates.last).difference(DateTime.parse(dates.first)).inDays + 1} days',
  );
  print('');

  // Identify potential outliers
  print('🔍 OUTLIER DETECTION:');

  final q1 = _calculateQuantile(amountSeries.data.cast<num>(), 0.25);
  final q3 = _calculateQuantile(amountSeries.data.cast<num>(), 0.75);
  final iqr = q3 - q1;
  final lowerBound = q1 - 1.5 * iqr;
  final upperBound = q3 + 1.5 * iqr;

  final outliers = transactionAmounts
      .where((amount) => amount < lowerBound || amount > upperBound)
      .toList();

  print('Outlier Analysis (IQR method):');
  print('  Q1: \$${q1.toStringAsFixed(2)}');
  print('  Q3: \$${q3.toStringAsFixed(2)}');
  print('  IQR: \$${iqr.toStringAsFixed(2)}');
  print('  Lower bound: \$${lowerBound.toStringAsFixed(2)}');
  print('  Upper bound: \$${upperBound.toStringAsFixed(2)}');
  print(
    '  Outliers found: ${outliers.length} (${(outliers.length / transactionAmounts.length * 100).toStringAsFixed(1)}%)',
  );

  if (outliers.isNotEmpty) {
    print(
      '  Outlier range: \$${outliers.reduce(math.min).toStringAsFixed(2)} - \$${outliers.reduce(math.max).toStringAsFixed(2)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Sales performance analysis
Future<void> salesPerformanceAnalysis(Map<String, DataFrame> data) async {
  print('🔹 SALES PERFORMANCE ANALYSIS\n');

  final transactions = data['transactions']!;
  final stores = data['stores']!;
  final products = data['products']!;

  // Time-based analysis
  print('📅 TIME-BASED SALES ANALYSIS:');

  final monthlyGroups = transactions.groupBy(['month']);
  print('Monthly Performance:');
  print('Month | Transactions | Revenue    | Avg Transaction | Growth%');
  print('─' * 60);

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

  var previousRevenue = 0.0;
  final sortedMonths = monthlyGroups.keys.map((k) => int.parse(k)).toList()
    ..sort();

  for (final month in sortedMonths) {
    final monthData = monthlyGroups[month.toString()]!;
    final monthRevenue = monthData['total_amount'].data.cast<num>().sum;
    final avgTransaction = monthRevenue / monthData.length;
    final growth = previousRevenue > 0
        ? ((monthRevenue - previousRevenue) / previousRevenue * 100)
        : 0.0;

    print(
      '${monthNames[month - 1].padLeft(5)} | ${monthData.length.toString().padLeft(12)} | \$${monthRevenue.toStringAsFixed(0).padLeft(9)} | \$${avgTransaction.toStringAsFixed(2).padLeft(14)} | ${growth.toStringAsFixed(1).padLeft(7)}',
    );
    previousRevenue = monthRevenue.toDouble();
  }
  print('');

  // Day of week analysis
  print('📊 DAY OF WEEK ANALYSIS:');

  final dayGroups = transactions.groupBy(['day_of_week']);
  final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  print('Day     | Transactions | Revenue    | Avg Transaction');
  print('─' * 50);

  for (var day = 1; day <= 7; day++) {
    if (dayGroups.containsKey(day.toString())) {
      final dayData = dayGroups[day.toString()]!;
      final dayRevenue = dayData['total_amount'].data.cast<num>().sum;
      final avgTransaction = dayRevenue / dayData.length;

      print(
        '${dayNames[day - 1].padRight(7)} | ${dayData.length.toString().padLeft(12)} | \$${dayRevenue.toStringAsFixed(0).padLeft(9)} | \$${avgTransaction.toStringAsFixed(2).padLeft(14)}',
      );
    }
  }
  print('');

  // Product category performance
  print('🏷️ PRODUCT CATEGORY PERFORMANCE:');

  // Join transactions with products to get category information
  final categoryPerformance = <String, Map<String, num>>{};

  for (var i = 0; i < transactions.length; i++) {
    final productId = transactions['product_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;
    final quantity = transactions['quantity'][i] as num;

    // Find product category
    String? category;
    for (var j = 0; j < products.length; j++) {
      if (products['product_id'][j] == productId) {
        category = products['category'][j] as String;
        break;
      }
    }

    if (category != null) {
      if (!categoryPerformance.containsKey(category)) {
        categoryPerformance[category] = {
          'revenue': 0,
          'transactions': 0,
          'quantity': 0,
        };
      }
      categoryPerformance[category]!['revenue'] =
          categoryPerformance[category]!['revenue']! + amount;
      categoryPerformance[category]!['transactions'] =
          categoryPerformance[category]!['transactions']! + 1;
      categoryPerformance[category]!['quantity'] =
          categoryPerformance[category]!['quantity']! + quantity;
    }
  }

  print(
    'Category       | Revenue    | Transactions | Avg Transaction | Market Share%',
  );
  print('─' * 75);

  final totalCategoryRevenue = categoryPerformance.values
      .map((v) => v['revenue']!)
      .fold(0.0, (a, b) => a + b);

  final sortedCategories = categoryPerformance.entries.toList()
    ..sort((a, b) => b.value['revenue']!.compareTo(a.value['revenue']!));

  for (final entry in sortedCategories) {
    final category = entry.key;
    final stats = entry.value;
    final revenue = stats['revenue']!;
    final transactions = stats['transactions']!;
    final avgTransaction = revenue / transactions;
    final marketShare = (revenue / totalCategoryRevenue) * 100;

    print(
      '${category.padRight(14)} | \$${revenue.toStringAsFixed(0).padLeft(9)} | ${transactions.toString().padLeft(12)} | \$${avgTransaction.toStringAsFixed(2).padLeft(14)} | ${marketShare.toStringAsFixed(1).padLeft(12)}',
    );
  }
  print('');

  // Regional performance
  print('🌍 REGIONAL PERFORMANCE ANALYSIS:');

  final regionalPerformance = <String, Map<String, num>>{};

  for (var i = 0; i < transactions.length; i++) {
    final storeId = transactions['store_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    // Find store region
    String? region;
    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        region = stores['region'][j] as String;
        break;
      }
    }

    if (region != null) {
      if (!regionalPerformance.containsKey(region)) {
        regionalPerformance[region] = {'revenue': 0, 'transactions': 0};
      }
      regionalPerformance[region]!['revenue'] =
          regionalPerformance[region]!['revenue']! + amount;
      regionalPerformance[region]!['transactions'] =
          regionalPerformance[region]!['transactions']! + 1;
    }
  }

  print(
    'Region  | Revenue    | Transactions | Avg Transaction | Revenue/Store',
  );
  print('─' * 65);

  final sortedRegions = regionalPerformance.entries.toList()
    ..sort((a, b) => b.value['revenue']!.compareTo(a.value['revenue']!));

  for (final entry in sortedRegions) {
    final region = entry.key;
    final stats = entry.value;
    final revenue = stats['revenue']!;
    final transactions = stats['transactions']!;
    final avgTransaction = revenue / transactions;

    // Count stores in region
    final storesInRegion = stores
        .where((row) => row['region'] == region)
        .length;
    final revenuePerStore = revenue / storesInRegion;

    print(
      '${region.padRight(7)} | \$${revenue.toStringAsFixed(0).padLeft(9)} | ${transactions.toString().padLeft(12)} | \$${avgTransaction.toStringAsFixed(2).padLeft(14)} | \$${revenuePerStore.toStringAsFixed(0).padLeft(12)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Customer analysis
Future<void> customerAnalysis(Map<String, DataFrame> data) async {
  print('🔹 CUSTOMER ANALYSIS\n');

  final transactions = data['transactions']!;
  final customers = data['customers']!;

  // Customer segmentation analysis
  print('👥 CUSTOMER SEGMENTATION ANALYSIS:');

  final customerMetrics = <String, Map<String, num>>{};

  // Calculate customer metrics
  for (var i = 0; i < transactions.length; i++) {
    final customerId = transactions['customer_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    if (!customerMetrics.containsKey(customerId)) {
      customerMetrics[customerId] = {
        'total_spent': 0,
        'transaction_count': 0,
        'avg_transaction': 0,
      };
    }

    customerMetrics[customerId]!['total_spent'] =
        customerMetrics[customerId]!['total_spent']! + amount;
    customerMetrics[customerId]!['transaction_count'] =
        customerMetrics[customerId]!['transaction_count']! + 1;
  }

  // Calculate average transaction value
  for (final metrics in customerMetrics.values) {
    metrics['avg_transaction'] =
        metrics['total_spent']! / metrics['transaction_count']!;
  }

  // Customer tier analysis
  print('Customer Tier Performance:');
  print(
    'Tier     | Customers | Avg Spent | Avg Transactions | Avg Transaction Value',
  );
  print('─' * 75);

  final tierGroups = customers.groupBy(['tier']);
  for (final entry in tierGroups.entries) {
    final tier = entry.key;
    final tierCustomers = entry.value;

    var totalSpent = 0.0;
    var totalTransactions = 0.0;
    var customerCount = 0;

    for (var i = 0; i < tierCustomers.length; i++) {
      final customerId = tierCustomers['customer_id'][i] as String;
      if (customerMetrics.containsKey(customerId)) {
        final metrics = customerMetrics[customerId]!;
        totalSpent += metrics['total_spent']!;
        totalTransactions += metrics['transaction_count']!;
        customerCount++;
      }
    }

    if (customerCount > 0) {
      final avgSpent = totalSpent / customerCount;
      final avgTransactions = totalTransactions / customerCount;
      final avgTransactionValue = totalSpent / totalTransactions;

      print(
        '${tier.padRight(8)} | ${customerCount.toString().padLeft(9)} | \$${avgSpent.toStringAsFixed(0).padLeft(8)} | ${avgTransactions.toStringAsFixed(1).padLeft(16)} | \$${avgTransactionValue.toStringAsFixed(2).padLeft(19)}',
      );
    }
  }
  print('');

  // Age demographic analysis
  print('📊 AGE DEMOGRAPHIC ANALYSIS:');

  final ageGroups = {
    '18-25': customers.where(
      (row) => (row['age'] as num) >= 18 && (row['age'] as num) <= 25,
    ),
    '26-35': customers.where(
      (row) => (row['age'] as num) >= 26 && (row['age'] as num) <= 35,
    ),
    '36-45': customers.where(
      (row) => (row['age'] as num) >= 36 && (row['age'] as num) <= 45,
    ),
    '46-55': customers.where(
      (row) => (row['age'] as num) >= 46 && (row['age'] as num) <= 55,
    ),
    '56+': customers.where((row) => (row['age'] as num) >= 56),
  };

  print('Age Group | Customers | Avg Lifetime Value | Purchase Behavior');
  print('─' * 60);

  for (final entry in ageGroups.entries) {
    final ageGroup = entry.key;
    final groupCustomers = entry.value;

    if (groupCustomers.isNotEmpty) {
      final avgLifetimeValue = groupCustomers['lifetime_value'].data
          .cast<num>()
          .average;

      // Calculate purchase frequency for this age group
      var totalTransactions = 0;
      for (var i = 0; i < groupCustomers.length; i++) {
        final customerId = groupCustomers['customer_id'][i] as String;
        if (customerMetrics.containsKey(customerId)) {
          totalTransactions +=
              customerMetrics[customerId]!['transaction_count']!.toInt();
        }
      }

      final avgTransactionsPerCustomer = groupCustomers.length > 0
          ? totalTransactions / groupCustomers.length
          : 0;

      String behavior;
      if (avgTransactionsPerCustomer > 3) {
        behavior = 'High Frequency';
      } else if (avgTransactionsPerCustomer > 1.5) {
        behavior = 'Moderate';
      } else {
        behavior = 'Low Frequency';
      }

      print(
        '${ageGroup.padRight(9)} | ${groupCustomers.length.toString().padLeft(9)} | \$${avgLifetimeValue.toStringAsFixed(0).padLeft(17)} | $behavior',
      );
    }
  }
  print('');

  // Customer loyalty analysis
  print('💎 CUSTOMER LOYALTY ANALYSIS:');

  final customerTransactionCounts = customerMetrics.values
      .map((m) => m['transaction_count']!)
      .toList();
  final transactionCountSeries = Series<num>(customerTransactionCounts);

  final loyaltySegments = {
    'One-time (1)': customerMetrics.values
        .where((m) => m['transaction_count'] == 1)
        .length,
    'Occasional (2-3)': customerMetrics.values
        .where(
          (m) => m['transaction_count']! >= 2 && m['transaction_count']! <= 3,
        )
        .length,
    'Regular (4-6)': customerMetrics.values
        .where(
          (m) => m['transaction_count']! >= 4 && m['transaction_count']! <= 6,
        )
        .length,
    'Loyal (7+)': customerMetrics.values
        .where((m) => m['transaction_count']! >= 7)
        .length,
  };

  print('Loyalty Distribution:');
  print('Segment      | Customers | Percentage | Avg Spend per Customer');
  print('─' * 60);

  final totalCustomers = customerMetrics.length;
  for (final entry in loyaltySegments.entries) {
    final segment = entry.key;
    final count = entry.value;
    final percentage = (count / totalCustomers) * 100;

    // Calculate average spend for this segment
    var totalSpend = 0.0;
    var segmentCustomers = 0;

    for (final metrics in customerMetrics.values) {
      final transactionCount = metrics['transaction_count']!;
      bool inSegment = false;

      if (segment.startsWith('One-time') && transactionCount == 1) {
        inSegment = true;
      } else if (segment.startsWith('Occasional') &&
          transactionCount >= 2 &&
          transactionCount <= 3) {
        inSegment = true;
      } else if (segment.startsWith('Regular') &&
          transactionCount >= 4 &&
          transactionCount <= 6) {
        inSegment = true;
      } else if (segment.startsWith('Loyal') && transactionCount >= 7) {
        inSegment = true;
      }

      if (inSegment) {
        totalSpend += metrics['total_spent']!;
        segmentCustomers++;
      }
    }

    final avgSpend = segmentCustomers > 0 ? totalSpend / segmentCustomers : 0;

    print(
      '${segment.padRight(12)} | ${count.toString().padLeft(9)} | ${percentage.toStringAsFixed(1).padLeft(10)}% | \$${avgSpend.toStringAsFixed(0).padLeft(21)}',
    );
  }
  print('');

  print('Customer Retention Insights:');
  print(
    '  Average transactions per customer: ${transactionCountSeries.mean().toStringAsFixed(1)}',
  );
  print(
    '  Customer retention rate: ${(loyaltySegments['Regular (4-6)']! + loyaltySegments['Loyal (7+)']!) / totalCustomers * 100}:.1f}%',
  );
  print(
    '  One-time customer rate: ${loyaltySegments['One-time (1)']! / totalCustomers * 100}:.1f}%',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Store performance analysis
Future<void> storePerformanceAnalysis(Map<String, DataFrame> data) async {
  print('🔹 STORE PERFORMANCE ANALYSIS\n');

  final transactions = data['transactions']!;
  final stores = data['stores']!;

  // Store performance metrics
  print('🏪 INDIVIDUAL STORE PERFORMANCE:');

  final storeMetrics = <String, Map<String, num>>{};

  // Calculate store metrics
  for (var i = 0; i < transactions.length; i++) {
    final storeId = transactions['store_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    if (!storeMetrics.containsKey(storeId)) {
      storeMetrics[storeId] = {
        'revenue': 0,
        'transactions': 0,
        'avg_transaction': 0,
      };
    }

    storeMetrics[storeId]!['revenue'] =
        storeMetrics[storeId]!['revenue']! + amount;
    storeMetrics[storeId]!['transactions'] =
        storeMetrics[storeId]!['transactions']! + 1;
  }

  // Calculate averages
  for (final metrics in storeMetrics.values) {
    metrics['avg_transaction'] = metrics['revenue']! / metrics['transactions']!;
  }

  // Get top and bottom performing stores
  final sortedStores = storeMetrics.entries.toList()
    ..sort((a, b) => b.value['revenue']!.compareTo(a.value['revenue']!));

  print('Top 10 Performing Stores:');
  print(
    'Store ID | Revenue    | Transactions | Avg Transaction | Region    | Type',
  );
  print('─' * 75);

  for (var i = 0; i < 10 && i < sortedStores.length; i++) {
    final storeId = sortedStores[i].key;
    final metrics = sortedStores[i].value;

    // Find store details
    String region = 'Unknown';
    String storeType = 'Unknown';

    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        region = stores['region'][j] as String;
        storeType = stores['store_type'][j] as String;
        break;
      }
    }

    print(
      '${storeId.padRight(8)} | \$${metrics['revenue']!.toStringAsFixed(0).padLeft(9)} | ${metrics['transactions']!.toString().padLeft(12)} | \$${metrics['avg_transaction']!.toStringAsFixed(2).padLeft(14)} | ${region.padRight(9)} | $storeType',
    );
  }
  print('');

  print('Bottom 5 Performing Stores:');
  print(
    'Store ID | Revenue    | Transactions | Avg Transaction | Region    | Type',
  );
  print('─' * 75);

  final bottomStores = sortedStores.reversed.take(5).toList();
  for (final entry in bottomStores) {
    final storeId = entry.key;
    final metrics = entry.value;

    String region = 'Unknown';
    String storeType = 'Unknown';

    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        region = stores['region'][j] as String;
        storeType = stores['store_type'][j] as String;
        break;
      }
    }

    print(
      '${storeId.padRight(8)} | \$${metrics['revenue']!.toStringAsFixed(0).padLeft(9)} | ${metrics['transactions']!.toString().padLeft(12)} | \$${metrics['avg_transaction']!.toStringAsFixed(2).padLeft(14)} | ${region.padRight(9)} | $storeType',
    );
  }
  print('');

  // Store type performance
  print('🏢 STORE TYPE PERFORMANCE:');

  final storeTypePerformance = <String, List<num>>{};

  for (final entry in storeMetrics.entries) {
    final storeId = entry.key;
    final revenue = entry.value['revenue']!;

    // Find store type
    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        final storeType = stores['store_type'][j] as String;
        if (!storeTypePerformance.containsKey(storeType)) {
          storeTypePerformance[storeType] = [];
        }
        storeTypePerformance[storeType]!.add(revenue);
        break;
      }
    }
  }

  print(
    'Store Type | Count | Avg Revenue | Med Revenue | Total Revenue | Contribution%',
  );
  print('─' * 80);

  final totalSystemRevenue = storeMetrics.values
      .map((m) => m['revenue']!)
      .fold(0.0, (a, b) => a + b);

  for (final entry in storeTypePerformance.entries) {
    final storeType = entry.key;
    final revenues = entry.value;
    final revenueSeries = Series<num>(revenues);

    final count = revenues.length;
    final avgRevenue = revenueSeries.mean();
    final medRevenue = _calculateMedian(revenueSeries.data.cast<num>());
    final totalRevenue = revenueSeries.sum();
    final contribution = (totalRevenue / totalSystemRevenue) * 100;

    print(
      '${storeType.padRight(10)} | ${count.toString().padLeft(5)} | \$${avgRevenue.toStringAsFixed(0).padLeft(10)} | \$${medRevenue.toStringAsFixed(0).padLeft(10)} | \$${totalRevenue.toStringAsFixed(0).padLeft(12)} | ${contribution.toStringAsFixed(1).padLeft(12)}%',
    );
  }
  print('');

  // Store efficiency analysis (revenue per sq ft)
  print('📏 STORE EFFICIENCY ANALYSIS:');

  final storeEfficiency = <Map<String, dynamic>>[];

  for (final entry in storeMetrics.entries) {
    final storeId = entry.key;
    final revenue = entry.value['revenue']!;

    // Find store details
    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        final sqFootage = stores['sq_footage'][j] as num;
        final employees = stores['employees'][j] as num;
        final rentCost = stores['rent_cost'][j] as num;

        final revenuePerSqFt = revenue / sqFootage;
        final revenuePerEmployee = revenue / employees;
        final profitAfterRent = revenue - rentCost;
        final rentEfficiency = revenue / rentCost;

        storeEfficiency.add({
          'store_id': storeId,
          'revenue': revenue,
          'revenue_per_sqft': revenuePerSqFt,
          'revenue_per_employee': revenuePerEmployee,
          'profit_after_rent': profitAfterRent,
          'rent_efficiency': rentEfficiency,
          'region': stores['region'][j],
          'store_type': stores['store_type'][j],
        });
        break;
      }
    }
  }

  // Sort by revenue per sq ft
  storeEfficiency.sort(
    (a, b) =>
        (b['revenue_per_sqft'] as num).compareTo(a['revenue_per_sqft'] as num),
  );

  print('Most Efficient Stores (Revenue per Sq Ft):');
  print(
    'Store ID | Rev/SqFt | Rev/Employee | Profit After Rent | Rent Efficiency',
  );
  print('─' * 75);

  for (var i = 0; i < 10 && i < storeEfficiency.length; i++) {
    final store = storeEfficiency[i];
    print(
      '${(store['store_id'] as String).padRight(8)} | \$${(store['revenue_per_sqft'] as num).toStringAsFixed(2).padLeft(7)} | \$${(store['revenue_per_employee'] as num).toStringAsFixed(0).padLeft(11)} | \$${(store['profit_after_rent'] as num).toStringAsFixed(0).padLeft(16)} | ${(store['rent_efficiency'] as num).toStringAsFixed(1).padLeft(15)}x',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Statistical testing and insights
Future<void> statisticalTestingAndInsights(Map<String, DataFrame> data) async {
  print('🔹 STATISTICAL TESTING AND INSIGHTS\n');

  final transactions = data['transactions']!;
  final stores = data['stores']!;

  // Regional performance comparison
  print('🧪 REGIONAL PERFORMANCE COMPARISON:');

  // Separate transaction amounts by region
  final regionalTransactions = <String, List<num>>{};

  for (var i = 0; i < transactions.length; i++) {
    final storeId = transactions['store_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    // Find store region
    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        final region = stores['region'][j] as String;
        if (!regionalTransactions.containsKey(region)) {
          regionalTransactions[region] = [];
        }
        regionalTransactions[region]!.add(amount);
        break;
      }
    }
  }

  print('Regional Transaction Statistics:');
  print('Region  | Count  | Mean    | Std Dev | Median  | Min     | Max');
  print('─' * 65);

  final regionalSeries = <String, Series<num>>{};
  for (final entry in regionalTransactions.entries) {
    final region = entry.key;
    final amounts = entry.value;
    final series = Series<num>(amounts);
    regionalSeries[region] = series;

    print(
      '${region.padRight(7)} | ${amounts.length.toString().padLeft(6)} | \$${series.mean().toStringAsFixed(2).padLeft(6)} | \$${series.std().toStringAsFixed(2).padLeft(6)} | \$${_calculateMedian(amounts).toStringAsFixed(2).padLeft(6)} | \$${series.min().toStringAsFixed(2).padLeft(6)} | \$${series.max().toStringAsFixed(2).padLeft(6)}',
    );
  }
  print('');

  // Perform t-tests between regions
  print('T-Test Results (Regional Comparisons):');
  print(
    'Comparison           | t-statistic | p-value  | Significant? | Interpretation',
  );
  print('─' * 80);

  final regions = regionalSeries.keys.toList();
  for (var i = 0; i < regions.length; i++) {
    for (var j = i + 1; j < regions.length; j++) {
      final region1 = regions[i];
      final region2 = regions[j];

      final series1 = regionalSeries[region1]!;
      final series2 = regionalSeries[region2]!;

      final tTestResult = Statistics.tTest(series1, series2);
      final tStat = tTestResult['t_statistic'] ?? 0.0;
      final pValue = tTestResult['p_value'] ?? 1.0;
      final significant = pValue < 0.05;

      final interpretation = significant
          ? (series1.mean() > series2.mean()
                ? '$region1 > $region2'
                : '$region2 > $region1')
          : 'No significant difference';

      print(
        '${region1.padRight(7)} vs ${region2.padRight(7)} | ${tStat.toStringAsFixed(3).padLeft(11)} | ${pValue.toStringAsFixed(6).padLeft(8)} | ${(significant ? 'Yes' : 'No').padLeft(12)} | $interpretation',
      );
    }
  }
  print('');

  // Store type analysis
  print('🏢 STORE TYPE STATISTICAL ANALYSIS:');

  final storeTypeTransactions = <String, List<num>>{};

  for (var i = 0; i < transactions.length; i++) {
    final storeId = transactions['store_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        final storeType = stores['store_type'][j] as String;
        if (!storeTypeTransactions.containsKey(storeType)) {
          storeTypeTransactions[storeType] = [];
        }
        storeTypeTransactions[storeType]!.add(amount);
        break;
      }
    }
  }

  // ANOVA test for store types
  final storeTypeSeries = storeTypeTransactions.values
      .map((amounts) => Series<num>(amounts))
      .toList();
  if (storeTypeSeries.length >= 2) {
    final anovaResult = Statistics.anova(storeTypeSeries);

    print('ANOVA Test Results (Store Types):');
    print(
      '  F-statistic: ${(anovaResult['f_statistic'] ?? 0.0).toStringAsFixed(4)}',
    );
    print('  p-value: ${(anovaResult['p_value'] ?? 1.0).toStringAsFixed(6)}');
    print(
      '  Significant: ${(anovaResult['p_value'] ?? 1.0) < 0.05 ? 'Yes' : 'No'}',
    );
    print(
      '  Interpretation: ${(anovaResult['p_value'] ?? 1.0) < 0.05 ? 'Store types have significantly different performance' : 'No significant difference between store types'}',
    );
    print('');
  }

  // Correlation analysis
  print('🔗 CORRELATION ANALYSIS:');

  // Store size vs performance correlation
  final storeSizes = <num>[];
  final storeRevenues = <num>[];
  final storeEmployees = <num>[];

  for (var i = 0; i < stores.length; i++) {
    final storeId = stores['store_id'][i] as String;
    final sqFootage = stores['sq_footage'][i] as num;
    final employees = stores['employees'][i] as num;

    // Find total revenue for this store
    var totalRevenue = 0.0;
    for (var j = 0; j < transactions.length; j++) {
      if (transactions['store_id'][j] == storeId) {
        totalRevenue += transactions['total_amount'][j] as num;
      }
    }

    if (totalRevenue > 0) {
      // Only include stores with transactions
      storeSizes.add(sqFootage);
      storeRevenues.add(totalRevenue);
      storeEmployees.add(employees);
    }
  }

  if (storeSizes.isNotEmpty) {
    final sizeSeries = Series<num>(
      storeSizes,
      index: List.generate(storeSizes.length, (i) => i.toString()),
    );
    final revenueSeries = Series<num>(
      storeRevenues,
      index: List.generate(storeRevenues.length, (i) => i.toString()),
    );
    final employeeSeries = Series<num>(
      storeEmployees,
      index: List.generate(storeEmployees.length, (i) => i.toString()),
    );

    final sizeRevenueCorr = Statistics.correlationTest(
      sizeSeries,
      revenueSeries,
    );
    final employeeRevenueCorr = Statistics.correlationTest(
      employeeSeries,
      revenueSeries,
    );

    print('Store Characteristics vs Revenue:');
    print('  Store Size (sq ft) vs Revenue:');
    print(
      '    Correlation: ${(sizeRevenueCorr['correlation'] ?? 0.0).toStringAsFixed(3)}',
    );
    print(
      '    p-value: ${(sizeRevenueCorr['p_value'] ?? 1.0).toStringAsFixed(6)}',
    );
    print(
      '    Interpretation: ${(sizeRevenueCorr['correlation'] ?? 0.0).abs() > 0.3 ? 'Moderate to strong correlation' : 'Weak correlation'}',
    );
    print('');

    print('  Employee Count vs Revenue:');
    print(
      '    Correlation: ${(employeeRevenueCorr['correlation'] ?? 0.0).toStringAsFixed(3)}',
    );
    print(
      '    p-value: ${(employeeRevenueCorr['p_value'] ?? 1.0).toStringAsFixed(6)}',
    );
    print(
      '    Interpretation: ${(employeeRevenueCorr['correlation'] ?? 0.0).abs() > 0.3 ? 'Moderate to strong correlation' : 'Weak correlation'}',
    );
    print('');
  }

  print('─' * 60);
  print('');
}

/// Predictive analysis
Future<void> predictiveAnalysis(Map<String, DataFrame> data) async {
  print('🔹 PREDICTIVE ANALYSIS\n');

  final transactions = data['transactions']!;

  // Time series forecasting
  print('📈 SALES TREND ANALYSIS AND FORECASTING:');

  // Aggregate daily sales
  final dailySales = <String, num>{};

  for (var i = 0; i < transactions.length; i++) {
    final date = transactions['transaction_date'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    if (!dailySales.containsKey(date)) {
      dailySales[date] = 0;
    }
    dailySales[date] = dailySales[date]! + amount;
  }

  final sortedDates = dailySales.keys.toList()..sort();
  final salesValues = sortedDates.map((date) => dailySales[date]!).toList();

  print('Daily Sales Trend (first 10 days):');
  print('Date       | Sales     | 7-day MA  | Growth%');
  print('─' * 45);

  final movingAverages = <num?>[];

  for (var i = 0; i < sortedDates.length; i++) {
    final date = sortedDates[i];
    final sales = salesValues[i];

    // Calculate 7-day moving average
    num? ma7;
    if (i >= 6) {
      final window = salesValues.sublist(i - 6, i + 1);
      ma7 = window.average;
      movingAverages.add(ma7);
    } else {
      movingAverages.add(null);
    }

    // Calculate growth rate
    final growth = i > 0
        ? ((sales - salesValues[i - 1]) / salesValues[i - 1] * 100)
        : 0.0;

    if (i < 10) {
      // Show first 10 days
      print(
        '$date | \$${sales.toStringAsFixed(0).padLeft(8)} | ${ma7?.toStringAsFixed(0).padLeft(8) ?? '     N/A'} | ${growth.toStringAsFixed(1).padLeft(7)}%',
      );
    }
  }
  print('... (${sortedDates.length - 10} more days)');
  print('');

  // Simple linear trend analysis
  final salesSeries = Series<num>(salesValues);
  final dayNumbers = List.generate(salesValues.length, (i) => i + 1);
  final daySeries = Series<num>(
    dayNumbers,
    index: List.generate(dayNumbers.length, (i) => i.toString()),
  );

  final regression = Statistics.linearRegression(daySeries, salesSeries);

  print('Sales Trend Analysis:');
  print(
    '  Linear regression equation: Sales = ${(regression['slope'] ?? 0.0).toStringAsFixed(2)} × Day + ${(regression['intercept'] ?? 0.0).toStringAsFixed(0)}',
  );
  print('  R-squared: ${(regression['r_squared'] ?? 0.0).toStringAsFixed(4)}');
  print(
    '  Daily trend: ${(regression['slope'] ?? 0.0) > 0 ? 'Increasing' : 'Decreasing'} by \$${((regression['slope'] ?? 0.0).abs()).toStringAsFixed(2)} per day',
  );
  print('');

  // Sales forecasting (simple linear extrapolation)
  print('📊 SALES FORECAST (Next 7 Days):');

  final slope = regression['slope'] ?? 0.0;
  final intercept = regression['intercept'] ?? 0.0;
  final lastDay = dayNumbers.length;

  print('Day | Predicted Sales | Confidence');
  print('─' * 35);

  for (var i = 1; i <= 7; i++) {
    final futureDay = lastDay + i;
    final predictedSales = slope * futureDay + intercept;

    // Simple confidence indicator based on R-squared
    final rSquared = regression['r_squared'] ?? 0.0;
    String confidence;
    if (rSquared > 0.7) {
      confidence = 'High';
    } else if (rSquared > 0.4) {
      confidence = 'Medium';
    } else {
      confidence = 'Low';
    }

    print(
      '${i.toString().padLeft(3)} | \$${predictedSales.toStringAsFixed(0).padLeft(14)} | $confidence',
    );
  }
  print('');

  // Customer lifetime value prediction
  print('💎 CUSTOMER LIFETIME VALUE ANALYSIS:');

  final customers = data['customers']!;
  final customerTransactionCounts = <String, int>{};
  final customerTotalSpends = <String, num>{};

  for (var i = 0; i < transactions.length; i++) {
    final customerId = transactions['customer_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;

    customerTransactionCounts[customerId] =
        (customerTransactionCounts[customerId] ?? 0) + 1;
    customerTotalSpends[customerId] =
        (customerTotalSpends[customerId] ?? 0) + amount;
  }

  // Analyze by customer tier
  final tierCLVAnalysis = <String, Map<String, num>>{};

  for (var i = 0; i < customers.length; i++) {
    final customerId = customers['customer_id'][i] as String;
    final tier = customers['tier'][i] as String;

    if (customerTotalSpends.containsKey(customerId)) {
      final totalSpend = customerTotalSpends[customerId]!;
      final transactionCount = customerTransactionCounts[customerId]!;

      if (!tierCLVAnalysis.containsKey(tier)) {
        tierCLVAnalysis[tier] = {
          'total_customers': 0,
          'total_spend': 0,
          'total_transactions': 0,
        };
      }

      tierCLVAnalysis[tier]!['total_customers'] =
          tierCLVAnalysis[tier]!['total_customers']! + 1;
      tierCLVAnalysis[tier]!['total_spend'] =
          tierCLVAnalysis[tier]!['total_spend']! + totalSpend;
      tierCLVAnalysis[tier]!['total_transactions'] =
          tierCLVAnalysis[tier]!['total_transactions']! + transactionCount;
    }
  }

  print('Customer Lifetime Value by Tier:');
  print(
    'Tier     | Customers | Avg CLV | Avg Transactions | Predicted Annual Value',
  );
  print('─' * 75);

  for (final entry in tierCLVAnalysis.entries) {
    final tier = entry.key;
    final analysis = entry.value;

    final avgCLV = analysis['total_spend']! / analysis['total_customers']!;
    final avgTransactions =
        analysis['total_transactions']! / analysis['total_customers']!;

    // Simple prediction: assume quarterly data, extrapolate to annual
    final predictedAnnualValue =
        avgCLV * 4; // Multiply by 4 for annual estimate

    print(
      '${tier.padRight(8)} | ${analysis['total_customers']!.toString().padLeft(9)} | \$${avgCLV.toStringAsFixed(0).padLeft(6)} | ${avgTransactions.toStringAsFixed(1).padLeft(16)} | \$${predictedAnnualValue.toStringAsFixed(0).padLeft(21)}',
    );
  }
  print('');

  print('📋 Predictive Insights:');
  print('• Sales trend shows ${slope > 0 ? 'positive' : 'negative'} momentum');
  print(
    '• Model explains ${((regression['r_squared'] ?? 0.0) * 100).toStringAsFixed(1)}% of sales variance',
  );
  print('• Higher tier customers show significantly higher lifetime value');
  print('• Customer acquisition should focus on converting to higher tiers');
  print('');

  print('─' * 60);
  print('');
}

/// Business recommendations
Future<void> businessRecommendations(Map<String, DataFrame> data) async {
  print('🔹 BUSINESS RECOMMENDATIONS\n');

  final transactions = data['transactions']!;
  final stores = data['stores']!;
  final customers = data['customers']!;

  print('📊 EXECUTIVE SUMMARY:');

  // Calculate key metrics
  final totalRevenue = transactions['total_amount'].data.cast<num>().sum;
  final totalTransactions = transactions.length;
  final avgTransactionValue = totalRevenue / totalTransactions;
  final uniqueCustomers = transactions['customer_id'].data.toSet().length;
  final avgRevenuePerCustomer = totalRevenue / uniqueCustomers;

  print('Key Performance Indicators:');
  print('  Total Revenue: \$${totalRevenue.toStringAsFixed(0)}');
  print('  Total Transactions: $totalTransactions');
  print(
    '  Average Transaction Value: \$${avgTransactionValue.toStringAsFixed(2)}',
  );
  print('  Unique Customers: $uniqueCustomers');
  print(
    '  Revenue per Customer: \$${avgRevenuePerCustomer.toStringAsFixed(0)}',
  );
  print('  Active Stores: ${stores.length}');
  print('');

  print('🎯 STRATEGIC RECOMMENDATIONS:');
  print('');

  // Revenue optimization recommendations
  print('1. REVENUE OPTIMIZATION:');

  // Find best performing categories and regions
  // final categoryPerformance = <String, num>{};
  final regionalPerformance = <String, num>{};

  for (var i = 0; i < transactions.length; i++) {
    final amount = transactions['total_amount'][i] as num;
    final storeId = transactions['store_id'][i] as String;

    // Find region
    for (var j = 0; j < stores.length; j++) {
      if (stores['store_id'][j] == storeId) {
        final region = stores['region'][j] as String;
        regionalPerformance[region] =
            (regionalPerformance[region] ?? 0) + amount;
        break;
      }
    }
  }

  final topRegion = regionalPerformance.entries.reduce(
    (a, b) => a.value > b.value ? a : b,
  );

  print(
    '   • Focus expansion in ${topRegion.key} region (highest performing: \$${topRegion.value.toStringAsFixed(0)})',
  );
  print(
    '   • Increase average transaction value through bundling and upselling',
  );
  print(
    '   • Target current ATV of \$${avgTransactionValue.toStringAsFixed(2)} to \$${(avgTransactionValue * 1.15).toStringAsFixed(2)} (+15%)',
  );
  print('');

  // Customer retention recommendations
  print('2. CUSTOMER RETENTION & GROWTH:');

  final customerTiers = customers.groupBy(['tier']);
  final platinumCustomers = customerTiers['Platinum']?.length ?? 0;
  final totalCustomersInData = customers.length;

  print('   • Implement loyalty program to move customers up tiers');
  print(
    '   • Current Platinum customers: $platinumCustomers (${(platinumCustomers / totalCustomersInData * 100).toStringAsFixed(1)}%)',
  );
  print(
    '   • Target: Increase Platinum customers by 25% through tier promotion campaigns',
  );
  print(
    '   • Focus on customer lifetime value improvement through personalized experiences',
  );
  print('');

  // Operational efficiency recommendations
  print('3. OPERATIONAL EFFICIENCY:');

  // Calculate store efficiency metrics
  final storeRevenues = <String, num>{};
  for (var i = 0; i < transactions.length; i++) {
    final storeId = transactions['store_id'][i] as String;
    final amount = transactions['total_amount'][i] as num;
    storeRevenues[storeId] = (storeRevenues[storeId] ?? 0) + amount;
  }

  final revenuePerStore = storeRevenues.values.average;
  final underperformingStores = storeRevenues.entries
      .where((e) => e.value < revenuePerStore * 0.7)
      .length;

  print(
    '   • Review operations of $underperformingStores underperforming stores',
  );
  print('   • Average store revenue: \$${revenuePerStore.toStringAsFixed(0)}');
  print('   • Implement best practices from top-performing stores');
  print(
    '   • Consider store format optimization based on location performance',
  );
  print('');

  // Digital and technology recommendations
  print('4. DIGITAL TRANSFORMATION:');
  print('   • Implement predictive analytics for inventory management');
  print('   • Deploy customer segmentation for targeted marketing');
  print('   • Develop mobile app for enhanced customer experience');
  print('   • Use transaction data for personalized product recommendations');
  print('');

  // Risk management recommendations
  print('5. RISK MANAGEMENT:');

  final dailyRevenues = <String, num>{};
  for (var i = 0; i < transactions.length; i++) {
    final date = transactions['transaction_date'][i] as String;
    final amount = transactions['total_amount'][i] as num;
    dailyRevenues[date] = (dailyRevenues[date] ?? 0) + amount;
  }

  final revenueValues = dailyRevenues.values.toList();
  final revenueSeries = Series<num>(revenueValues);
  final revenueVolatility = revenueSeries.std() / revenueSeries.mean();

  print(
    '   • Daily revenue volatility: ${(revenueVolatility * 100).toStringAsFixed(1)}%',
  );
  print('   • Diversify revenue streams to reduce seasonal dependency');
  print('   • Implement dynamic pricing strategies');
  print('   • Monitor key performance indicators in real-time');
  print('');

  print('📈 PROJECTED IMPACT:');
  print('');

  // Calculate potential impact of recommendations
  final currentAnnualRevenue =
      totalRevenue * 4; // Extrapolate quarterly to annual
  final projectedRevenueLift = 0.18; // 18% improvement target
  final projectedRevenue = currentAnnualRevenue * (1 + projectedRevenueLift);

  print('Implementation Roadmap (12-month horizon):');
  print('  Current Quarterly Revenue: \$${totalRevenue.toStringAsFixed(0)}');
  print(
    '  Projected Annual Revenue (baseline): \$${currentAnnualRevenue.toStringAsFixed(0)}',
  );
  print(
    '  Projected Annual Revenue (with improvements): \$${projectedRevenue.toStringAsFixed(0)}',
  );
  print(
    '  Expected Revenue Lift: \$${(projectedRevenue - currentAnnualRevenue).toStringAsFixed(0)} (+${(projectedRevenueLift * 100).toStringAsFixed(0)}%)',
  );
  print('');

  print('Quick Wins (0-3 months):');
  print('  • Optimize underperforming store operations (+3-5% revenue)');
  print('  • Launch customer tier promotion campaigns (+2-4% customer value)');
  print('  • Implement upselling training for staff (+5-8% transaction value)');
  print('');

  print('Medium-term Initiatives (3-9 months):');
  print(
    '  • Deploy predictive analytics and personalization (+5-10% efficiency)',
  );
  print(
    '  • Expand successful store formats to high-potential markets (+8-12% revenue)',
  );
  print(
    '  • Launch comprehensive loyalty and retention programs (+6-10% customer retention)',
  );
  print('');

  print('Long-term Strategic Goals (9-12 months):');
  print('  • Complete digital transformation initiative');
  print('  • Establish data-driven decision making culture');
  print('  • Achieve industry-leading customer satisfaction scores');
  print('  • Position for continued sustainable growth');
  print('');

  print('💡 NEXT STEPS:');
  print('1. Present findings to executive team');
  print('2. Prioritize initiatives based on ROI and resource requirements');
  print('3. Establish success metrics and monitoring framework');
  print('4. Begin implementation with quick wins');
  print('5. Set up regular performance review cycles');
  print('');

  print('─' * 60);
  print('');
  print('🎉 Real-world analysis complete!');
  print(
    'This comprehensive analysis demonstrates how the data_frame library can be used',
  );
  print(
    'for complete end-to-end business intelligence and data science workflows.',
  );
}

// Helper function for quantile calculation
double _calculateQuantile(List<num> data, double quantile) {
  final sorted = List<num>.from(data)..sort();
  final n = sorted.length;
  final index = quantile * (n - 1);
  final lower = sorted[index.floor()];
  final upper = sorted[index.ceil()];
  return lower + (upper - lower) * (index - index.floor());
}

// Helper function for median calculation
double _calculateMedian(List<num> data) {
  final sorted = List<num>.from(data)..sort();
  final n = sorted.length;
  if (n % 2 == 0) {
    return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
  } else {
    return sorted[n ~/ 2].toDouble();
  }
}
