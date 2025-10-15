## 1.2.0 - 2025-10-15

### Example Reliability and Docs Update ✅

#### Improvements
- Verified and fixed all example programs to run without runtime errors
- Numeric-safe aggregations using Series<num> where required
- Corrected DataFrame operations (element-wise subtraction alignment, cumSum inputs)
- Fixed joins by aligning key columns in examples
- Robust handling for grouped keys (string/int) in month parsing
- Minor formatting and interpolation fixes in examples

#### Documentation
- Updated README badge and installation version to 1.2.0
- Added notes on running examples and stability improvements

#### Misc
- No API changes; minor release focused on quality and documentation

## 1.1.0 - 2025-01-27

### Major Release with Comprehensive Examples and Improvements 🚀

#### New Features
- **Complete Example Suite**: Added 8 comprehensive example files demonstrating all library features
  - `main.dart` - Complete overview with all major features
  - `basic_operations.dart` - DataFrame and Series fundamentals
  - `statistical_analysis.dart` - Statistical tests and analysis
  - `data_io_operations.dart` - CSV, JSON, and URL data operations
  - `mathematical_operations.dart` - Mathematical functions and transformations
  - `advanced_data_manipulation.dart` - Grouping, joining, and advanced operations
  - `sample_data_generation.dart` - Data generation utilities
  - `real_world_analysis.dart` - Complete business intelligence workflow

#### Improvements
- **Enhanced Statistical Functions**: Fixed confidence interval calculations and chi-square tests
- **Better Error Handling**: Improved method signatures and parameter validation
- **Code Quality**: Fixed all linting issues and improved code formatting

#### Dependencies
- **Updated to Latest Versions**: All package dependencies updated to latest stable versions
  - `collection`: ^1.19.1 (from ^1.18.0)
  - `meta`: ^1.17.0 (from ^1.15.0)
  - `intl`: ^0.20.2 (from ^0.19.0)
  - `test`: ^1.26.3 (from ^1.25.6)

#### Bug Fixes
- Fixed `confidenceInterval` method signature and parameter handling
- Resolved compatibility issues with updated `collection` package
- Fixed `chiSquareTest` method calls and added proper goodness of fit test
- Corrected DataFrame join method parameters
- Fixed mathematical function calls and type conversions

#### Documentation
- Added comprehensive README with detailed examples
- Created example guide with step-by-step instructions
- Improved inline documentation and code comments

## 1.0.0 - 2025-10-13

### Initial Release 🎉

A comprehensive data manipulation and analysis library for Dart, inspired by Python's pandas library.

**Package Name**: `data_frame`  
**Repository**: https://github.com/AminMemariani/data-frame

#### Features

**Core Data Structures**
- `Series<T>` - One-dimensional labeled arrays with generic type support
- `DataFrame` - Two-dimensional labeled data structures with mixed types

**Data Manipulation**
- Filtering, sorting, grouping operations
- Join operations (inner, left, right)
- Column and row selection
- Null value handling (dropna, fillna)
- Data transformation (map, where, sort)

**Statistical Analysis**
- Descriptive statistics (mean, std, quartiles, skewness, kurtosis)
- Hypothesis testing (t-tests, ANOVA, chi-square)
- Correlation analysis (Pearson, Spearman)
- Linear regression with R-squared and p-values
- Confidence intervals
- Normality tests (Shapiro-Wilk, Jarque-Bera, Anderson-Darling)

**Mathematical Operations**
- Element-wise operations (add, subtract, multiply, divide, power)
- Mathematical functions (abs, sqrt, log, exp, sin, cos, tan)
- Rolling statistics (mean, sum, std)
- Cumulative operations (cumsum, cumprod)
- Percentage change and differences
- Data clipping and rounding

**Data I/O**
- CSV file reading and writing with customizable options
- JSON file operations with multiple orientations (records, columns, index)
- URL data fetching
- Sample data generation (numeric, mixed, time series)
- Database query result conversion

**Utility Functions**
- Range generation (numeric and date ranges)
- Random data generation (normal and uniform distributions)
- Data concatenation and merging
- Factory methods for common operations

#### Test Coverage
- 87 comprehensive unit tests
- 100% public API coverage
- Edge case and error condition testing
- 2,656 lines of implementation
- 1,414 lines of test code

#### Documentation
- Complete API documentation
- Usage examples
- Test coverage report
- Comprehensive README

#### Known Limitations
- URL fetching requires network access
- Very large datasets (>10M rows) may have performance considerations
- Statistical approximations used for some complex distributions
