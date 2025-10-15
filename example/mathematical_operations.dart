// ignore_for_file: avoid_print

/// Mathematical Operations Example
///
/// This example demonstrates mathematical operations and transformations:
/// - Basic arithmetic operations (add, subtract, multiply, divide)
/// - Mathematical functions (sqrt, log, exp, trigonometric)
/// - Aggregation functions (sum, mean, min, max)
/// - Rolling statistics and cumulative operations
/// - Correlation matrices and statistical transformations

import 'package:data_frame/data_frame.dart';
import 'dart:math' as math;

void main() {
  print('=== Mathematical Operations with Data Frame ===\n');

  // Basic arithmetic operations
  basicArithmeticOperations();

  // Mathematical functions
  mathematicalFunctions();

  // Aggregation functions
  aggregationFunctions();

  // Rolling statistics
  rollingStatistics();

  // Cumulative operations
  cumulativeOperations();

  // Correlation and covariance
  correlationAndCovariance();

  // Advanced mathematical transformations
  advancedTransformations();

  // Financial mathematics
  financialMathematics();
}

/// Demonstrates basic arithmetic operations
void basicArithmeticOperations() {
  print('🔹 BASIC ARITHMETIC OPERATIONS\n');

  // Create sample financial data
  final financialData = DataFrame(
    {
      'revenue': [100000.0, 120000.0, 150000.0, 130000.0, 180000.0],
      'costs': [60000.0, 70000.0, 85000.0, 75000.0, 95000.0],
      'employees': [50.0, 55.0, 60.0, 58.0, 65.0],
      'marketing': [5000.0, 6000.0, 7500.0, 6500.0, 9000.0],
    },
    index: ['Q1', 'Q2', 'Q3', 'Q4', 'Q5'],
  );

  print('📊 Original Financial Data:');
  print(financialData);
  print('');

  // Addition operations
  print('➕ ADDITION OPERATIONS:');

  // Add a constant
  final inflatedRevenue = MathOps.add(financialData, 10000);
  print('Revenue inflated by \$10,000:');
  print(inflatedRevenue['revenue']);
  print('');

  // Element-wise addition of two DataFrames
  final bonusData = DataFrame(
    {
      'revenue': [5000.0, 8000.0, 12000.0, 10000.0, 15000.0],
      'costs': [2000.0, 3000.0, 4000.0, 3500.0, 4500.0],
      'employees': [2.0, 3.0, 4.0, 3.0, 5.0],
      'marketing': [500.0, 800.0, 1200.0, 1000.0, 1500.0],
    },
    index: ['Q1', 'Q2', 'Q3', 'Q4', 'Q5'],
  );

  final totalWithBonus = MathOps.add(financialData, bonusData);
  print('Financial data with bonuses added:');
  print(totalWithBonus);
  print('');

  // Subtraction operations
  print('➖ SUBTRACTION OPERATIONS:');

  // Calculate profit (revenue - costs)
  final revenueData = DataFrame({'revenue': financialData['revenue'].data});
  final costsData = DataFrame({'costs': financialData['costs'].data});
  final profit = MathOps.subtract(revenueData, costsData);
  print('Profit calculation (Revenue - Costs):');
  print('Revenue: ${revenueData['revenue'].data}');
  print('Costs: ${costsData['costs'].data}');
  print(
    'Profit: ${profit['revenue'].data}',
  ); // Result uses first DataFrame's column names
  print('');

  // Multiplication operations
  print('✖️ MULTIPLICATION OPERATIONS:');

  // Multiply by scalar (growth projection)
  final growthProjection = MathOps.multiply(financialData, 1.15); // 15% growth
  print('15% growth projection:');
  print(growthProjection);
  print('');

  // Calculate revenue per employee
  final revenuePerEmployee = <double>[];
  for (var i = 0; i < financialData.length; i++) {
    final revenue = financialData['revenue'][i] as double;
    final employees = financialData['employees'][i] as double;
    revenuePerEmployee.add(revenue / employees);
  }
  print('Revenue per employee:');
  for (var i = 0; i < financialData.length; i++) {
    print(
      '  ${financialData.index[i]}: \$${revenuePerEmployee[i].toStringAsFixed(0)}',
    );
  }
  print('');

  // Division operations
  print('➗ DIVISION OPERATIONS:');

  // Calculate margins
  final margins = <double>[];
  for (var i = 0; i < financialData.length; i++) {
    final revenue = financialData['revenue'][i] as double;
    final costs = financialData['costs'][i] as double;
    margins.add((revenue - costs) / revenue * 100);
  }
  print('Profit margins (%):');
  for (var i = 0; i < financialData.length; i++) {
    print('  ${financialData.index[i]}: ${margins[i].toStringAsFixed(1)}%');
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates mathematical functions
void mathematicalFunctions() {
  print('🔹 MATHEMATICAL FUNCTIONS\n');

  // Create sample data for mathematical operations
  final mathData = DataFrame({
    'values': [1.0, 4.0, 9.0, 16.0, 25.0, 36.0, 49.0, 64.0, 81.0, 100.0],
    'angles': [0.0, 30.0, 45.0, 60.0, 90.0, 120.0, 135.0, 150.0, 180.0, 270.0],
    'exponential': [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
    'negative': [-5.0, -3.0, -1.0, 1.0, 3.0, 5.0, 7.0, 9.0, 11.0, 13.0],
  });

  print('📊 Sample Mathematical Data:');
  print(mathData);
  print('');

  // Square root operations
  print('√ SQUARE ROOT OPERATIONS:');
  final sqrtData = MathOps.sqrt(mathData);
  print('Square roots:');
  print('Original values: ${mathData['values'].data}');
  print(
    'Square roots: ${sqrtData['values'].data.map((x) => (x as num).toStringAsFixed(2)).join(', ')}',
  );
  print('');

  // Logarithmic operations
  print('📈 LOGARITHMIC OPERATIONS:');

  // Natural logarithm
  final logData = MathOps.log(mathData);
  print('Natural logarithm of exponential column:');
  print('Original: ${mathData['exponential'].data}');
  print(
    'ln(x): ${logData['exponential'].data.map((x) => (x as num).toStringAsFixed(3)).join(', ')}',
  );
  print('');

  // Exponential operations
  print('📊 EXPONENTIAL OPERATIONS:');
  final expData = MathOps.exp(
    DataFrame({
      'small_values': [0.0, 0.5, 1.0, 1.5, 2.0],
    }),
  );
  print('Exponential function:');
  print('x: [0.0, 0.5, 1.0, 1.5, 2.0]');
  print(
    'e^x: ${expData['small_values'].data.map((x) => (x as num).toStringAsFixed(3)).join(', ')}',
  );
  print('');

  // Trigonometric operations
  print('📐 TRIGONOMETRIC OPERATIONS:');

  // Convert degrees to radians for calculations
  final radians = mathData['angles'].data
      .map((angle) => (angle as num) * math.pi / 180)
      .toList();
  final radiansData = DataFrame({'radians': radians});

  final sinData = MathOps.sin(radiansData);
  final cosData = MathOps.cos(radiansData);
  final tanData = MathOps.tan(radiansData);

  print('Trigonometric functions:');
  print('Degrees | Radians | Sin     | Cos     | Tan');
  print('─' * 45);

  for (var i = 0; i < mathData.length; i++) {
    final degrees = mathData['angles'][i] as num;
    final rad = radians[i];
    final sinVal = sinData['radians'][i] as num;
    final cosVal = cosData['radians'][i] as num;
    final tanVal = tanData['radians'][i] as num;

    print(
      '${degrees.toString().padLeft(7)} | ${rad.toStringAsFixed(3).padLeft(7)} | ${sinVal.toStringAsFixed(3).padLeft(7)} | ${cosVal.toStringAsFixed(3).padLeft(7)} | ${tanVal.toStringAsFixed(3).padLeft(7)}',
    );
  }
  print('');

  // Absolute value operations
  print('📏 ABSOLUTE VALUE OPERATIONS:');
  final absData = MathOps.abs(mathData);
  print('Absolute values of negative column:');
  print('Original: ${mathData['negative'].data}');
  print('Absolute: ${absData['negative'].data}');
  print('');

  // Power operations
  print('⚡ POWER OPERATIONS:');
  final baseData = DataFrame({
    'base': [2.0, 3.0, 4.0, 5.0],
  });
  final squaredData = MathOps.power(baseData, 2);
  final cubedData = MathOps.power(baseData, 3);

  print('Power operations:');
  print('Base | x² | x³');
  print('─' * 15);
  for (var i = 0; i < baseData.length; i++) {
    final base = baseData['base'][i] as num;
    final squared = squaredData['base'][i] as num;
    final cubed = cubedData['base'][i] as num;
    print(
      '${base.toString().padLeft(4)} | ${squared.toString().padLeft(2)} | ${cubed.toString().padLeft(2)}',
    );
  }
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates aggregation functions
void aggregationFunctions() {
  print('🔹 AGGREGATION FUNCTIONS\n');

  // Create sample sales data
  final salesData = DataFrame(
    {
      'jan': [45000, 52000, 48000, 51000, 49000],
      'feb': [47000, 54000, 50000, 53000, 51000],
      'mar': [49000, 56000, 52000, 55000, 53000],
      'apr': [51000, 58000, 54000, 57000, 55000],
      'may': [53000, 60000, 56000, 59000, 57000],
      'jun': [55000, 62000, 58000, 61000, 59000],
    },
    index: ['Region A', 'Region B', 'Region C', 'Region D', 'Region E'],
  );

  print('📊 Monthly Sales Data by Region:');
  print(salesData);
  print('');

  // Basic aggregations
  print('📈 BASIC AGGREGATIONS:');

  // Sum aggregation (using Series methods)
  print('Total sales by month:');
  for (var i = 0; i < salesData.columns.length; i++) {
    final month = salesData.columns[i];
    final total = salesData[month].data.cast<num>().fold(0.0, (a, b) => a + b);
    print('  $month: \$${total.toStringAsFixed(0)}');
  }
  print('');

  // Mean aggregation (using Series methods)
  print('Average sales by month:');
  for (var i = 0; i < salesData.columns.length; i++) {
    final month = salesData.columns[i];
    final avg = salesData[month].mean();
    print('  $month: \$${avg.toStringAsFixed(0)}');
  }
  print('');

  // Min/Max aggregations (using Series methods)
  print('Monthly performance ranges:');
  print('Month | Min     | Max     | Range');
  print('─' * 35);
  for (var i = 0; i < salesData.columns.length; i++) {
    final month = salesData.columns[i];
    final minVal = salesData[month].min() as num;
    final maxVal = salesData[month].max() as num;
    final range = maxVal - minVal;
    print(
      '${month.padRight(5)} | ${minVal.toStringAsFixed(0).padLeft(7)} | ${maxVal.toStringAsFixed(0).padLeft(7)} | ${range.toStringAsFixed(0).padLeft(5)}',
    );
  }
  print('');

  // Regional aggregations (by row)
  print('📍 REGIONAL PERFORMANCE:');

  for (var i = 0; i < salesData.length; i++) {
    final region = salesData.index[i];
    final regionData = <num>[];

    for (final month in salesData.columns) {
      regionData.add(salesData[month][i] as num);
    }

    final regionSeries = Series<num>(regionData);
    final totalSales = regionSeries.sum();
    final avgSales = regionSeries.mean();
    final minSales = regionSeries.min();
    final maxSales = regionSeries.max();

    print('$region:');
    print('  Total: \$${totalSales.toStringAsFixed(0)}');
    print('  Average: \$${avgSales.toStringAsFixed(0)}');
    print(
      '  Range: \$${minSales.toStringAsFixed(0)} - \$${maxSales.toStringAsFixed(0)}',
    );
    print('');
  }

  // Quantile calculations
  print('📊 QUANTILE ANALYSIS:');

  // Calculate quarterly performance
  final q1Data = ['jan', 'feb', 'mar']
      .map((m) => salesData[m].data.cast<num>().fold(0.0, (a, b) => a + b))
      .toList();
  final q2Data = ['apr', 'may', 'jun']
      .map((m) => salesData[m].data.cast<num>().fold(0.0, (a, b) => a + b))
      .toList();

  final q1Series = Series<num>(q1Data);
  final q2Series = Series<num>(q2Data);

  print('Quarterly totals:');
  print('Q1 (Jan-Mar): ${q1Series.data}');
  print('Q2 (Apr-Jun): ${q2Series.data}');
  print('');

  print('Q1 Statistics:');
  print('  Median: \$${_calculateMedian(q1Data).toStringAsFixed(0)}');
  print(
    '  Q1 (25th percentile): \$${_calculateQuantile(q1Data, 0.25).toStringAsFixed(0)}',
  );
  print(
    '  Q3 (75th percentile): \$${_calculateQuantile(q1Data, 0.75).toStringAsFixed(0)}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates rolling statistics
void rollingStatistics() {
  print('🔹 ROLLING STATISTICS\n');

  // Create time series data
  final timeSeriesData = DataFrame({
    'day': List.generate(20, (i) => i + 1),
    'temperature': [
      22.5,
      24.1,
      23.8,
      25.2,
      26.7,
      24.9,
      23.1,
      25.5,
      27.2,
      26.8,
      25.4,
      23.9,
      22.7,
      24.6,
      26.1,
      27.8,
      25.3,
      24.0,
      23.2,
      25.7,
    ],
    'humidity': [
      65,
      68,
      70,
      62,
      58,
      72,
      75,
      60,
      55,
      63,
      67,
      71,
      74,
      59,
      61,
      54,
      68,
      73,
      76,
      64,
    ],
    'pressure': [
      1013.2,
      1015.1,
      1012.8,
      1016.3,
      1014.7,
      1011.9,
      1017.2,
      1013.5,
      1015.8,
      1012.4,
      1014.1,
      1016.7,
      1011.3,
      1017.9,
      1013.8,
      1015.2,
      1012.6,
      1016.4,
      1014.0,
      1015.5,
    ],
  });

  print('🌡️ Weather Time Series Data (first 10 days):');
  print(timeSeriesData.head(10));
  print('');

  // Rolling mean with different window sizes
  print('📊 ROLLING MEAN ANALYSIS:');

  final rollingMean3 = MathOps.rollingMean(timeSeriesData, 3);
  final rollingMean5 = MathOps.rollingMean(timeSeriesData, 5);
  final rollingMean7 = MathOps.rollingMean(timeSeriesData, 7);

  print('Temperature rolling means:');
  print('Day | Original | 3-day MA | 5-day MA | 7-day MA');
  print('─' * 50);

  for (var i = 0; i < 15; i++) {
    // Show first 15 days
    final day = timeSeriesData['day'][i];
    final temp = timeSeriesData['temperature'][i] as num;
    final ma3 = rollingMean3['temperature'][i] as num?;
    final ma5 = rollingMean5['temperature'][i] as num?;
    final ma7 = rollingMean7['temperature'][i] as num?;

    print(
      '${day.toString().padLeft(3)} | ${temp.toStringAsFixed(1).padLeft(8)} | ${ma3?.toStringAsFixed(1).padLeft(8) ?? '   null'} | ${ma5?.toStringAsFixed(1).padLeft(8) ?? '   null'} | ${ma7?.toStringAsFixed(1).padLeft(8) ?? '   null'}',
    );
  }
  print('');

  // Rolling standard deviation
  print('📈 ROLLING VOLATILITY (Standard Deviation):');

  final rollingStd5 = MathOps.rollingStd(timeSeriesData, 5);

  print('5-day rolling standard deviation:');
  print('Day | Temperature | Humidity | Pressure');
  print('─' * 40);

  for (var i = 4; i < 15; i++) {
    // Start from day 5 (when rolling std is available)
    final day = timeSeriesData['day'][i];
    final tempStd = rollingStd5['temperature'][i] as num?;
    final humStd = rollingStd5['humidity'][i] as num?;
    final pressStd = rollingStd5['pressure'][i] as num?;

    print(
      '${day.toString().padLeft(3)} | ${tempStd?.toStringAsFixed(2).padLeft(11) ?? '       null'} | ${humStd?.toStringAsFixed(2).padLeft(8) ?? '    null'} | ${pressStd?.toStringAsFixed(2).padLeft(8) ?? '    null'}',
    );
  }
  print('');

  // Rolling min/max (support/resistance levels)
  print('📊 ROLLING MIN/MAX (Support/Resistance):');

  // Calculate rolling min/max manually since these methods don't exist
  final rollingMin7 = _calculateRollingMin(timeSeriesData, 7);
  final rollingMax7 = _calculateRollingMax(timeSeriesData, 7);

  print('7-day rolling temperature extremes:');
  print('Day | Current | 7-day Min | 7-day Max | Range');
  print('─' * 45);

  for (var i = 6; i < 15; i++) {
    // Start from day 7
    final day = timeSeriesData['day'][i];
    final current = timeSeriesData['temperature'][i] as num;
    final minVal = rollingMin7['temperature'][i] as num?;
    final maxVal = rollingMax7['temperature'][i] as num?;
    final range = (maxVal != null && minVal != null) ? maxVal - minVal : null;

    print(
      '${day.toString().padLeft(3)} | ${current.toStringAsFixed(1).padLeft(7)} | ${minVal?.toStringAsFixed(1).padLeft(9) ?? '     null'} | ${maxVal?.toStringAsFixed(1).padLeft(9) ?? '     null'} | ${range?.toStringAsFixed(1).padLeft(5) ?? ' null'}',
    );
  }
  print('');

  print('💡 Rolling Statistics Insights:');
  print('• Rolling means smooth out short-term fluctuations');
  print('• Longer windows provide smoother trends but lag current data');
  print('• Rolling std deviation measures recent volatility');
  print('• Rolling min/max help identify support and resistance levels');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates cumulative operations
void cumulativeOperations() {
  print('🔹 CUMULATIVE OPERATIONS\n');

  // Create investment portfolio data
  final portfolioData = DataFrame(
    {
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
      ],
      'investment': [
        1000,
        1500,
        2000,
        1200,
        1800,
        2200,
        1600,
        1900,
        2100,
        1700,
      ],
      'returns': [50, -30, 120, 80, -45, 150, 95, -20, 110, 85],
      'dividends': [15, 18, 22, 14, 21, 26, 19, 23, 25, 20],
    },
    index: [
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
    ],
  );

  print('💼 Investment Portfolio Data:');
  print(portfolioData);
  print('');

  // Cumulative sum
  print('📈 CUMULATIVE SUMS:');

  final cumSumData = MathOps.cumSum(portfolioData);

  print('Cumulative investment and returns:');
  print('Month | Investment | Returns | Total Invested | Cumulative Returns');
  print('─' * 65);

  for (var i = 0; i < portfolioData.length; i++) {
    final month = portfolioData['month'][i];
    final investment = portfolioData['investment'][i] as num;
    final returns = portfolioData['returns'][i] as num;
    final cumInvestment = cumSumData['investment'][i] as num;
    final cumReturns = cumSumData['returns'][i] as num;

    print(
      '${month.toString().padRight(5)} | ${investment.toString().padLeft(10)} | ${returns.toString().padLeft(7)} | ${cumInvestment.toString().padLeft(14)} | ${cumReturns.toString().padLeft(18)}',
    );
  }
  print('');

  // Cumulative product (compound growth)
  print('📊 COMPOUND GROWTH ANALYSIS:');

  // Calculate monthly growth rates (1 + return_rate)
  final growthRates = portfolioData['returns'].data
      .map((ret) => 1 + (ret as num) / 1000)
      .toList();
  final growthData = DataFrame({'growth_rate': growthRates});

  final cumProductData = MathOps.cumProd(growthData);

  print('Compound growth analysis:');
  print('Month | Monthly Return | Growth Rate | Cumulative Growth');
  print('─' * 55);

  for (var i = 0; i < portfolioData.length; i++) {
    final month = portfolioData['month'][i];
    final monthlyReturn = portfolioData['returns'][i] as num;
    final growthRate = growthRates[i];
    final cumGrowth = cumProductData['growth_rate'][i] as num;

    print(
      '${month.toString().padRight(5)} | ${monthlyReturn.toString().padLeft(14)} | ${growthRate.toStringAsFixed(3).padLeft(11)} | ${cumGrowth.toStringAsFixed(3).padLeft(17)}',
    );
  }
  print('');

  // Cumulative maximum (high water mark)
  print('🏔️ HIGH WATER MARK ANALYSIS:');

  // Calculate portfolio value over time
  final portfolioValues = <num>[];
  var runningValue = 10000.0; // Starting portfolio value

  for (var i = 0; i < portfolioData.length; i++) {
    final returns = portfolioData['returns'][i] as num;
    runningValue += returns;
    portfolioValues.add(runningValue);
  }

  final valueData = DataFrame({'portfolio_value': portfolioValues});
  // Calculate cumulative max manually since this method doesn't exist
  final cumMaxData = _calculateCumMax(valueData);

  print('Portfolio high water mark:');
  print('Month | Portfolio Value | High Water Mark | Drawdown');
  print('─' * 55);

  for (var i = 0; i < portfolioData.length; i++) {
    final month = portfolioData['month'][i];
    final value = portfolioValues[i];
    final highWaterMark = cumMaxData['portfolio_value'][i] as num;
    final drawdown = ((value - highWaterMark) / highWaterMark * 100);

    print(
      '${month.toString().padRight(5)} | ${value.toStringAsFixed(0).padLeft(15)} | ${highWaterMark.toStringAsFixed(0).padLeft(15)} | ${drawdown.toStringAsFixed(1).padLeft(8)}%',
    );
  }
  print('');

  // Cumulative minimum (support levels)
  print('📉 SUPPORT LEVEL ANALYSIS:');

  // Calculate cumulative min manually since this method doesn't exist
  final cumMinData = _calculateCumMin(valueData);

  print('Portfolio support levels:');
  print('Month | Current Value | Support Level | Distance from Support');
  print('─' * 60);

  for (var i = 0; i < portfolioData.length; i++) {
    final month = portfolioData['month'][i];
    final value = portfolioValues[i];
    final supportLevel = cumMinData['portfolio_value'][i] as num;
    final distanceFromSupport = ((value - supportLevel) / supportLevel * 100);

    print(
      '${month.toString().padRight(5)} | ${value.toStringAsFixed(0).padLeft(13)} | ${supportLevel.toStringAsFixed(0).padLeft(13)} | ${distanceFromSupport.toStringAsFixed(1).padLeft(20)}%',
    );
  }
  print('');

  print('💡 Cumulative Operations Insights:');
  print('• Cumulative sum shows total accumulated values');
  print('• Cumulative product reveals compound growth effects');
  print('• Cumulative max tracks peak performance (high water mark)');
  print('• Cumulative min identifies support levels');
  print(
    '• These operations are essential for financial and time series analysis',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates correlation and covariance calculations
void correlationAndCovariance() {
  print('🔹 CORRELATION AND COVARIANCE ANALYSIS\n');

  // Create multi-asset portfolio data
  final assetData = DataFrame({
    'stocks': [0.12, -0.03, 0.08, 0.15, -0.05, 0.11, 0.07, -0.02, 0.09, 0.13],
    'bonds': [0.04, 0.02, 0.03, -0.01, 0.05, 0.02, 0.04, 0.03, 0.01, 0.02],
    'commodities': [
      0.18,
      -0.12,
      0.25,
      0.08,
      -0.15,
      0.22,
      -0.08,
      0.14,
      0.11,
      -0.06,
    ],
    'real_estate': [0.09, 0.02, 0.07, 0.12, 0.01, 0.08, 0.05, 0.03, 0.10, 0.06],
    'crypto': [0.35, -0.28, 0.42, -0.18, 0.31, -0.22, 0.29, -0.15, 0.38, -0.12],
  }, index: List.generate(10, (i) => 'Month ${i + 1}'));

  print('📊 Multi-Asset Returns Data (monthly returns):');
  print(assetData);
  print('');

  // Correlation matrix
  print('🔗 CORRELATION MATRIX:');

  final correlationMatrix = MathOps.corr(assetData);
  print('Asset correlation matrix:');
  print(correlationMatrix);
  print('');

  // Interpret correlations
  print('📈 CORRELATION INTERPRETATION:');
  final assets = assetData.columns;

  print('Strong correlations (|r| > 0.7):');
  for (var i = 0; i < assets.length; i++) {
    for (var j = i + 1; j < assets.length; j++) {
      final corr = correlationMatrix[assets[j]][i] as num;
      if (corr.abs() > 0.7) {
        final strength = corr > 0 ? 'Positive' : 'Negative';
        print(
          '  ${assets[i]} ↔ ${assets[j]}: ${corr.toStringAsFixed(3)} ($strength)',
        );
      }
    }
  }
  print('');

  print('Moderate correlations (0.3 < |r| < 0.7):');
  for (var i = 0; i < assets.length; i++) {
    for (var j = i + 1; j < assets.length; j++) {
      final corr = correlationMatrix[assets[j]][i] as num;
      if (corr.abs() > 0.3 && corr.abs() <= 0.7) {
        final strength = corr > 0 ? 'Positive' : 'Negative';
        print(
          '  ${assets[i]} ↔ ${assets[j]}: ${corr.toStringAsFixed(3)} ($strength)',
        );
      }
    }
  }
  print('');

  // Covariance matrix
  print('📊 COVARIANCE MATRIX:');

  final covarianceMatrix = MathOps.cov(assetData);
  print('Asset covariance matrix:');
  print(covarianceMatrix);
  print('');

  // Portfolio risk analysis
  print('⚖️ PORTFOLIO RISK ANALYSIS:');

  // Calculate portfolio metrics for equal-weight portfolio
  final numAssets = assets.length;
  final equalWeight = 1.0 / numAssets;

  print('Equal-weight portfolio analysis:');
  print('Asset allocation: ${(equalWeight * 100).toStringAsFixed(1)}% each');
  print('');

  // Calculate individual asset statistics
  print('Individual asset statistics:');
  print('Asset        | Mean Return | Volatility | Sharpe Ratio*');
  print('─' * 55);

  for (final asset in assets) {
    final returns = assetData[asset].data.cast<num>();
    final returnsSeries = Series<num>(returns);

    final meanReturn = returnsSeries.mean() * 100; // Convert to percentage
    final volatility = returnsSeries.std() * 100; // Convert to percentage
    final sharpeRatio = meanReturn / volatility; // Simplified Sharpe ratio

    print(
      '${asset.padRight(12)} | ${meanReturn.toStringAsFixed(2).padLeft(11)}% | ${volatility.toStringAsFixed(2).padLeft(10)}% | ${sharpeRatio.toStringAsFixed(2).padLeft(12)}',
    );
  }
  print('* Simplified calculation (mean/std), assuming zero risk-free rate');
  print('');

  // Portfolio diversification benefit
  print('🎯 DIVERSIFICATION ANALYSIS:');

  // Calculate weighted average volatility vs actual portfolio volatility
  var weightedAvgVol = 0.0;
  for (final asset in assets) {
    final returns = assetData[asset].data.cast<num>();
    final volatility = Series<num>(returns).std();
    weightedAvgVol += equalWeight * volatility;
  }

  // Calculate actual portfolio returns
  final portfolioReturns = <num>[];
  for (var i = 0; i < assetData.length; i++) {
    var portfolioReturn = 0.0;
    for (final asset in assets) {
      portfolioReturn += equalWeight * (assetData[asset][i] as num);
    }
    portfolioReturns.add(portfolioReturn);
  }

  final portfolioVolatility = Series<num>(portfolioReturns).std();
  final diversificationBenefit =
      (weightedAvgVol - portfolioVolatility) / weightedAvgVol * 100;

  print('Diversification benefit:');
  print(
    '  Weighted average volatility: ${(weightedAvgVol * 100).toStringAsFixed(2)}%',
  );
  print(
    '  Actual portfolio volatility: ${(portfolioVolatility * 100).toStringAsFixed(2)}%',
  );
  print(
    '  Diversification benefit: ${diversificationBenefit.toStringAsFixed(1)}%',
  );
  print('');

  print('💡 Risk Management Insights:');
  print('• Lower correlations provide better diversification');
  print('• Covariance helps calculate portfolio risk');
  print('• Negative correlations are especially valuable for hedging');
  print('• Diversification reduces risk without necessarily reducing returns');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced mathematical transformations
void advancedTransformations() {
  print('🔹 ADVANCED MATHEMATICAL TRANSFORMATIONS\n');

  // Create sample data with different distributions
  final rawData = DataFrame({
    'normal_data': [100, 102, 98, 105, 97, 103, 99, 101, 104, 96],
    'skewed_data': [10, 12, 15, 25, 45, 78, 125, 200, 350, 600],
    'volatile_data': [50, 75, 45, 85, 40, 90, 35, 95, 30, 100],
    'periodic_data': [0, 3, 6, 9, 6, 3, 0, -3, -6, -9],
  });

  print('📊 Raw Data with Different Distributions:');
  print(rawData);
  print('');

  // Normalization (Z-score)
  print('📏 Z-SCORE NORMALIZATION:');

  // final normalizedData = DataFrame.empty(); // Not used in this example

  for (final column in rawData.columns) {
    final data = rawData[column].data.cast<num>();
    final series = Series<num>(data);
    final mean = series.mean();
    final std = series.std();

    final zScores = data.map((x) => (x - mean) / std).toList();

    print('$column normalization:');
    print(
      '  Original mean: ${mean.toStringAsFixed(2)}, std: ${std.toStringAsFixed(2)}',
    );
    print('  Z-scores: ${zScores.map((z) => z.toStringAsFixed(2)).join(', ')}');
    print('  Z-score mean: ${Series<num>(zScores).mean().toStringAsFixed(3)}');
    print('  Z-score std: ${Series<num>(zScores).std().toStringAsFixed(3)}');
    print('');
  }

  // Min-Max normalization
  print('📐 MIN-MAX NORMALIZATION (0-1 scaling):');

  for (final column in rawData.columns) {
    final data = rawData[column].data.cast<num>();
    final series = Series<num>(data);
    final min = series.min();
    final max = series.max();

    final normalized = data.map((x) => (x - min) / (max - min)).toList();

    print('$column min-max scaling:');
    print(
      '  Original range: ${min.toStringAsFixed(1)} to ${max.toStringAsFixed(1)}',
    );
    print(
      '  Normalized: ${normalized.map((n) => n.toStringAsFixed(3)).join(', ')}',
    );
    print(
      '  New range: ${Series<num>(normalized).min().toStringAsFixed(3)} to ${Series<num>(normalized).max().toStringAsFixed(3)}',
    );
    print('');
  }

  // Logarithmic transformation (for skewed data)
  print('📈 LOGARITHMIC TRANSFORMATION:');

  final skewedData = rawData['skewed_data'].data.cast<num>();
  final logTransformed = skewedData.map((x) => math.log(x)).toList();

  print('Skewed data transformation:');
  print('  Original: ${skewedData.join(', ')}');
  print(
    '  Log-transformed: ${logTransformed.map((l) => l.toStringAsFixed(2)).join(', ')}',
  );
  print('  Original std: ${Series<num>(skewedData).std().toStringAsFixed(2)}');
  print(
    '  Log-transformed std: ${Series<num>(logTransformed).std().toStringAsFixed(2)}',
  );
  print('');

  // Box-Cox transformation simulation
  print('📦 POWER TRANSFORMATION (Box-Cox style):');

  final volatileData = rawData['volatile_data'].data.cast<num>();

  // Try different lambda values
  final lambdaValues = [0.5, 0.0, -0.5]; // 0.0 represents log transformation

  for (final lambda in lambdaValues) {
    List<num> transformed;

    if (lambda == 0.0) {
      transformed = volatileData.map((x) => math.log(x)).toList();
    } else {
      transformed = volatileData
          .map((x) => (math.pow(x, lambda) - 1) / lambda)
          .toList();
    }

    final originalStd = Series<num>(volatileData).std();
    final transformedStd = Series<num>(transformed).std();

    print('λ = $lambda:');
    print(
      '  Transformed data: ${transformed.map((t) => t.toStringAsFixed(2)).join(', ')}',
    );
    print(
      '  Std reduction: ${originalStd.toStringAsFixed(2)} → ${transformedStd.toStringAsFixed(2)} (${((transformedStd / originalStd - 1) * 100).toStringAsFixed(1)}%)',
    );
    print('');
  }

  // Rank transformation
  print('🏆 RANK TRANSFORMATION:');

  for (final column in rawData.columns) {
    final data = rawData[column].data.cast<num>();

    // Create list of (value, original_index) pairs
    final indexedData = data
        .asMap()
        .entries
        .map((e) => MapEntry(e.value, e.key))
        .toList();

    // Sort by value
    indexedData.sort((a, b) => a.key.compareTo(b.key));

    // Assign ranks
    final ranks = List<num>.filled(data.length, 0);
    for (var i = 0; i < indexedData.length; i++) {
      final originalIndex = indexedData[i].value;
      ranks[originalIndex] = i + 1; // Ranks start from 1
    }

    print('$column ranks:');
    print('  Original: ${data.join(', ')}');
    print('  Ranks: ${ranks.join(', ')}');
    print(
      '  Rank correlation with original: ${_calculateRankCorrelation(data, ranks).toStringAsFixed(3)}',
    );
    print('');
  }

  print('💡 Transformation Guidelines:');
  print('• Z-score normalization: Use when data is normally distributed');
  print('• Min-max scaling: Use when you need bounded values (0-1)');
  print('• Log transformation: Use for right-skewed data');
  print('• Box-Cox: Use to stabilize variance and normalize distribution');
  print('• Rank transformation: Use for non-parametric analysis');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates financial mathematics applications
void financialMathematics() {
  print('🔹 FINANCIAL MATHEMATICS APPLICATIONS\n');

  // Create financial time series data
  final stockPrices = DataFrame({
    'date': List.generate(
      10,
      (i) => '2024-01-${(i + 1).toString().padLeft(2, '0')}',
    ),
    'price': [
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
  });

  print('📈 Stock Price Data:');
  print(stockPrices);
  print('');

  // Calculate returns
  print('💰 RETURN CALCULATIONS:');

  final prices = stockPrices['price'].data.cast<num>();
  final simpleReturns = <num>[];
  final logReturns = <num>[];

  for (var i = 1; i < prices.length; i++) {
    final simpleReturn = (prices[i] - prices[i - 1]) / prices[i - 1];
    final logReturn = math.log(prices[i] / prices[i - 1]);

    simpleReturns.add(simpleReturn);
    logReturns.add(logReturn);
  }

  print('Daily returns analysis:');
  print('Date     | Price  | Simple Return | Log Return');
  print('─' * 50);

  for (var i = 0; i < simpleReturns.length; i++) {
    final date = stockPrices['date'][i + 1];
    final price = prices[i + 1];
    final simpleRet = simpleReturns[i];
    final logRet = logReturns[i];

    print(
      '$date | ${price.toStringAsFixed(1).padLeft(6)} | ${(simpleRet * 100).toStringAsFixed(2).padLeft(13)}% | ${(logRet * 100).toStringAsFixed(2).padLeft(10)}%',
    );
  }
  print('');

  // Volatility calculations
  print('📊 VOLATILITY ANALYSIS:');

  final simpleReturnsSeries = Series<num>(simpleReturns);
  final logReturnsSeries = Series<num>(logReturns);

  final simpleVolatility =
      simpleReturnsSeries.std() * math.sqrt(252) * 100; // Annualized
  final logVolatility =
      logReturnsSeries.std() * math.sqrt(252) * 100; // Annualized

  print('Volatility measures:');
  print(
    '  Daily volatility (simple): ${(simpleReturnsSeries.std() * 100).toStringAsFixed(2)}%',
  );
  print(
    '  Daily volatility (log): ${(logReturnsSeries.std() * 100).toStringAsFixed(2)}%',
  );
  print(
    '  Annualized volatility (simple): ${simpleVolatility.toStringAsFixed(2)}%',
  );
  print('  Annualized volatility (log): ${logVolatility.toStringAsFixed(2)}%');
  print('');

  // Value at Risk (VaR) calculation
  print('⚠️ VALUE AT RISK (VaR) ANALYSIS:');

  // Assume \$10,000 position
  final position = 10000.0;
  final confidenceLevels = [0.95, 0.99];

  // Sort returns for percentile calculation
  final sortedReturns = List<num>.from(simpleReturns)..sort();

  for (final confidence in confidenceLevels) {
    final percentileIndex = ((1 - confidence) * sortedReturns.length).floor();
    final varReturn = sortedReturns[percentileIndex];
    final varAmount = position * varReturn.abs();

    print('${(confidence * 100).toStringAsFixed(0)}% VaR:');
    print(
      '  Daily VaR: \$${varAmount.toStringAsFixed(0)} (${(varReturn * 100).toStringAsFixed(2)}%)',
    );
    print('  10-day VaR: \$${(varAmount * math.sqrt(10)).toStringAsFixed(0)}');
    print('');
  }

  // Technical indicators
  print('📊 TECHNICAL INDICATORS:');

  // Simple Moving Average
  final sma5 = MathOps.rollingMean(DataFrame({'price': prices}), 5);

  print('5-period Simple Moving Average:');
  for (var i = 4; i < prices.length; i++) {
    final date = stockPrices['date'][i];
    final price = prices[i];
    final smaValue = sma5['price'][i] as num?;

    print(
      '$date: Price \$${price.toStringAsFixed(2)}, SMA \$${smaValue?.toStringAsFixed(2) ?? 'N/A'}',
    );
  }
  print('');

  // Bollinger Bands (simplified)
  print('📈 BOLLINGER BANDS (20-period equivalent):');

  // Use all available data for this example
  final allPricesSeries = Series<num>(prices);
  final mean = allPricesSeries.mean();
  final std = allPricesSeries.std();

  final upperBand = mean + (2 * std);
  final lowerBand = mean - (2 * std);

  print('Bollinger Bands (using current data):');
  print('  Upper Band: \$${upperBand.toStringAsFixed(2)}');
  print('  Middle Band (SMA): \$${mean.toStringAsFixed(2)}');
  print('  Lower Band: \$${lowerBand.toStringAsFixed(2)}');
  print('  Current Price: \$${prices.last.toStringAsFixed(2)}');
  print(
    '  Position: ${prices.last > upperBand
        ? 'Above upper band'
        : prices.last < lowerBand
        ? 'Below lower band'
        : 'Within bands'}',
  );
  print('');

  // Compound Annual Growth Rate (CAGR)
  print('📈 COMPOUND ANNUAL GROWTH RATE (CAGR):');

  final startPrice = prices.first;
  final endPrice = prices.last;
  final periods = prices.length - 1;

  // Assuming daily periods, convert to annual
  final yearsEquivalent = periods / 252.0; // 252 trading days per year
  final cagr = math.pow(endPrice / startPrice, 1 / yearsEquivalent) - 1;

  print('CAGR calculation:');
  print('  Start price: \$${startPrice.toStringAsFixed(2)}');
  print('  End price: \$${endPrice.toStringAsFixed(2)}');
  print(
    '  Periods: $periods days (${yearsEquivalent.toStringAsFixed(4)} years)',
  );
  print('  CAGR: ${(cagr * 100).toStringAsFixed(2)}% annually');
  print('');

  // Sharpe Ratio
  print('📊 SHARPE RATIO:');

  final avgReturn = simpleReturnsSeries.mean();
  final riskFreeRate = 0.02 / 252; // 2% annual risk-free rate, daily
  final excessReturn = avgReturn - riskFreeRate;
  final sharpeRatio = excessReturn / simpleReturnsSeries.std();
  final annualizedSharpe = sharpeRatio * math.sqrt(252);

  print('Sharpe ratio calculation:');
  print('  Average daily return: ${(avgReturn * 100).toStringAsFixed(4)}%');
  print('  Daily risk-free rate: ${(riskFreeRate * 100).toStringAsFixed(4)}%');
  print('  Excess return: ${(excessReturn * 100).toStringAsFixed(4)}%');
  print('  Daily Sharpe ratio: ${sharpeRatio.toStringAsFixed(4)}');
  print('  Annualized Sharpe ratio: ${annualizedSharpe.toStringAsFixed(2)}');
  print('');

  print('💡 Financial Mathematics Insights:');
  print('• Log returns are additive and more suitable for long-term analysis');
  print('• Volatility clustering is common in financial time series');
  print('• VaR helps quantify potential losses at given confidence levels');
  print('• Technical indicators help identify trends and trading signals');
  print(
    '• Risk-adjusted metrics like Sharpe ratio are crucial for portfolio evaluation',
  );
  print('');

  print('─' * 60);
  print('');
  print('🎉 Mathematical operations example complete!');
  print(
    'This comprehensive example demonstrates the full range of mathematical capabilities available in the data_frame library.',
  );
}

/// Helper function to calculate rank correlation
double _calculateRankCorrelation(List<num> x, List<num> y) {
  final n = x.length;
  var sumD2 = 0.0;

  for (var i = 0; i < n; i++) {
    final d = x[i] - y[i];
    sumD2 += d * d;
  }

  return 1.0 - (6.0 * sumD2) / (n * (n * n - 1));
}

// Helper functions for missing MathOps methods
DataFrame _calculateRollingMin(DataFrame df, int window) {
  final result = <String, List<double>>{};

  for (final col in df.columns) {
    final series = df[col];
    final values = series.data.cast<num>().toList();
    final rollingMins = <double>[];

    for (var i = 0; i < values.length; i++) {
      if (i < window - 1) {
        rollingMins.add(double.nan);
      } else {
        final windowValues = values.sublist(i - window + 1, i + 1);
        final min = windowValues.reduce((a, b) => a < b ? a : b);
        rollingMins.add(min.toDouble());
      }
    }

    result[col] = rollingMins;
  }

  return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
}

DataFrame _calculateRollingMax(DataFrame df, int window) {
  final result = <String, List<double>>{};

  for (final col in df.columns) {
    final series = df[col];
    final values = series.data.cast<num>().toList();
    final rollingMaxs = <double>[];

    for (var i = 0; i < values.length; i++) {
      if (i < window - 1) {
        rollingMaxs.add(double.nan);
      } else {
        final windowValues = values.sublist(i - window + 1, i + 1);
        final max = windowValues.reduce((a, b) => a > b ? a : b);
        rollingMaxs.add(max.toDouble());
      }
    }

    result[col] = rollingMaxs;
  }

  return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
}

DataFrame _calculateCumMax(DataFrame df) {
  final result = <String, List<double>>{};

  for (final col in df.columns) {
    final series = df[col];
    final values = series.data.cast<num>().toList();
    final cumMaxs = <double>[];
    double runningMax = double.negativeInfinity;

    for (final value in values) {
      if (value > runningMax) {
        runningMax = value.toDouble();
      }
      cumMaxs.add(runningMax);
    }

    result[col] = cumMaxs;
  }

  return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
}

DataFrame _calculateCumMin(DataFrame df) {
  final result = <String, List<double>>{};

  for (final col in df.columns) {
    final series = df[col];
    final values = series.data.cast<num>().toList();
    final cumMins = <double>[];
    double runningMin = double.infinity;

    for (final value in values) {
      if (value < runningMin) {
        runningMin = value.toDouble();
      }
      cumMins.add(runningMin);
    }

    result[col] = cumMins;
  }

  return DataFrame(result.cast<String, List<dynamic>>(), index: df.index);
}

// Helper functions for statistical calculations
double _calculateMedian(List<num> data) {
  final sorted = List<num>.from(data)..sort();
  final n = sorted.length;
  if (n % 2 == 0) {
    return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2;
  } else {
    return sorted[n ~/ 2].toDouble();
  }
}

double _calculateQuantile(List<num> data, double quantile) {
  final sorted = List<num>.from(data)..sort();
  final n = sorted.length;
  final index = quantile * (n - 1);
  final lower = sorted[index.floor()];
  final upper = sorted[index.ceil()];
  return lower + (upper - lower) * (index - index.floor());
}
