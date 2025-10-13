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
