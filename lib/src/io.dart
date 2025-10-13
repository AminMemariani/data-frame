import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:csv/csv.dart';
import 'dataframe.dart';

/// Data input/output functions for reading and writing various formats.
class DataIO {
  /// Reads a CSV file and returns a DataFrame.
  static Future<DataFrame> readCsv(
    String filePath, {
    String separator = ',',
    bool hasHeader = true,
    List<String>? columnNames,
    Map<String, Type>? dtypes,
    int? nrows,
    int skiprows = 0,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found: $filePath');
    }

    final content = await file.readAsString();
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(content, fieldDelimiter: separator);

    if (rows.isEmpty) {
      return DataFrame.empty();
    }

    List<String> headers;
    List<List<dynamic>> dataRows;

    if (hasHeader) {
      headers = rows.first.cast<String>();
      dataRows = rows.skip(1).toList();
    } else {
      headers =
          columnNames ?? List.generate(rows.first.length, (i) => 'Column_$i');
      dataRows = rows;
    }

    // Apply skiprows
    if (skiprows > 0) {
      dataRows = dataRows.skip(skiprows).toList();
    }

    // Apply nrows limit
    if (nrows != null && nrows < dataRows.length) {
      dataRows = dataRows.take(nrows).toList();
    }

    if (dataRows.isEmpty) {
      return DataFrame.empty();
    }

    // Convert data and apply type casting
    final data = <String, List<dynamic>>{};
    for (var colIndex = 0; colIndex < headers.length; colIndex++) {
      final columnName = headers[colIndex];
      final columnData = <dynamic>[];

      for (final row in dataRows) {
        dynamic value = colIndex < row.length ? row[colIndex] : null;

        // Try to parse numbers if not specified as string
        if (value is String && value.isNotEmpty) {
          if (dtypes?[columnName] == String) {
            // Keep as string
          } else if (dtypes?[columnName] == int) {
            value = int.tryParse(value) ?? value;
          } else if (dtypes?[columnName] == double) {
            value = double.tryParse(value) ?? value;
          } else if (dtypes?[columnName] == bool) {
            value = _parseBool(value) ?? value;
          } else {
            // Auto-detect type
            value = _autoParseValue(value);
          }
        }

        columnData.add(value);
      }

      data[columnName] = columnData;
    }

    return DataFrame(data);
  }

  /// Reads a JSON file and returns a DataFrame.
  static Future<DataFrame> readJson(
    String filePath, {
    String orient = 'records',
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found: $filePath');
    }

    final content = await file.readAsString();
    final jsonData = json.decode(content);

    switch (orient.toLowerCase()) {
      case 'records':
        if (jsonData is! List) {
          throw FormatException('Expected JSON array for orient="records"');
        }
        final records = jsonData.cast<Map<String, dynamic>>();
        return DataFrame.fromRecords(records);

      case 'columns':
        if (jsonData is! Map) {
          throw FormatException('Expected JSON object for orient="columns"');
        }
        final data = <String, List<dynamic>>{};
        for (final entry in jsonData.entries) {
          if (entry.value is! List) {
            throw FormatException('Column values must be arrays');
          }
          data[entry.key] = List<dynamic>.from(entry.value);
        }
        return DataFrame(data);

      case 'index':
        if (jsonData is! Map) {
          throw FormatException('Expected JSON object for orient="index"');
        }
        final records = <Map<String, dynamic>>[];
        final indices = <String>[];

        for (final entry in jsonData.entries) {
          indices.add(entry.key);
          if (entry.value is! Map) {
            throw FormatException('Row values must be objects');
          }
          records.add(Map<String, dynamic>.from(entry.value));
        }

        return DataFrame.fromRecords(records, index: indices);

      default:
        throw ArgumentError('Unsupported orient: $orient');
    }
  }

  /// Writes a DataFrame to a CSV file.
  static Future<void> toCsv(
    DataFrame df,
    String filePath, {
    String separator = ',',
    bool writeHeader = true,
    bool writeIndex = false,
  }) async {
    final file = File(filePath);
    final sink = file.openWrite();

    try {
      final converter = ListToCsvConverter(fieldDelimiter: separator);

      // Collect all rows first
      final allRows = <List<dynamic>>[];

      // Add header
      if (writeHeader) {
        final headers = <String>[];
        if (writeIndex) headers.add('Index');
        headers.addAll(df.columns);
        allRows.add(headers);
      }

      // Add data rows
      for (var i = 0; i < df.length; i++) {
        final row = <dynamic>[];
        if (writeIndex) row.add(df.index[i]);

        for (final column in df.columns) {
          row.add(df[column][i]);
        }

        allRows.add(row);
      }

      // Convert all rows at once
      sink.write(converter.convert(allRows));
    } finally {
      await sink.close();
    }
  }

  /// Writes a DataFrame to a JSON file.
  static Future<void> toJson(
    DataFrame df,
    String filePath, {
    String orient = 'records',
    bool writeIndex = false,
  }) async {
    final file = File(filePath);
    dynamic jsonData;

    switch (orient.toLowerCase()) {
      case 'records':
        jsonData = df.toRecords();
        if (writeIndex) {
          for (var i = 0; i < jsonData.length; i++) {
            jsonData[i]['_index'] = df.index[i];
          }
        }
        break;

      case 'columns':
        jsonData = <String, List<dynamic>>{};
        for (final column in df.columns) {
          jsonData[column] = df[column].data;
        }
        if (writeIndex) {
          jsonData['_index'] = df.index;
        }
        break;

      case 'index':
        jsonData = <String, Map<String, dynamic>>{};
        for (var i = 0; i < df.length; i++) {
          final row = <String, dynamic>{};
          for (final column in df.columns) {
            row[column] = df[column][i];
          }
          jsonData[df.index[i]] = row;
        }
        break;

      default:
        throw ArgumentError('Unsupported orient: $orient');
    }

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(jsonData),
    );
  }

  /// Reads data from a URL (HTTP/HTTPS).
  static Future<DataFrame> readUrl(
    String url, {
    String format = 'csv',
    Map<String, dynamic>? options,
  }) async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(url);
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw HttpException(
          'HTTP ${response.statusCode}: Failed to fetch $url',
        );
      }

      final content = await response.transform(utf8.decoder).join();

      // Write to temporary file and use existing read methods
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/temp_data_${DateTime.now().millisecondsSinceEpoch}.$format',
      );

      try {
        await tempFile.writeAsString(content);

        switch (format.toLowerCase()) {
          case 'csv':
            return await readCsv(
              tempFile.path,
              separator: options?['separator'] ?? ',',
              hasHeader: options?['hasHeader'] ?? true,
              columnNames: options?['columnNames'],
              dtypes: options?['dtypes'],
              nrows: options?['nrows'],
              skiprows: options?['skiprows'] ?? 0,
            );
          case 'json':
            return await readJson(
              tempFile.path,
              orient: options?['orient'] ?? 'records',
            );
          default:
            throw ArgumentError('Unsupported format: $format');
        }
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    } finally {
      client.close();
    }
  }

  /// Creates a DataFrame from database query results.
  static DataFrame fromQueryResult(
    List<Map<String, dynamic>> queryResult, {
    List<String>? index,
  }) {
    return DataFrame.fromRecords(queryResult, index: index);
  }

  /// Exports DataFrame to various formats based on file extension.
  static Future<void> export(
    DataFrame df,
    String filePath, {
    Map<String, dynamic>? options,
  }) async {
    final extension = filePath.toLowerCase().split('.').last;

    switch (extension) {
      case 'csv':
        await toCsv(
          df,
          filePath,
          separator: options?['separator'] ?? ',',
          writeHeader: options?['writeHeader'] ?? true,
          writeIndex: options?['writeIndex'] ?? false,
        );
        break;
      case 'json':
        await toJson(
          df,
          filePath,
          orient: options?['orient'] ?? 'records',
          writeIndex: options?['writeIndex'] ?? false,
        );
        break;
      default:
        throw ArgumentError('Unsupported file format: .$extension');
    }
  }

  /// Auto-detects the best data type for a string value.
  static dynamic _autoParseValue(String value) {
    if (value.isEmpty) return null;

    // Try boolean first
    final boolValue = _parseBool(value);
    if (boolValue != null) return boolValue;

    // Try integer
    final intValue = int.tryParse(value);
    if (intValue != null) return intValue;

    // Try double
    final doubleValue = double.tryParse(value);
    if (doubleValue != null) return doubleValue;

    // Return as string
    return value;
  }

  /// Parses boolean values from strings.
  static bool? _parseBool(String value) {
    final lower = value.toLowerCase().trim();
    switch (lower) {
      case 'true':
      case 't':
      case 'yes':
      case 'y':
      case '1':
        return true;
      case 'false':
      case 'f':
      case 'no':
      case 'n':
      case '0':
        return false;
      default:
        return null;
    }
  }
}

/// Utility functions for creating sample data.
class DataUtils {
  /// Creates a DataFrame with sample numeric data.
  static DataFrame createSampleNumeric({
    int rows = 100,
    int columns = 5,
    int? seed,
  }) {
    final random = seed != null ? math.Random(seed) : math.Random();
    final data = <String, List<dynamic>>{};

    for (var i = 0; i < columns; i++) {
      final columnName = 'column_$i';
      final values = List.generate(rows, (index) => random.nextDouble() * 100);
      data[columnName] = values;
    }

    return DataFrame(data);
  }

  /// Creates a DataFrame with sample mixed data types.
  static DataFrame createSampleMixed({int rows = 100, int? seed}) {
    final random = seed != null ? math.Random(seed) : math.Random();
    final names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve'];
    final categories = ['A', 'B', 'C'];

    return DataFrame({
      'id': List.generate(rows, (i) => i + 1),
      'name': List.generate(rows, (i) => names[random.nextInt(names.length)]),
      'age': List.generate(rows, (i) => 20 + random.nextInt(50)),
      'salary': List.generate(rows, (i) => 30000 + random.nextDouble() * 70000),
      'category': List.generate(
        rows,
        (i) => categories[random.nextInt(categories.length)],
      ),
      'active': List.generate(rows, (i) => random.nextBool()),
    });
  }

  /// Creates a time series DataFrame.
  static DataFrame createTimeSeries({
    DateTime? start,
    int days = 30,
    String freq = 'D',
    int? seed,
  }) {
    start ??= DateTime.now().subtract(Duration(days: days));
    final random = seed != null ? math.Random(seed) : math.Random();

    final dates = <String>[];
    final values = <double>[];

    var current = start;
    for (var i = 0; i < days; i++) {
      dates.add(current.toIso8601String().split('T')[0]);
      values.add(100 + random.nextDouble() * 50 - 25); // Random walk around 100
      current = current.add(const Duration(days: 1));
    }

    return DataFrame({'date': dates, 'value': values});
  }
}
