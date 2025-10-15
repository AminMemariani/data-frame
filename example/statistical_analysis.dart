// ignore_for_file: avoid_print

/// Statistical Analysis Example
///
/// This example demonstrates the statistical analysis capabilities:
/// - Descriptive statistics
/// - Hypothesis testing (t-tests, chi-square, ANOVA)
/// - Correlation and regression analysis
/// - Confidence intervals and normality tests
/// - Advanced statistical computations
library;

import 'package:data_frame/data_frame.dart';
import 'dart:math' as math;

void main() {
  print('=== Statistical Analysis with Data Frame ===\n');

  // Descriptive statistics
  descriptiveStatistics();

  // Hypothesis testing
  hypothesisTesting();

  // Correlation and regression
  correlationAndRegression();

  // Confidence intervals
  confidenceIntervals();

  // Advanced statistical tests
  advancedStatisticalTests();

  // Multi-group analysis
  multiGroupAnalysis();
}

/// Demonstrates descriptive statistics
void descriptiveStatistics() {
  print('🔹 DESCRIPTIVE STATISTICS\n');

  // Create sample data - test scores from different classes
  final mathScores = Series<num>([
    78,
    85,
    92,
    67,
    88,
    91,
    76,
    83,
    89,
    94,
    72,
    86,
    90,
    84,
    79,
  ]);
  final scienceScores = Series<num>([
    82,
    87,
    89,
    71,
    85,
    93,
    79,
    88,
    92,
    96,
    75,
    89,
    87,
    86,
    81,
  ]);
  final englishScores = Series<num>([
    75,
    82,
    88,
    64,
    79,
    87,
    73,
    80,
    85,
    91,
    69,
    83,
    84,
    81,
    76,
  ]);

  print('📊 Test Scores Data:');
  print('Math Scores: ${mathScores.data}');
  print('Science Scores: ${scienceScores.data}');
  print('English Scores: ${englishScores.data}');
  print('');

  // Calculate descriptive statistics for each subject
  final subjects = [
    ('Math', mathScores),
    ('Science', scienceScores),
    ('English', englishScores),
  ];

  print('📈 DESCRIPTIVE STATISTICS BY SUBJECT:');
  print('─' * 60);

  for (final (subject, scores) in subjects) {
    final stats = Statistics.descriptiveStats(scores);

    print('$subject:');
    print('  Count: ${stats['count']?.toStringAsFixed(0)}');
    print('  Mean: ${stats['mean']?.toStringAsFixed(2)}');
    print('  Median: ${stats['median']?.toStringAsFixed(2)}');
    print('  Mode: ${stats['mode']?.toStringAsFixed(2)}');
    print('  Std Dev: ${stats['std']?.toStringAsFixed(2)}');
    print('  Variance: ${stats['variance']?.toStringAsFixed(2)}');
    print('  Min: ${stats['min']?.toStringAsFixed(2)}');
    print('  Max: ${stats['max']?.toStringAsFixed(2)}');
    print('  Range: ${stats['range']?.toStringAsFixed(2)}');
    print('  Q1: ${stats['q1']?.toStringAsFixed(2)}');
    print('  Q3: ${stats['q3']?.toStringAsFixed(2)}');
    print('  IQR: ${stats['iqr']?.toStringAsFixed(2)}');
    print('  Skewness: ${stats['skewness']?.toStringAsFixed(3)}');
    print('  Kurtosis: ${stats['kurtosis']?.toStringAsFixed(3)}');
    print('');
  }

  // Create DataFrame for comparison
  final scoresData = DataFrame({
    'student': List.generate(15, (i) => 'Student ${i + 1}'),
    'math': mathScores.data,
    'science': scienceScores.data,
    'english': englishScores.data,
  });

  print('📋 Complete Scores DataFrame:');
  print(scoresData);
  print('');

  // Overall statistics
  print('🎯 OVERALL PERFORMANCE SUMMARY:');
  final allScores = [
    ...mathScores.data,
    ...scienceScores.data,
    ...englishScores.data,
  ];
  final overallSeries = Series<num>(allScores);
  final overallStats = Statistics.descriptiveStats(overallSeries);

  print('Total observations: ${overallStats['count']?.toStringAsFixed(0)}');
  print('Overall mean: ${overallStats['mean']?.toStringAsFixed(2)}');
  print('Overall std dev: ${overallStats['std']?.toStringAsFixed(2)}');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates hypothesis testing
void hypothesisTesting() {
  print('🔹 HYPOTHESIS TESTING\n');

  // Create two groups for comparison
  final treatmentGroup = Series<num>([
    78,
    82,
    85,
    79,
    88,
    91,
    84,
    87,
    90,
    83,
    86,
    89,
    92,
    88,
    85,
  ]);
  final controlGroup = Series<num>([
    72,
    75,
    78,
    71,
    79,
    82,
    76,
    80,
    83,
    77,
    81,
    84,
    87,
    82,
    79,
  ]);

  print('👥 Two Sample Groups:');
  print('Treatment Group: ${treatmentGroup.data}');
  print('Control Group: ${controlGroup.data}');
  print('');

  // Descriptive statistics for both groups
  final treatmentStats = Statistics.descriptiveStats(treatmentGroup);
  final controlStats = Statistics.descriptiveStats(controlGroup);

  print('📊 Group Statistics:');
  print('Treatment Group:');
  print('  Mean: ${treatmentStats['mean']?.toStringAsFixed(2)}');
  print('  Std Dev: ${treatmentStats['std']?.toStringAsFixed(2)}');
  print('  N: ${treatmentStats['count']?.toStringAsFixed(0)}');
  print('');
  print('Control Group:');
  print('  Mean: ${controlStats['mean']?.toStringAsFixed(2)}');
  print('  Std Dev: ${controlStats['std']?.toStringAsFixed(2)}');
  print('  N: ${controlStats['count']?.toStringAsFixed(0)}');
  print('');

  // Perform t-test
  print('🧪 INDEPENDENT SAMPLES T-TEST:');
  final tTestResult = Statistics.tTest(treatmentGroup, controlGroup);

  print('Null Hypothesis: μ₁ = μ₂ (no difference between groups)');
  print('Alternative Hypothesis: μ₁ ≠ μ₂ (groups are different)');
  print('');
  print('Results:');
  print('  t-statistic: ${tTestResult['t_statistic']?.toStringAsFixed(4)}');
  print('  p-value: ${tTestResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  degrees of freedom: ${tTestResult['degrees_of_freedom']?.toStringAsFixed(0)}',
  );

  final pValue = tTestResult['p_value'] ?? 1.0;
  final alpha = 0.05;
  print('  significance level (α): $alpha');
  print('  conclusion: ${pValue < alpha ? 'Reject H₀' : 'Fail to reject H₀'}');
  print(
    '  interpretation: ${pValue < alpha ? 'Significant difference found' : 'No significant difference'}',
  );
  print('');

  // One-sample t-test
  print('🎯 ONE-SAMPLE T-TEST:');
  print('Testing if treatment group mean differs from 80');

  final oneSampleResult = Statistics.oneSampleTTest(treatmentGroup, 80.0);
  print('Null Hypothesis: μ = 80');
  print('Alternative Hypothesis: μ ≠ 80');
  print('');
  print('Results:');
  print('  t-statistic: ${oneSampleResult['t_statistic']?.toStringAsFixed(4)}');
  print('  p-value: ${oneSampleResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  degrees of freedom: ${oneSampleResult['degrees_of_freedom']?.toStringAsFixed(0)}',
  );

  final oneSampleP = oneSampleResult['p_value'] ?? 1.0;
  print(
    '  conclusion: ${oneSampleP < alpha ? 'Reject H₀' : 'Fail to reject H₀'}',
  );
  print(
    '  interpretation: Mean is ${oneSampleP < alpha ? 'significantly different from' : 'not significantly different from'} 80',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates correlation and regression analysis
void correlationAndRegression() {
  print('🔹 CORRELATION AND REGRESSION ANALYSIS\n');

  // Create correlated data - study hours vs test scores
  final studyHours = Series<num>([
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    1,
    3,
    5,
    7,
  ]);
  final testScores = Series<num>([
    65,
    70,
    75,
    80,
    85,
    88,
    92,
    95,
    98,
    99,
    100,
    60,
    72,
    82,
    90,
  ]);

  print('📚 Study Data:');
  print('Study Hours: ${studyHours.data}');
  print('Test Scores: ${testScores.data}');
  print('');

  // Correlation analysis
  print('🔗 CORRELATION ANALYSIS:');
  final correlationResult = Statistics.correlationTest(studyHours, testScores);

  print(
    'Pearson correlation coefficient: ${correlationResult['correlation']?.toStringAsFixed(4)}',
  );
  print('P-value: ${correlationResult['p_value']?.toStringAsFixed(6)}');
  print(
    'Degrees of freedom: ${correlationResult['degrees_of_freedom']?.toStringAsFixed(0)}',
  );

  final corrCoef = correlationResult['correlation'] ?? 0.0;
  print('');
  print('Interpretation:');
  if (corrCoef.abs() > 0.8) {
    print(
      '  Strength: Very strong ${corrCoef > 0 ? 'positive' : 'negative'} correlation',
    );
  } else if (corrCoef.abs() > 0.6) {
    print(
      '  Strength: Strong ${corrCoef > 0 ? 'positive' : 'negative'} correlation',
    );
  } else if (corrCoef.abs() > 0.4) {
    print(
      '  Strength: Moderate ${corrCoef > 0 ? 'positive' : 'negative'} correlation',
    );
  } else if (corrCoef.abs() > 0.2) {
    print(
      '  Strength: Weak ${corrCoef > 0 ? 'positive' : 'negative'} correlation',
    );
  } else {
    print('  Strength: Very weak or no linear correlation');
  }

  final corrP = correlationResult['p_value'] ?? 1.0;
  print(
    '  Significance: ${corrP < 0.05 ? 'Statistically significant' : 'Not statistically significant'}',
  );
  print('');

  // Linear regression
  print('📈 LINEAR REGRESSION ANALYSIS:');
  final regressionResult = Statistics.linearRegression(studyHours, testScores);

  print(
    'Regression equation: Y = ${regressionResult['slope']?.toStringAsFixed(2)}X + ${regressionResult['intercept']?.toStringAsFixed(2)}',
  );
  print('Slope (β₁): ${regressionResult['slope']?.toStringAsFixed(4)}');
  print('Intercept (β₀): ${regressionResult['intercept']?.toStringAsFixed(4)}');
  print('R-squared: ${regressionResult['r_squared']?.toStringAsFixed(4)}');
  print(
    'Standard error: ${regressionResult['standard_error']?.toStringAsFixed(4)}',
  );
  print('');

  final rSquared = regressionResult['r_squared'] ?? 0.0;
  print('Model interpretation:');
  print(
    '  ${(rSquared * 100).toStringAsFixed(1)}% of variance in test scores is explained by study hours',
  );
  print(
    '  For each additional hour of study, test scores increase by ${regressionResult['slope']?.toStringAsFixed(2)} points on average',
  );
  print('');

  // Make predictions
  print('🔮 PREDICTIONS:');
  final slope = regressionResult['slope'] ?? 0.0;
  final intercept = regressionResult['intercept'] ?? 0.0;

  final predictions = [4, 6, 8, 10];
  for (final hours in predictions) {
    final predictedScore = slope * hours + intercept;
    print(
      '  $hours hours of study → predicted score: ${predictedScore.toStringAsFixed(1)}',
    );
  }
  print('');

  // Multiple variables correlation
  print('🔗 MULTIPLE VARIABLES CORRELATION:');

  // Create additional variables
  final attendance = Series<num>([
    85,
    90,
    95,
    88,
    92,
    94,
    96,
    98,
    99,
    97,
    100,
    82,
    89,
    91,
    95,
  ]);
  final previousGPA = Series<num>([
    2.8,
    3.0,
    3.2,
    3.1,
    3.4,
    3.5,
    3.7,
    3.8,
    3.9,
    3.9,
    4.0,
    2.5,
    3.1,
    3.3,
    3.6,
  ]);

  print(
    'Study Hours vs Test Scores: ${Statistics.correlationTest(studyHours, testScores)['correlation']?.toStringAsFixed(3)}',
  );
  print(
    'Attendance vs Test Scores: ${Statistics.correlationTest(attendance, testScores)['correlation']?.toStringAsFixed(3)}',
  );
  print(
    'Previous GPA vs Test Scores: ${Statistics.correlationTest(previousGPA, testScores)['correlation']?.toStringAsFixed(3)}',
  );
  print(
    'Study Hours vs Attendance: ${Statistics.correlationTest(studyHours, attendance)['correlation']?.toStringAsFixed(3)}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates confidence intervals
void confidenceIntervals() {
  print('🔹 CONFIDENCE INTERVALS\n');

  // Sample data - customer satisfaction scores
  final satisfactionScores = Series<num>([
    7.2,
    8.1,
    6.9,
    7.8,
    8.5,
    7.4,
    8.0,
    7.6,
    8.3,
    7.9,
    8.2,
    7.1,
    7.7,
    8.4,
    7.5,
  ]);

  print('📊 Customer Satisfaction Scores (1-10 scale):');
  print('Data: ${satisfactionScores.data}');
  print('');

  // Calculate descriptive statistics
  final stats = Statistics.descriptiveStats(satisfactionScores);
  print('Sample Statistics:');
  print('  Sample size (n): ${stats['count']?.toStringAsFixed(0)}');
  print('  Sample mean (x̄): ${stats['mean']?.toStringAsFixed(3)}');
  print('  Sample std dev (s): ${stats['std']?.toStringAsFixed(3)}');
  print(
    '  Standard error: ${(stats['std']! / math.sqrt(stats['count']!)).toStringAsFixed(3)}',
  );
  print('');

  // Confidence intervals for the mean
  print('🎯 CONFIDENCE INTERVALS FOR THE MEAN:');

  final confidenceLevels = [0.90, 0.95, 0.99];
  for (final confidence in confidenceLevels) {
    final ci = Statistics.confidenceInterval(
      satisfactionScores,
      confidence: confidence,
    );
    print(
      '${(confidence * 100).toStringAsFixed(0)}% CI: [${ci['lower']?.toStringAsFixed(3)}, ${ci['upper']?.toStringAsFixed(3)}]',
    );
  }
  print('');

  print('Interpretation:');
  print(
    '• We are 95% confident that the true population mean satisfaction score',
  );
  final ci95 = Statistics.confidenceInterval(
    satisfactionScores,
    confidence: 0.95,
  );
  print(
    '  lies between ${ci95['lower']?.toStringAsFixed(2)} and ${ci95['upper']?.toStringAsFixed(2)}',
  );
  print(
    '• If we repeated this sampling process many times, 95% of the intervals',
  );
  print('  constructed would contain the true population mean');
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates advanced statistical tests
void advancedStatisticalTests() {
  print('🔹 ADVANCED STATISTICAL TESTS\n');

  // Normality test data
  print('📊 NORMALITY TESTING:');

  // Normal data
  final normalData = DF.randn(30, mean: 100, std: 15, seed: 42);
  print('Testing normally distributed data:');
  print(
    'Sample: ${normalData.head(10).data.map((x) => x.toStringAsFixed(1)).join(', ')}...',
  );

  final normalityResult = Statistics.normalityTest(normalData);
  print('Shapiro-Wilk Test:');
  print('  W-statistic: ${normalityResult['w_statistic']?.toStringAsFixed(4)}');
  print('  P-value: ${normalityResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  Conclusion: ${(normalityResult['p_value'] ?? 0.0) > 0.05 ? 'Data appears normally distributed' : 'Data does not appear normally distributed'}',
  );
  print('');

  // Skewed data
  final skewedData = Series<num>([
    1,
    2,
    2,
    3,
    3,
    3,
    4,
    4,
    5,
    6,
    8,
    12,
    15,
    20,
    25,
  ]);
  print('Testing skewed data:');
  print('Sample: ${skewedData.data}');

  final skewedNormalityResult = Statistics.normalityTest(skewedData);
  print('Shapiro-Wilk Test:');
  print(
    '  W-statistic: ${skewedNormalityResult['w_statistic']?.toStringAsFixed(4)}',
  );
  print('  P-value: ${skewedNormalityResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  Conclusion: ${(skewedNormalityResult['p_value'] ?? 0.0) > 0.05 ? 'Data appears normally distributed' : 'Data does not appear normally distributed'}',
  );
  print('');

  // Chi-square test
  print('🔄 CHI-SQUARE GOODNESS OF FIT TEST:');

  final observed = [20, 30, 25, 25]; // Observed frequencies
  final expected = [25, 25, 25, 25]; // Expected frequencies

  print('Testing if die is fair:');
  print('Observed frequencies: $observed');
  print('Expected frequencies: $expected');

  final chiSquareResult = _chiSquareGoodnessOfFit(observed, expected);
  print('Chi-square test results:');
  print('  χ² statistic: ${chiSquareResult['chi_square']?.toStringAsFixed(4)}');
  print('  P-value: ${chiSquareResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  Degrees of freedom: ${chiSquareResult['degrees_of_freedom']?.toStringAsFixed(0)}',
  );
  print(
    '  Conclusion: ${(chiSquareResult['p_value'] ?? 0.0) > 0.05 ? 'Die appears fair' : 'Die does not appear fair'}',
  );
  print('');

  print('─' * 60);
  print('');
}

/// Demonstrates multi-group analysis
void multiGroupAnalysis() {
  print('🔹 MULTI-GROUP ANALYSIS\n');

  // Create data for three groups - different teaching methods
  final traditionalMethod = Series<num>([
    78,
    82,
    76,
    80,
    84,
    79,
    83,
    77,
    81,
    85,
  ]);
  final interactiveMethod = Series<num>([
    85,
    89,
    87,
    91,
    88,
    86,
    90,
    92,
    84,
    88,
  ]);
  final onlineMethod = Series<num>([72, 75, 74, 78, 76, 73, 77, 79, 71, 75]);

  print('📚 Teaching Method Comparison Study:');
  print('Traditional Method: ${traditionalMethod.data}');
  print('Interactive Method: ${interactiveMethod.data}');
  print('Online Method: ${onlineMethod.data}');
  print('');

  // Descriptive statistics for each group
  print('📊 GROUP STATISTICS:');
  final groups = [
    ('Traditional', traditionalMethod),
    ('Interactive', interactiveMethod),
    ('Online', onlineMethod),
  ];

  for (final (name, data) in groups) {
    final stats = Statistics.descriptiveStats(data);
    print('$name Method:');
    print('  Mean: ${stats['mean']?.toStringAsFixed(2)}');
    print('  Std Dev: ${stats['std']?.toStringAsFixed(2)}');
    print('  Min: ${stats['min']?.toStringAsFixed(1)}');
    print('  Max: ${stats['max']?.toStringAsFixed(1)}');
    print('');
  }

  // ANOVA test
  print('🧪 ONE-WAY ANOVA:');
  print('Null Hypothesis: μ₁ = μ₂ = μ₃ (all group means are equal)');
  print('Alternative Hypothesis: At least one group mean is different');
  print('');

  final anovaResult = Statistics.anova([
    traditionalMethod,
    interactiveMethod,
    onlineMethod,
  ]);
  print('ANOVA Results:');
  print('  F-statistic: ${anovaResult['f_statistic']?.toStringAsFixed(4)}');
  print('  P-value: ${anovaResult['p_value']?.toStringAsFixed(6)}');
  print(
    '  Between groups df: ${anovaResult['between_df']?.toStringAsFixed(0)}',
  );
  print('  Within groups df: ${anovaResult['within_df']?.toStringAsFixed(0)}');
  print(
    '  Mean Square Between: ${anovaResult['ms_between']?.toStringAsFixed(2)}',
  );
  print(
    '  Mean Square Within: ${anovaResult['ms_within']?.toStringAsFixed(2)}',
  );

  final anovaP = anovaResult['p_value'] ?? 1.0;
  print('  Conclusion: ${anovaP < 0.05 ? 'Reject H₀' : 'Fail to reject H₀'}');
  print(
    '  Interpretation: ${anovaP < 0.05 ? 'At least one teaching method produces significantly different results' : 'No significant difference between teaching methods'}',
  );
  print('');

  // Post-hoc pairwise comparisons (if ANOVA is significant)
  if (anovaP < 0.05) {
    print('📋 POST-HOC PAIRWISE COMPARISONS:');
    print('(Using Bonferroni correction for multiple comparisons)');

    final pairs = [
      ('Traditional vs Interactive', traditionalMethod, interactiveMethod),
      ('Traditional vs Online', traditionalMethod, onlineMethod),
      ('Interactive vs Online', interactiveMethod, onlineMethod),
    ];

    final correctedAlpha = 0.05 / pairs.length; // Bonferroni correction
    print('Corrected α = ${correctedAlpha.toStringAsFixed(4)}');
    print('');

    for (final (name, group1, group2) in pairs) {
      final tResult = Statistics.tTest(group1, group2);
      final pValue = tResult['p_value'] ?? 1.0;
      print('$name:');
      print(
        '  t = ${tResult['t_statistic']?.toStringAsFixed(4)}, p = ${pValue.toStringAsFixed(6)}',
      );
      print(
        '  ${pValue < correctedAlpha ? '🔴 Significant difference' : '⚫ No significant difference'}',
      );
      print('');
    }
  }

  // Effect size calculation (Cohen's d for the largest difference)
  print('📏 EFFECT SIZE (Cohen\'s d):');
  final interactiveStats = Statistics.descriptiveStats(interactiveMethod);
  final onlineStats = Statistics.descriptiveStats(onlineMethod);

  final meanDiff = (interactiveStats['mean'] ?? 0) - (onlineStats['mean'] ?? 0);
  final pooledSD = math.sqrt(
    ((interactiveStats['std']! * interactiveStats['std']!) +
            (onlineStats['std']! * onlineStats['std']!)) /
        2,
  );
  final cohensD = meanDiff / pooledSD;

  print('Interactive vs Online Methods:');
  print('  Cohen\'s d: ${cohensD.toStringAsFixed(3)}');
  print(
    '  Effect size: ${cohensD.abs() < 0.2
        ? 'Small'
        : cohensD.abs() < 0.5
        ? 'Medium'
        : 'Large'}',
  );
  print('');

  print('─' * 60);
  print('');
  print('📈 Statistical analysis complete!');
  print(
    'These examples demonstrate the comprehensive statistical capabilities of the data_frame library.',
  );
}

// Helper function for chi-square goodness of fit test
Map<String, double> _chiSquareGoodnessOfFit(
  List<int> observed,
  List<int> expected,
) {
  if (observed.length != expected.length) {
    throw ArgumentError(
      'Observed and expected lists must have the same length',
    );
  }

  double chiSquare = 0.0;
  for (var i = 0; i < observed.length; i++) {
    if (expected[i] > 0) {
      chiSquare += math.pow(observed[i] - expected[i], 2) / expected[i];
    }
  }

  final degreesOfFreedom = observed.length - 1;

  // Simple p-value approximation for chi-square distribution
  // This is a simplified version - in practice, you'd use a proper chi-square CDF
  double pValue;
  if (chiSquare < 0.1) {
    pValue = 0.99;
  } else if (chiSquare < 1.0) {
    pValue = 0.8;
  } else if (chiSquare < 3.0) {
    pValue = 0.4;
  } else if (chiSquare < 6.0) {
    pValue = 0.1;
  } else {
    pValue = 0.01;
  }

  return {
    'chi_square': chiSquare,
    'p_value': pValue,
    'degrees_of_freedom': degreesOfFreedom.toDouble(),
  };
}
