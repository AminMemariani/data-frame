// ignore_for_file: avoid_print

/// Advanced Data Manipulation Example
///
/// This example demonstrates advanced data manipulation techniques:
/// - Grouping and aggregation operations
/// - Joining and merging DataFrames
/// - Data reshaping and pivoting
/// - Advanced filtering and selection
/// - Data cleaning and transformation
/// - Window functions and advanced analytics
library;

import 'package:collection/collection.dart';
import 'package:data_frame/data_frame.dart';
import 'dart:math' as math;

void main() {
  print('=== Advanced Data Manipulation with Data Frame ===\n');

  // Grouping and aggregation
  groupingAndAggregation();

  // Joining and merging
  joiningAndMerging();

  // Data reshaping
  dataReshaping();

  // Advanced filtering
  advancedFiltering();

  // Data cleaning
  dataCleaning();

  // Advanced transformations
  advancedTransformations();

  // Time series operations
  timeSeriesOperations();
}

/// Demonstrates grouping and aggregation operations
void groupingAndAggregation() {
  print('🔹 GROUPING AND AGGREGATION OPERATIONS\n');

  // Create comprehensive sales data
  final salesData = DataFrame({
    'date': [
      '2024-01-01',
      '2024-01-01',
      '2024-01-02',
      '2024-01-02',
      '2024-01-03',
      '2024-01-03',
      '2024-01-01',
      '2024-01-02',
      '2024-01-03',
      '2024-01-01',
      '2024-01-02',
      '2024-01-03',
    ],
    'product': [
      'Laptop',
      'Phone',
      'Laptop',
      'Tablet',
      'Phone',
      'Laptop',
      'Tablet',
      'Phone',
      'Tablet',
      'Phone',
      'Laptop',
      'Phone',
    ],
    'category': [
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
      'Electronics',
    ],
    'region': [
      'North',
      'South',
      'North',
      'East',
      'South',
      'West',
      'East',
      'North',
      'West',
      'West',
      'East',
      'East',
    ],
    'sales_person': [
      'Alice',
      'Bob',
      'Alice',
      'Charlie',
      'Bob',
      'Diana',
      'Charlie',
      'Alice',
      'Diana',
      'Bob',
      'Charlie',
      'Alice',
    ],
    'quantity': [2, 5, 1, 3, 4, 2, 1, 6, 2, 3, 1, 4],
    'unit_price': [
      1200.0,
      800.0,
      1200.0,
      400.0,
      800.0,
      1200.0,
      400.0,
      800.0,
      400.0,
      800.0,
      1200.0,
      800.0,
    ],
    'revenue': [
      2400.0,
      4000.0,
      1200.0,
      1200.0,
      3200.0,
      2400.0,
      400.0,
      4800.0,
      800.0,
      2400.0,
      1200.0,
      3200.0,
    ],
  });

  print('📊 Comprehensive Sales Data:');
  print(salesData);
  print('');

  // Group by single column
  print('📈 SINGLE COLUMN GROUPING:');

  print('Sales by Product:');
  final productGroups = salesData.groupBy(['product']);
  for (final entry in productGroups.entries) {
    final productName = entry.key;
    final productData = entry.value;
    final totalRevenue = productData['revenue'].data.cast<num>().sum;
    final totalQuantity = productData['quantity'].data.cast<num>().sum;
    final avgPrice = productData['unit_price'].data.cast<num>().average;

    print('  $productName:');
    print('    Total Revenue: \$${totalRevenue.toStringAsFixed(0)}');
    print('    Total Quantity: $totalQuantity units');
    print('    Average Unit Price: \$${avgPrice.toStringAsFixed(0)}');
    print('    Number of Transactions: ${productData.length}');
    print('');
  }

  // Group by multiple columns
  print('📊 MULTI-COLUMN GROUPING:');

  print('Sales by Region and Product:');
  final regionProductGroups = salesData.groupBy(['region', 'product']);
  for (final entry in regionProductGroups.entries) {
    final groupKey = entry.key;
    final groupData = entry.value;
    final totalRevenue = groupData['revenue'].data.cast<num>().sum;
    final totalQuantity = groupData['quantity'].data.cast<num>().sum;

    print('  $groupKey:');
    print('    Revenue: \$${totalRevenue.toStringAsFixed(0)}');
    print('    Quantity: $totalQuantity units');
    print('    Transactions: ${groupData.length}');
    print('');
  }

  // Sales person performance
  print('👤 SALES PERSON PERFORMANCE:');

  final salesPersonGroups = salesData.groupBy(['sales_person']);
  final performance = <Map<String, dynamic>>[];

  for (final entry in salesPersonGroups.entries) {
    final person = entry.key;
    final personData = entry.value;
    final revenues = personData['revenue'].data.cast<num>();
    final quantities = personData['quantity'].data.cast<num>();

    final totalRevenue = revenues.sum;
    final totalQuantity = quantities.sum;
    final avgTransactionSize = totalRevenue / personData.length;
    final uniqueProducts = personData['product'].data.toSet().length;
    final uniqueRegions = personData['region'].data.toSet().length;

    performance.add({
      'sales_person': person,
      'total_revenue': totalRevenue,
      'total_quantity': totalQuantity,
      'transactions': personData.length,
      'avg_transaction_size': avgTransactionSize,
      'unique_products': uniqueProducts,
      'unique_regions': uniqueRegions,
    });
  }

  // Sort by total revenue
  performance.sort(
    (a, b) => (b['total_revenue'] as num).compareTo(a['total_revenue'] as num),
  );

  print('Sales Performance Ranking:');
  print(
    'Rank | Person  | Revenue | Qty | Transactions | Avg Size | Products | Regions',
  );
  print('─' * 80);

  for (var i = 0; i < performance.length; i++) {
    final p = performance[i];
    print(
      '${(i + 1).toString().padLeft(4)} | ${(p['sales_person'] as String).padRight(7)} | \$${(p['total_revenue'] as num).toStringAsFixed(0).padLeft(6)} | ${(p['total_quantity'] as num).toString().padLeft(3)} | ${(p['transactions'] as num).toString().padLeft(12)} | \$${(p['avg_transaction_size'] as num).toStringAsFixed(0).padLeft(7)} | ${(p['unique_products'] as num).toString().padLeft(8)} | ${(p['unique_regions'] as num).toString().padLeft(7)}',
    );
  }
  print('');

  // Time-based grouping
  print('📅 TIME-BASED ANALYSIS:');

  final dateGroups = salesData.groupBy(['date']);
  print('Daily Sales Summary:');
  print('Date       | Revenue | Transactions | Avg Transaction');
  print('─' * 50);

  for (final entry in dateGroups.entries) {
    final date = entry.key;
    final dayData = entry.value;
    final dailyRevenue = dayData['revenue'].data.cast<num>().sum;
    final transactions = dayData.length;
    final avgTransaction = dailyRevenue / transactions;

    print(
      '$date | \$${dailyRevenue.toStringAsFixed(0).padLeft(6)} | ${transactions.toString().padLeft(12)} | \$${avgTransaction.toStringAsFixed(0).padLeft(14)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates joining and merging operations
void joiningAndMerging() {
  print('🔹 JOINING AND MERGING DATAFRAMES\n');

  // Create related datasets
  final employees = DataFrame({
    'employee_id': [101, 102, 103, 104, 105],
    'name': [
      'Alice Johnson',
      'Bob Smith',
      'Charlie Brown',
      'Diana Prince',
      'Eve Wilson',
    ],
    'department_id': [1, 2, 1, 3, 2],
    'salary': [75000, 65000, 80000, 70000, 68000],
    'hire_date': [
      '2020-01-15',
      '2019-03-22',
      '2021-07-10',
      '2020-11-05',
      '2021-02-18',
    ],
  });

  final departments = DataFrame({
    'dept_id': [1, 2, 3, 4],
    'dept_name': ['Engineering', 'Sales', 'Marketing', 'HR'],
    'manager': ['John Doe', 'Jane Smith', 'Mike Johnson', 'Sarah Wilson'],
    'budget': [500000, 300000, 200000, 150000],
    'location': ['Building A', 'Building B', 'Building C', 'Building A'],
  });

  final projects = DataFrame({
    'project_id': ['P001', 'P002', 'P003', 'P004'],
    'project_name': [
      'WebApp Redesign',
      'Mobile App',
      'Marketing Campaign',
      'HR System',
    ],
    'lead_employee_id': [101, 103, 104, 105],
    'budget': [50000, 80000, 30000, 25000],
    'status': ['Active', 'Completed', 'Planning', 'Active'],
  });

  print('👥 Employee Data:');
  print(employees);
  print('');

  print('🏢 Department Data:');
  print(departments);
  print('');

  print('📋 Project Data:');
  print(projects);
  print('');

  // Inner join
  print('🔗 INNER JOIN (Employees + Departments):');

  // Prepare data for joining by aligning column names
  final employeesForJoin = DataFrame({
    'employee_id': employees['employee_id'].data,
    'name': employees['name'].data,
    'dept_id': employees['department_id'].data, // Rename to match departments
    'salary': employees['salary'].data,
    'hire_date': employees['hire_date'].data,
  });

  final innerJoined = employeesForJoin.join(
    departments,
    on: 'dept_id',
    how: 'inner',
  );
  print('Employee-Department Inner Join:');
  print(innerJoined);
  print('');

  // Left join to show all employees
  print('⬅️ LEFT JOIN (All Employees + Department Info):');

  final leftJoined = employeesForJoin.join(
    departments,
    on: 'dept_id',
    how: 'left',
  );
  print('Employee-Department Left Join:');
  print(leftJoined);
  print('');

  // Project assignments
  print('📊 PROJECT ASSIGNMENTS:');

  // Join employees with projects they lead
  final employeeProjects = employees.join(
    projects,
    on: 'employee_id',
    how: 'inner',
  );

  print('Employees and Their Project Assignments:');
  if (employeeProjects.isNotEmpty) {
    print(employeeProjects);
  } else {
    print('Manual join for project assignments:');
    print('Name           | Project         | Budget | Status');
    print('─' * 50);

    for (var i = 0; i < projects.length; i++) {
      final leadId = projects['lead_employee_id'][i] as num;
      final projectName = projects['project_name'][i] as String;
      final budget = projects['budget'][i] as num;
      final status = projects['status'][i] as String;

      // Find employee with matching ID
      for (var j = 0; j < employees.length; j++) {
        if (employees['employee_id'][j] == leadId) {
          final employeeName = employees['name'][j] as String;
          print(
            '${employeeName.padRight(14)} | ${projectName.padRight(15)} | \$${budget.toString().padLeft(5)} | $status',
          );
          break;
        }
      }
    }
  }
  print('');

  // Complex multi-table join
  print('🔄 COMPLEX MULTI-TABLE ANALYSIS:');

  print('Department Performance Summary:');
  print(
    'Department   | Employees | Avg Salary | Total Projects | Project Budget',
  );
  print('─' * 70);

  for (var i = 0; i < departments.length; i++) {
    final deptId = departments['dept_id'][i] as num;
    final deptName = departments['dept_name'][i] as String;

    // Count employees in department
    var employeeCount = 0;
    var totalSalary = 0.0;

    for (var j = 0; j < employees.length; j++) {
      if (employees['department_id'][j] == deptId) {
        employeeCount++;
        totalSalary += employees['salary'][j] as num;
      }
    }

    final avgSalary = employeeCount > 0 ? totalSalary / employeeCount : 0;

    // Count projects led by department employees
    var projectCount = 0;
    var totalProjectBudget = 0.0;

    for (var k = 0; k < projects.length; k++) {
      final leadId = projects['lead_employee_id'][k] as num;

      for (var j = 0; j < employees.length; j++) {
        if (employees['employee_id'][j] == leadId &&
            employees['department_id'][j] == deptId) {
          projectCount++;
          totalProjectBudget += projects['budget'][k] as num;
          break;
        }
      }
    }

    print(
      '${deptName.padRight(12)} | ${employeeCount.toString().padLeft(9)} | \$${avgSalary.toStringAsFixed(0).padLeft(9)} | ${projectCount.toString().padLeft(14)} | \$${totalProjectBudget.toStringAsFixed(0).padLeft(13)}',
    );
  }
  print('');

  // Union operation simulation
  print('📑 UNION OPERATIONS:');

  final quarterlyResults1 = DataFrame({
    'region': ['North', 'South', 'East', 'West'],
    'quarter': ['Q1', 'Q1', 'Q1', 'Q1'],
    'revenue': [100000, 120000, 110000, 95000],
  });

  final quarterlyResults2 = DataFrame({
    'region': ['North', 'South', 'East', 'West'],
    'quarter': ['Q2', 'Q2', 'Q2', 'Q2'],
    'revenue': [105000, 125000, 115000, 98000],
  });

  print('Q1 Results:');
  print(quarterlyResults1);
  print('');

  print('Q2 Results:');
  print(quarterlyResults2);
  print('');

  // Combine quarterly results
  final combinedResults = DF.concatDataFrames([
    quarterlyResults1,
    quarterlyResults2,
  ]);
  print('Combined Quarterly Results:');
  print(combinedResults);
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates data reshaping operations
void dataReshaping() {
  print('🔹 DATA RESHAPING OPERATIONS\n');

  // Create wide format data
  final wideData = DataFrame({
    'employee': ['Alice', 'Bob', 'Charlie', 'Diana'],
    'jan_sales': [15000, 18000, 12000, 22000],
    'feb_sales': [16000, 19000, 13000, 24000],
    'mar_sales': [17000, 20000, 14000, 25000],
    'jan_calls': [45, 52, 38, 61],
    'feb_calls': [48, 55, 41, 65],
    'mar_calls': [51, 58, 44, 68],
  });

  print('📊 Wide Format Data:');
  print(wideData);
  print('');

  // Manual pivot/melt operation
  print('🔄 RESHAPING TO LONG FORMAT:');

  final longFormatRecords = <Map<String, dynamic>>[];

  for (var i = 0; i < wideData.length; i++) {
    final employee = wideData['employee'][i] as String;

    // Process sales data
    for (final month in ['jan', 'feb', 'mar']) {
      longFormatRecords.add({
        'employee': employee,
        'month': month,
        'metric': 'sales',
        'value': wideData['${month}_sales'][i],
      });

      longFormatRecords.add({
        'employee': employee,
        'month': month,
        'metric': 'calls',
        'value': wideData['${month}_calls'][i],
      });
    }
  }

  final longData = DataFrame.fromRecords(longFormatRecords);
  print('Long Format Data (first 10 rows):');
  print(longData.head(10));
  print('');

  // Pivot table simulation
  print('📋 PIVOT TABLE ANALYSIS:');

  print('Sales Performance by Employee and Month:');
  print('Employee | Jan     | Feb     | Mar     | Total   | Avg');
  print('─' * 55);

  final employees = wideData['employee'].data.cast<String>().toSet().toList();

  for (final employee in employees) {
    final janSales =
        wideData.where((row) => row['employee'] == employee)['jan_sales'][0]
            as num;
    final febSales =
        wideData.where((row) => row['employee'] == employee)['feb_sales'][0]
            as num;
    final marSales =
        wideData.where((row) => row['employee'] == employee)['mar_sales'][0]
            as num;

    final total = janSales + febSales + marSales;
    final avg = total / 3;

    print(
      '${employee.padRight(8)} | ${janSales.toString().padLeft(7)} | ${febSales.toString().padLeft(7)} | ${marSales.toString().padLeft(7)} | ${total.toString().padLeft(7)} | ${avg.toStringAsFixed(0).padLeft(3)}',
    );
  }
  print('');

  // Cross-tabulation
  print('📊 CROSS-TABULATION:');

  print('Call Activity Analysis:');
  print(
    'Employee | Jan Calls | Feb Calls | Mar Calls | Total Calls | Avg Daily',
  );
  print('─' * 65);

  for (final employee in employees) {
    final employeeRow = wideData.where((row) => row['employee'] == employee);
    final janCalls = employeeRow['jan_calls'][0] as num;
    final febCalls = employeeRow['feb_calls'][0] as num;
    final marCalls = employeeRow['mar_calls'][0] as num;

    final totalCalls = janCalls + febCalls + marCalls;
    final avgDaily = totalCalls / 90; // Assuming 30 days per month

    print(
      '${employee.padRight(8)} | ${janCalls.toString().padLeft(9)} | ${febCalls.toString().padLeft(9)} | ${marCalls.toString().padLeft(9)} | ${totalCalls.toString().padLeft(11)} | ${avgDaily.toStringAsFixed(1).padLeft(9)}',
    );
  }
  print('');

  // Transpose operation
  print('🔄 TRANSPOSE OPERATION:');

  final summaryData = DataFrame({
    'metric': ['Sales', 'Calls', 'Conversion_Rate'],
    'alice': [48000, 144, 0.33],
    'bob': [57000, 165, 0.35],
    'charlie': [39000, 123, 0.32],
    'diana': [71000, 194, 0.37],
  });

  print('Original Summary Data:');
  print(summaryData);
  print('');

  // Manual transpose
  print('Transposed View (Employees as Rows):');
  final employeeNames = ['alice', 'bob', 'charlie', 'diana'];
  print('Employee | Sales   | Calls | Conv Rate');
  print('─' * 40);

  for (final emp in employeeNames) {
    final sales = summaryData[emp][0] as num;
    final calls = summaryData[emp][1] as num;
    final convRate = summaryData[emp][2] as num;

    print(
      '${emp.padRight(8)} | ${sales.toString().padLeft(7)} | ${calls.toString().padLeft(5)} | ${convRate.toStringAsFixed(2).padLeft(9)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced filtering techniques
void advancedFiltering() {
  print('🔹 ADVANCED FILTERING TECHNIQUES\n');

  // Create complex dataset
  final customerData = DataFrame({
    'customer_id': List.generate(20, (i) => 1000 + i),
    'name': [
      'Alice',
      'Bob',
      'Charlie',
      'Diana',
      'Eve',
      'Frank',
      'Grace',
      'Henry',
      'Iris',
      'Jack',
      'Karen',
      'Liam',
      'Maya',
      'Noah',
      'Olivia',
      'Paul',
      'Quinn',
      'Ruby',
      'Sam',
      'Tina',
    ],
    'age': [
      25,
      34,
      45,
      28,
      52,
      31,
      29,
      38,
      41,
      33,
      27,
      44,
      36,
      30,
      48,
      26,
      39,
      32,
      42,
      35,
    ],
    'income': [
      45000,
      78000,
      95000,
      52000,
      110000,
      67000,
      48000,
      82000,
      87000,
      71000,
      49000,
      92000,
      74000,
      58000,
      105000,
      46000,
      79000,
      63000,
      89000,
      68000,
    ],
    'city': [
      'NYC',
      'LA',
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
      'Seattle',
      'Denver',
      'Boston',
      'Nashville',
      'Baltimore',
    ],
    'subscription': [
      'Basic',
      'Premium',
      'Premium',
      'Standard',
      'Premium',
      'Standard',
      'Basic',
      'Premium',
      'Premium',
      'Standard',
      'Basic',
      'Premium',
      'Standard',
      'Standard',
      'Premium',
      'Basic',
      'Premium',
      'Standard',
      'Premium',
      'Standard',
    ],
    'last_purchase_days': [
      5,
      15,
      30,
      8,
      45,
      12,
      60,
      3,
      25,
      18,
      90,
      7,
      35,
      22,
      10,
      75,
      14,
      40,
      6,
      28,
    ],
    'total_purchases': [
      12,
      8,
      15,
      6,
      22,
      10,
      4,
      18,
      13,
      9,
      3,
      20,
      11,
      7,
      25,
      5,
      16,
      8,
      19,
      12,
    ],
  });

  print('👥 Customer Dataset:');
  print(customerData.head(10));
  print('... (20 total customers)');
  print('');

  // Complex filtering conditions
  print('🔍 COMPLEX FILTERING CONDITIONS:');

  // High-value customers
  final highValueCustomers = customerData.where(
    (row) =>
        (row['income'] as num) > 80000 &&
        (row['total_purchases'] as num) > 15 &&
        row['subscription'] == 'Premium',
  );

  print('High-Value Premium Customers (Income > 80k, Purchases > 15):');
  print(highValueCustomers);
  print('');

  // Age-based segmentation
  print('👶 AGE-BASED CUSTOMER SEGMENTATION:');

  final segments = {
    'Young (18-30)': customerData.where((row) => (row['age'] as num) <= 30),
    'Middle (31-45)': customerData.where(
      (row) => (row['age'] as num) > 30 && (row['age'] as num) <= 45,
    ),
    'Mature (46+)': customerData.where((row) => (row['age'] as num) > 45),
  };

  for (final entry in segments.entries) {
    final segmentName = entry.key;
    final segmentData = entry.value;

    if (segmentData.isNotEmpty) {
      final avgIncome = segmentData['income'].data.cast<num>().average;
      final avgPurchases = segmentData['total_purchases'].data
          .cast<num>()
          .average;
      final premiumCount = segmentData['subscription'].data
          .where((s) => s == 'Premium')
          .length;

      print('$segmentName:');
      print('  Count: ${segmentData.length}');
      print('  Avg Income: \$${avgIncome.toStringAsFixed(0)}');
      print('  Avg Purchases: ${avgPurchases.toStringAsFixed(1)}');
      print(
        '  Premium Members: $premiumCount (${(premiumCount / segmentData.length * 100).toStringAsFixed(1)}%)',
      );
      print('');
    }
  }

  // Geographic analysis
  print('🌍 GEOGRAPHIC ANALYSIS:');

  final majorCities = ['NYC', 'LA', 'Chicago', 'Houston', 'Phoenix'];
  final majorCityCustomers = customerData.where(
    (row) => majorCities.contains(row['city']),
  );
  final otherCityCustomers = customerData.where(
    (row) => !majorCities.contains(row['city']),
  );

  print('Major Cities vs Others:');
  print('Major Cities (${majorCities.join(", ")}):');
  print('  Customers: ${majorCityCustomers.length}');
  if (majorCityCustomers.isNotEmpty) {
    print(
      '  Avg Income: \$${majorCityCustomers['income'].data.cast<num>().average.toStringAsFixed(0)}',
    );
    print(
      '  Avg Purchases: ${majorCityCustomers['total_purchases'].data.cast<num>().average.toStringAsFixed(1)}',
    );
  }
  print('');

  print('Other Cities:');
  print('  Customers: ${otherCityCustomers.length}');
  if (otherCityCustomers.isNotEmpty) {
    print(
      '  Avg Income: \$${otherCityCustomers['income'].data.cast<num>().average.toStringAsFixed(0)}',
    );
    print(
      '  Avg Purchases: ${otherCityCustomers['total_purchases'].data.cast<num>().average.toStringAsFixed(1)}',
    );
  }
  print('');

  // Engagement analysis
  print('📈 CUSTOMER ENGAGEMENT ANALYSIS:');

  final recentlyActive = customerData.where(
    (row) => (row['last_purchase_days'] as num) <= 14,
  );
  final moderatelyActive = customerData.where(
    (row) =>
        (row['last_purchase_days'] as num) > 14 &&
        (row['last_purchase_days'] as num) <= 45,
  );
  final inactive = customerData.where(
    (row) => (row['last_purchase_days'] as num) > 45,
  );

  print('Customer Engagement Segments:');
  print('Recently Active (≤14 days): ${recentlyActive.length} customers');
  print('Moderately Active (15-45 days): ${moderatelyActive.length} customers');
  print('Inactive (>45 days): ${inactive.length} customers');
  print('');

  // Multi-condition filtering with rankings
  print('🏆 CUSTOMER RANKING AND SCORING:');

  final customerScores = <Map<String, dynamic>>[];

  for (var i = 0; i < customerData.length; i++) {
    final income = customerData['income'][i] as num;
    final purchases = customerData['total_purchases'][i] as num;
    final recency = customerData['last_purchase_days'][i] as num;
    final isPremium = customerData['subscription'][i] == 'Premium';

    // Calculate customer score
    var score = 0.0;
    score += (income / 1000) * 0.3; // Income weight: 30%
    score += purchases * 2; // Purchases weight: high impact
    score -= recency * 0.1; // Recency penalty
    score += isPremium ? 10 : 0; // Premium bonus

    customerScores.add({
      'customer_id': customerData['customer_id'][i],
      'name': customerData['name'][i],
      'score': score,
      'income': income,
      'purchases': purchases,
      'recency': recency,
      'subscription': customerData['subscription'][i],
    });
  }

  // Sort by score
  customerScores.sort(
    (a, b) => (b['score'] as num).compareTo(a['score'] as num),
  );

  print('Top 10 Customers by Score:');
  print(
    'Rank | Name     | Score | Income | Purchases | Recency | Subscription',
  );
  print('─' * 75);

  for (var i = 0; i < 10 && i < customerScores.length; i++) {
    final c = customerScores[i];
    print(
      '${(i + 1).toString().padLeft(4)} | ${(c['name'] as String).padRight(8)} | ${(c['score'] as num).toStringAsFixed(1).padLeft(5)} | \$${(c['income'] as num).toString().padLeft(5)} | ${(c['purchases'] as num).toString().padLeft(9)} | ${(c['recency'] as num).toString().padLeft(7)} | ${c['subscription']}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates data cleaning operations
void dataCleaning() {
  print('🔹 DATA CLEANING OPERATIONS\n');

  // Create messy dataset
  final messyData = DataFrame({
    'id': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    'name': [
      'John Doe',
      'jane smith',
      'MIKE JOHNSON',
      null,
      'Lisa Brown',
      'david wilson',
      '',
      'SARAH DAVIS',
      'Tom Anderson',
      'Amy WHITE',
    ],
    'email': [
      'john@email.com',
      'jane@EMAIL.COM',
      'mike@domain.co',
      'invalid-email',
      null,
      'david@test.com',
      'lisa@company.org',
      '',
      'sarah@work.net',
      'amy@business.com',
    ],
    'age': [25, null, 35, 150, 28, -5, 45, 30, null, 42],
    'salary': [
      50000,
      60000,
      null,
      250000,
      45000,
      40000,
      75000,
      null,
      55000,
      62000,
    ],
    'department': [
      'Sales',
      'sales',
      'ENGINEERING',
      'Marketing',
      null,
      'Sales',
      'Engineering',
      'marketing',
      'HR',
      'hr',
    ],
    'phone': [
      '555-1234',
      '(555) 567-8900',
      '555.123.4567',
      '123',
      null,
      '555-999-8888',
      '',
      '+1-555-777-6666',
      '555-444-3333',
      '5551112222',
    ],
  });

  print('🗑️ Messy Dataset:');
  print(messyData);
  print('');

  // Data quality assessment
  print('📊 DATA QUALITY ASSESSMENT:');

  print('Column | Total | Nulls | Empty Strings | Valid | Quality Score');
  print('─' * 65);

  for (final column in messyData.columns) {
    final columnData = messyData[column].data;
    final total = columnData.length;
    var nullCount = 0;
    var emptyCount = 0;

    for (final value in columnData) {
      if (value == null) {
        nullCount++;
      } else if (value.toString().trim().isEmpty) {
        emptyCount++;
      }
    }

    final validCount = total - nullCount - emptyCount;
    final qualityScore = (validCount / total * 100);

    print(
      '${column.padRight(6)} | ${total.toString().padLeft(5)} | ${nullCount.toString().padLeft(5)} | ${emptyCount.toString().padLeft(13)} | ${validCount.toString().padLeft(5)} | ${qualityScore.toStringAsFixed(1).padLeft(13)}%',
    );
  }
  print('');

  // Clean names
  print('🧹 NAME CLEANING:');

  final cleanedNames = <String>[];
  for (var i = 0; i < messyData.length; i++) {
    final name = messyData['name'][i];
    String cleanedName;

    if (name == null || name.toString().trim().isEmpty) {
      cleanedName = 'Unknown';
    } else {
      // Convert to title case
      final parts = name.toString().toLowerCase().split(' ');
      cleanedName = parts
          .map(
            (part) => part.isNotEmpty
                ? part[0].toUpperCase() + part.substring(1)
                : '',
          )
          .join(' ');
    }

    cleanedNames.add(cleanedName);
  }

  print('Original Names → Cleaned Names:');
  for (var i = 0; i < messyData.length; i++) {
    final original = messyData['name'][i]?.toString() ?? 'null';
    final cleaned = cleanedNames[i];
    print('  "$original" → "$cleaned"');
  }
  print('');

  // Clean emails
  print('📧 EMAIL VALIDATION AND CLEANING:');

  final emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final cleanedEmails = <String?>[];

  for (var i = 0; i < messyData.length; i++) {
    final email = messyData['email'][i];
    String? cleanedEmail;

    if (email != null && email.toString().trim().isNotEmpty) {
      final emailStr = email.toString().toLowerCase().trim();
      if (emailPattern.hasMatch(emailStr)) {
        cleanedEmail = emailStr;
      } else {
        cleanedEmail = null; // Invalid email
      }
    } else {
      cleanedEmail = null;
    }

    cleanedEmails.add(cleanedEmail);
  }

  print('Email Validation Results:');
  var validEmails = 0;
  for (var i = 0; i < messyData.length; i++) {
    final original = messyData['email'][i]?.toString() ?? 'null';
    final cleaned = cleanedEmails[i] ?? 'INVALID';
    final isValid = cleanedEmails[i] != null;
    if (isValid) validEmails++;

    print('  "$original" → "$cleaned" ${isValid ? '✅' : '❌'}');
  }
  print(
    'Valid emails: $validEmails/${messyData.length} (${(validEmails / messyData.length * 100).toStringAsFixed(1)}%)',
  );
  print('');

  // Clean and validate age
  print('👶 AGE VALIDATION AND CLEANING:');

  final cleanedAges = <num?>[];
  for (var i = 0; i < messyData.length; i++) {
    final age = messyData['age'][i];
    num? cleanedAge;

    if (age != null) {
      final ageNum = age as num;
      if (ageNum >= 16 && ageNum <= 100) {
        cleanedAge = ageNum;
      } else {
        cleanedAge = null; // Invalid age
      }
    } else {
      cleanedAge = null;
    }

    cleanedAges.add(cleanedAge);
  }

  print('Age Validation Results:');
  for (var i = 0; i < messyData.length; i++) {
    final original = messyData['age'][i]?.toString() ?? 'null';
    final cleaned = cleanedAges[i]?.toString() ?? 'INVALID';
    final isValid = cleanedAges[i] != null;

    print('  $original → $cleaned ${isValid ? '✅' : '❌'}');
  }
  print('');

  // Standardize departments
  print('🏢 DEPARTMENT STANDARDIZATION:');

  final departmentMapping = {
    'sales': 'Sales',
    'engineering': 'Engineering',
    'marketing': 'Marketing',
    'hr': 'HR',
  };

  final standardizedDepartments = <String?>[];
  for (var i = 0; i < messyData.length; i++) {
    final dept = messyData['department'][i];
    String? standardizedDept;

    if (dept != null && dept.toString().trim().isNotEmpty) {
      final deptKey = dept.toString().toLowerCase();
      standardizedDept = departmentMapping[deptKey];
    }

    standardizedDepartments.add(standardizedDept);
  }

  print('Department Standardization:');
  for (var i = 0; i < messyData.length; i++) {
    final original = messyData['department'][i]?.toString() ?? 'null';
    final standardized = standardizedDepartments[i] ?? 'UNKNOWN';
    print('  "$original" → "$standardized"');
  }
  print('');

  // Create cleaned dataset
  print('✨ CLEANED DATASET:');

  final cleanedData = DataFrame({
    'id': messyData['id'].data,
    'name': cleanedNames,
    'email': cleanedEmails,
    'age': cleanedAges,
    'salary': messyData['salary'].data,
    'department': standardizedDepartments,
  });

  print('Cleaned Dataset:');
  print(cleanedData);
  print('');

  // Final data quality report
  print('📈 CLEANING RESULTS SUMMARY:');

  final beforeQuality = {
    'total_records': messyData.length,
    'null_values': 0,
    'invalid_values': 0,
  };

  final afterQuality = {
    'total_records': cleanedData.length,
    'null_values': 0,
    'invalid_values': 0,
  };

  // Count issues in original data
  for (final column in messyData.columns) {
    for (final value in messyData[column].data) {
      if (value == null || value.toString().trim().isEmpty) {
        beforeQuality['null_values'] = beforeQuality['null_values']! + 1;
      }
    }
  }

  // Count issues in cleaned data
  for (final column in cleanedData.columns) {
    for (final value in cleanedData[column].data) {
      if (value == null) {
        afterQuality['null_values'] = afterQuality['null_values']! + 1;
      }
    }
  }

  print('Data Quality Improvement:');
  print(
    '  Records: ${beforeQuality['total_records']} → ${afterQuality['total_records']}',
  );
  print(
    '  Null/Empty values: ${beforeQuality['null_values']} → ${afterQuality['null_values']}',
  );
  print(
    '  Quality improvement: ${((1 - afterQuality['null_values']! / beforeQuality['null_values']!) * 100).toStringAsFixed(1)}%',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced transformations
void advancedTransformations() {
  print('🔹 ADVANCED TRANSFORMATIONS\n');

  // Create financial data
  final financialData = DataFrame({
    'date': [
      '2024-01-01',
      '2024-01-02',
      '2024-01-03',
      '2024-01-04',
      '2024-01-05',
      '2024-01-08',
      '2024-01-09',
      '2024-01-10',
      '2024-01-11',
      '2024-01-12',
    ],
    'stock_price': [
      100.0,
      102.5,
      101.8,
      105.2,
      103.9,
      107.1,
      105.8,
      109.3,
      107.6,
      111.2,
    ],
    'volume': [
      1000000,
      1200000,
      900000,
      1500000,
      1100000,
      1800000,
      1300000,
      2000000,
      1600000,
      2200000,
    ],
    'high': [
      102.1,
      104.2,
      103.5,
      106.8,
      105.1,
      108.9,
      107.2,
      110.5,
      109.1,
      112.8,
    ],
    'low': [
      99.2,
      101.8,
      100.5,
      104.1,
      102.8,
      106.2,
      104.9,
      108.1,
      106.8,
      110.1,
    ],
  });

  print('📈 Financial Time Series Data:');
  print(financialData);
  print('');

  // Calculate technical indicators
  print('📊 TECHNICAL INDICATORS:');

  // Price changes and returns
  final prices = financialData['stock_price'].data.cast<num>();
  final returns = <num?>[];
  final priceChanges = <num?>[];

  returns.add(null); // First return is null
  priceChanges.add(null); // First change is null

  for (var i = 1; i < prices.length; i++) {
    final change = prices[i] - prices[i - 1];
    final returnPct = change / prices[i - 1] * 100;

    priceChanges.add(change);
    returns.add(returnPct);
  }

  print('Daily Returns and Price Changes:');
  print('Date       | Price  | Change | Return%');
  print('─' * 42);

  for (var i = 0; i < financialData.length; i++) {
    final date = financialData['date'][i];
    final price = prices[i];
    final change = priceChanges[i];
    final returnPct = returns[i];

    print(
      '$date | ${price.toStringAsFixed(1).padLeft(6)} | ${change?.toStringAsFixed(1).padLeft(6) ?? '   N/A'} | ${returnPct?.toStringAsFixed(2).padLeft(7) ?? '    N/A'}%',
    );
  }
  print('');

  // Volatility calculations
  print('📈 VOLATILITY ANALYSIS:');

  final validReturns = returns.where((r) => r != null).cast<num>().toList();
  final returnsSeries = Series<num>(validReturns);

  final volatility = returnsSeries.std();
  final meanReturn = returnsSeries.mean();

  print('Return Statistics:');
  print('  Mean Daily Return: ${meanReturn.toStringAsFixed(3)}%');
  print('  Daily Volatility: ${volatility.toStringAsFixed(3)}%');
  print(
    '  Annualized Volatility: ${(volatility * math.sqrt(252)).toStringAsFixed(2)}%',
  );
  print('');

  // Moving averages
  print('📊 MOVING AVERAGES:');

  final ma3 = <num?>[];
  final ma5 = <num?>[];

  for (var i = 0; i < prices.length; i++) {
    // 3-period MA
    if (i >= 2) {
      final avg3 = (prices[i] + prices[i - 1] + prices[i - 2]) / 3;
      ma3.add(avg3);
    } else {
      ma3.add(null);
    }

    // 5-period MA
    if (i >= 4) {
      final avg5 =
          (prices[i] +
              prices[i - 1] +
              prices[i - 2] +
              prices[i - 3] +
              prices[i - 4]) /
          5;
      ma5.add(avg5);
    } else {
      ma5.add(null);
    }
  }

  print('Moving Averages:');
  print('Date       | Price  | MA3    | MA5    | Signal');
  print('─' * 48);

  for (var i = 0; i < financialData.length; i++) {
    final date = financialData['date'][i];
    final price = prices[i];
    final ma3Val = ma3[i];
    final ma5Val = ma5[i];

    String signal = 'HOLD';
    if (ma3Val != null && ma5Val != null) {
      if (ma3Val > ma5Val && price > ma3Val) {
        signal = 'BUY';
      } else if (ma3Val < ma5Val && price < ma3Val) {
        signal = 'SELL';
      }
    }

    print(
      '$date | ${price.toStringAsFixed(1).padLeft(6)} | ${ma3Val?.toStringAsFixed(1).padLeft(6) ?? '   N/A'} | ${ma5Val?.toStringAsFixed(1).padLeft(6) ?? '   N/A'} | $signal',
    );
  }
  print('');

  // RSI calculation (simplified)
  print('📊 RELATIVE STRENGTH INDEX (RSI):');

  final gains = <num>[];
  final losses = <num>[];

  for (var i = 1; i < prices.length; i++) {
    final change = prices[i] - prices[i - 1];
    if (change > 0) {
      gains.add(change);
      losses.add(0);
    } else {
      gains.add(0);
      losses.add(-change);
    }
  }

  if (gains.isNotEmpty) {
    final avgGain = gains.average;
    final avgLoss = losses.average;
    final rs = avgGain / (avgLoss == 0 ? 0.001 : avgLoss);
    final rsi = 100 - (100 / (1 + rs));

    print('RSI Analysis:');
    print('  Average Gain: ${avgGain.toStringAsFixed(3)}');
    print('  Average Loss: ${avgLoss.toStringAsFixed(3)}');
    print('  Relative Strength: ${rs.toStringAsFixed(3)}');
    print('  RSI: ${rsi.toStringAsFixed(1)}');
    print(
      '  Signal: ${rsi > 70
          ? 'OVERBOUGHT'
          : rsi < 30
          ? 'OVERSOLD'
          : 'NEUTRAL'}',
    );
  }
  print('');

  // Volume analysis
  print('📊 VOLUME ANALYSIS:');

  final volumes = financialData['volume'].data.cast<num>();
  final avgVolume = volumes.average;

  print('Volume Statistics:');
  print('Date       | Volume   | Avg Volume | Relative | Price Trend');
  print('─' * 58);

  for (var i = 0; i < financialData.length; i++) {
    final date = financialData['date'][i];
    final volume = volumes[i];
    final relativeVol = volume / avgVolume;
    final priceTrend = i > 0
        ? (prices[i] > prices[i - 1] ? 'UP' : 'DOWN')
        : 'N/A';

    print(
      '$date | ${volume.toString().padLeft(8)} | ${avgVolume.toStringAsFixed(0).padLeft(10)} | ${relativeVol.toStringAsFixed(2).padLeft(8)} | ${priceTrend.padLeft(11)}',
    );
  }
  print('');

  // Support and resistance levels
  print('📊 SUPPORT AND RESISTANCE LEVELS:');

  final highs = financialData['high'].data.cast<num>();
  final lows = financialData['low'].data.cast<num>();

  final resistance = highs.reduce((a, b) => a > b ? a : b);
  final support = lows.reduce((a, b) => a < b ? a : b);
  final currentPrice = prices.last;

  print('Key Levels:');
  print('  Resistance: ${resistance.toStringAsFixed(2)}');
  print('  Current Price: ${currentPrice.toStringAsFixed(2)}');
  print('  Support: ${support.toStringAsFixed(2)}');
  print(
    '  Distance to Resistance: ${((resistance - currentPrice) / currentPrice * 100).toStringAsFixed(1)}%',
  );
  print(
    '  Distance to Support: ${((currentPrice - support) / currentPrice * 100).toStringAsFixed(1)}%',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates time series operations
void timeSeriesOperations() {
  print('🔹 TIME SERIES OPERATIONS\n');

  // Create time series data
  final timeSeriesData = DataFrame({
    'timestamp': [
      '2024-01-01 09:00:00',
      '2024-01-01 10:00:00',
      '2024-01-01 11:00:00',
      '2024-01-01 12:00:00',
      '2024-01-01 13:00:00',
      '2024-01-01 14:00:00',
      '2024-01-01 15:00:00',
      '2024-01-01 16:00:00',
      '2024-01-02 09:00:00',
      '2024-01-02 10:00:00',
      '2024-01-02 11:00:00',
      '2024-01-02 12:00:00',
    ],
    'temperature': [
      18.5,
      21.2,
      24.8,
      27.3,
      29.1,
      26.7,
      23.4,
      20.8,
      19.2,
      22.1,
      25.6,
      28.2,
    ],
    'humidity': [78, 72, 65, 58, 52, 61, 69, 75, 76, 70, 63, 56],
    'pressure': [
      1013.2,
      1014.1,
      1012.8,
      1011.5,
      1010.2,
      1012.9,
      1014.6,
      1015.3,
      1013.8,
      1014.7,
      1012.1,
      1010.8,
    ],
  });

  print('🌡️ Hourly Weather Time Series:');
  print(timeSeriesData);
  print('');

  // Time-based aggregation
  print('📅 TIME-BASED AGGREGATION:');

  // Group by day (extract date from timestamp)
  final dailyGroups = <String, List<int>>{};

  for (var i = 0; i < timeSeriesData.length; i++) {
    final timestamp = timeSeriesData['timestamp'][i] as String;
    final date = timestamp.split(' ')[0]; // Extract date part

    if (!dailyGroups.containsKey(date)) {
      dailyGroups[date] = [];
    }
    dailyGroups[date]!.add(i);
  }

  print('Daily Weather Summary:');
  print(
    'Date       | Avg Temp | Min Temp | Max Temp | Avg Humidity | Avg Pressure',
  );
  print('─' * 75);

  for (final entry in dailyGroups.entries) {
    final date = entry.key;
    final indices = entry.value;

    final dayTemps = indices
        .map((i) => timeSeriesData['temperature'][i] as num)
        .toList();
    final dayHumidity = indices
        .map((i) => timeSeriesData['humidity'][i] as num)
        .toList();
    final dayPressure = indices
        .map((i) => timeSeriesData['pressure'][i] as num)
        .toList();

    final avgTemp = dayTemps.average;
    final minTemp = dayTemps.reduce((a, b) => a < b ? a : b);
    final maxTemp = dayTemps.reduce((a, b) => a > b ? a : b);
    final avgHumidity = dayHumidity.average;
    final avgPressure = dayPressure.average;

    print(
      '$date | ${avgTemp.toStringAsFixed(1).padLeft(8)} | ${minTemp.toStringAsFixed(1).padLeft(8)} | ${maxTemp.toStringAsFixed(1).padLeft(8)} | ${avgHumidity.toStringAsFixed(1).padLeft(12)} | ${avgPressure.toStringAsFixed(1).padLeft(12)}',
    );
  }
  print('');

  // Trend analysis
  print('📈 TREND ANALYSIS:');

  final temperatures = timeSeriesData['temperature'].data.cast<num>();
  final tempTrends = <String>[];

  tempTrends.add('START');
  for (var i = 1; i < temperatures.length; i++) {
    final change = temperatures[i] - temperatures[i - 1];
    if (change > 0.5) {
      tempTrends.add('RISING');
    } else if (change < -0.5) {
      tempTrends.add('FALLING');
    } else {
      tempTrends.add('STABLE');
    }
  }

  print('Temperature Trend Analysis:');
  print('Time     | Temp | Trend   | Change');
  print('─' * 35);

  for (var i = 0; i < timeSeriesData.length; i++) {
    final time = (timeSeriesData['timestamp'][i] as String).split(' ')[1];
    final temp = temperatures[i];
    final trend = tempTrends[i];
    final change = i > 0 ? temperatures[i] - temperatures[i - 1] : 0;

    print(
      '${time.padRight(8)} | ${temp.toStringAsFixed(1).padLeft(4)} | ${trend.padRight(7)} | ${change.toStringAsFixed(1).padLeft(6)}',
    );
  }
  print('');

  // Seasonality detection
  print('🔄 SEASONALITY PATTERNS:');

  // Group by hour of day
  final hourlyPatterns = <int, List<num>>{};

  for (var i = 0; i < timeSeriesData.length; i++) {
    final timestamp = timeSeriesData['timestamp'][i] as String;
    final timePart = timestamp.split(' ')[1];
    final hour = int.parse(timePart.split(':')[0]);
    final temp = timeSeriesData['temperature'][i] as num;

    if (!hourlyPatterns.containsKey(hour)) {
      hourlyPatterns[hour] = [];
    }
    hourlyPatterns[hour]!.add(temp);
  }

  print('Hourly Temperature Patterns:');
  print('Hour | Avg Temp | Observations');
  print('─' * 30);

  final sortedHours = hourlyPatterns.keys.toList()..sort();
  for (final hour in sortedHours) {
    final temps = hourlyPatterns[hour]!;
    final avgTemp = temps.average;

    print(
      '${hour.toString().padLeft(4)} | ${avgTemp.toStringAsFixed(1).padLeft(8)} | ${temps.length.toString().padLeft(12)}',
    );
  }
  print('');

  // Anomaly detection
  print('🚨 ANOMALY DETECTION:');

  final tempSeries = Series<num>(temperatures);
  final tempMean = tempSeries.mean();
  final tempStd = tempSeries.std();
  final threshold = 2.0; // 2 standard deviations

  print('Temperature Anomaly Detection:');
  print('Time                | Temp | Z-Score | Status');
  print('─' * 50);

  for (var i = 0; i < timeSeriesData.length; i++) {
    final timestamp = timeSeriesData['timestamp'][i] as String;
    final temp = temperatures[i];
    final zScore = (temp - tempMean) / tempStd;
    final isAnomaly = zScore.abs() > threshold;

    print(
      '${timestamp.padRight(19)} | ${temp.toStringAsFixed(1).padLeft(4)} | ${zScore.toStringAsFixed(2).padLeft(7)} | ${isAnomaly ? '🚨 ANOMALY' : 'NORMAL'}',
    );
  }
  print('');

  print('Anomaly Detection Summary:');
  print('  Mean Temperature: ${tempMean.toStringAsFixed(2)}°C');
  print('  Standard Deviation: ${tempStd.toStringAsFixed(2)}°C');
  print('  Threshold: ±$thresholdσ');
  print(
    '  Detection Range: ${(tempMean - threshold * tempStd).toStringAsFixed(1)}°C to ${(tempMean + threshold * tempStd).toStringAsFixed(1)}°C',
  );
  print('');

  print('─' * 60);
  print('');
  print('🎉 Advanced data manipulation example complete!');
  print(
    'This example demonstrates sophisticated data manipulation techniques available in the data_frame library.',
  );
}
