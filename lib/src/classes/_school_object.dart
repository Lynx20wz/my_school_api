import 'package:intl/intl.dart' show DateFormat;
import 'package:json_annotation/json_annotation.dart' show JsonKey;

/// Formats [DateTime] as yyyy-MM-dd string for JSON serialization.
String dateTimeToJson(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

/// Parses yyyy-MM-dd date string to [DateTime].
DateTime dateTimeFromJson(String date) => DateTime.parse(date);

/// Abstract interface for school-related objects.
///
/// Common fields for [Homework] and [Mark]:
/// - [id]: Unique identifier
/// - [date]: Associated date
/// - [subjectName]: Subject name
abstract class SchoolObject {
  final int id;

  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime date;

  @JsonKey(name: 'subject_name')
  final String subjectName;

  const SchoolObject({
    required this.id,
    required this.date,
    required this.subjectName,
  });
}
