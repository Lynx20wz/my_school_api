import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';

part 'mark.g.dart';

/// Represents a student's academic mark (grade) for a subject.
///
/// Marks are numerical values (typically 2-5 in the Russian school system)
/// assigned to students for their performance in a specific subject on a given date.
///
/// Valid mark values are: 2, 3, 4, 5.
@JsonSerializable(fieldRename: FieldRename.snake)
class Mark {
  /// Valid mark values in the Russian school system.
  static const validValues = {2, 3, 4, 5};

  /// Unique identifier for this mark.
  final int id;

  /// The date when the mark was assigned.
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToIso8601String)
  final DateTime date;

  /// The name of the subject for which the mark was given.
  ///
  /// Examples: 'Математика', 'Русский язык', 'Физика'.
  final String subjectName;

  /// The numerical value of the mark.
  ///
  /// In the Russian school system, valid values are:
  /// - 5: Excellent (отлично)
  /// - 4: Good (хорошо)
  /// - 3: Satisfactory (удовлетворительно)
  /// - 2: Unsatisfactory (неудовлетворительно)
  ///
  /// Throws [ArgumentError] if value is not in [validValues].
  @JsonKey(fromJson: _parseStringToInt)
  final int value;

  /// Creates a [Mark] instance.
  ///
  /// [id] must be a unique identifier.
  /// [date] is the date when the mark was assigned.
  /// [subjectName] is the name of the subject.
  /// [value] is the numerical mark value (must be 2, 3, 4, or 5).
  ///
  /// Throws [ArgumentError] if [value] is not in [validValues].
  Mark({
    required this.id,
    required this.date,
    required this.subjectName,
    required this.value,
  }) : assert(
         validValues.contains(value),
         'Invalid mark value: $value. Valid values are: ${validValues.join(', ')}',
       );

  /// Creates a [Mark] from a JSON-encoded string.
  ///
  /// Example:
  /// ```dart
  /// final mark = Mark.fromJson('{"id": 123, "value": "5", "date": "2026-02-16", "subject_name": "Математика"}');
  /// ```
  factory Mark.fromJson(String source) => _$MarkFromJson(jsonDecode(source));

  /// Creates a [Mark] from a [Map].
  ///
  /// The map should contain:
  /// - `id`: Unique identifier (required)
  /// - `value`: Mark value as string (required, must be 2, 3, 4, or 5)
  /// - `date`: Date in ISO 8601 format (required)
  /// - `subject_name`: Subject name (required)
  ///
  /// Throws [ArgumentError] if value is not valid (2, 3, 4, or 5).
  factory Mark.fromMap(Map<String, dynamic> map) => _$MarkFromJson(map);

  @override
  int get hashCode => Object.hash(id, date, subjectName, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mark &&
          id == other.id &&
          date == other.date &&
          subjectName == other.subjectName &&
          value == other.value;

  /// Creates a copy of this [Mark] with specified fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final updatedMark = mark.copyWith(value: 5);
  /// ```
  Mark copyWith({int? id, DateTime? date, String? subjectName, int? value}) =>
      Mark(
        id: id ?? this.id,
        date: date ?? this.date,
        subjectName: subjectName ?? this.subjectName,
        value: value ?? this.value,
      );

  /// Converts this [Mark] to a JSON-encoded string.
  String toJson() => jsonEncode(toMap());

  /// Converts this [Mark] to a [Map].
  ///
  /// Returns a map with `id`, `date`, `subject_name`, and `value` keys.
  Map<String, dynamic> toMap() => _$MarkToJson(this);

  @override
  String toString() =>
      'Mark(id: $id, date: $date, subjectName: $subjectName, value: $value)';
}

/// Parses a string to [int] and validates mark value.
///
/// Used by [json_serializable] to handle API values that come as strings.
/// Valid values are: 2, 3, 4, 5.
///
/// Throws [ArgumentError] if value is not valid.
int _parseStringToInt(dynamic value) {
  final intValue = switch (value) {
    int i => i,
    String s => int.parse(s),
    _ => throw ArgumentError('Cannot convert $value to int'),
  };

  if (!Mark.validValues.contains(intValue)) {
    throw ArgumentError(
      'Invalid mark value: $intValue. Valid values are: ${Mark.validValues.join(', ')}',
    );
  }

  return intValue;
}

/// Parses an ISO 8601 date string to [DateTime].
DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

/// Converts [DateTime] to ISO 8601 string.
String _dateTimeToIso8601String(DateTime date) => date.toIso8601String();
