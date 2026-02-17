import 'package:intl/intl.dart' show DateFormat;

/// Formats [DateTime] as yyyy-MM-dd string for JSON serialization.
String dateTimeToJson(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

/// Parses yyyy-MM-dd date string to [DateTime].
DateTime dateTimeFromJson(String date) => DateTime.parse(date);

/// Base class for school-related objects.
///
/// Common fields for [Homework] and [Mark]:
/// - [id]: Unique identifier
/// - [date]: Associated date
/// - [subjectName]: Subject name
abstract class SchoolObject {
  /// Unique identifier.
  final int id;

  /// Associated date.
  final DateTime date;

  /// Subject name (e.g., 'Математика', 'Русский язык').
  final String subjectName;

  /// Creates [SchoolObject].
  const SchoolObject({
    required this.id,
    required this.date,
    required this.subjectName,
  });
}
