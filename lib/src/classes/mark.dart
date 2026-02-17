import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';
import 'package:my_school_api/my_school_api.dart'
    show InvalidMarkValueException;

import '_school_object.dart';

part 'mark.g.dart';

/// Represents a student's academic mark (grade) for a subject.
///
/// Valid mark values: 2, 3, 4, 5 (Russian school system).
@JsonSerializable(fieldRename: FieldRename.snake)
class Mark extends SchoolObject {
  /// Valid mark values.
  static const validValues = {2, 3, 4, 5};

  /// Mark value (2-5).
  ///
  /// - 5: Excellent (отлично)
  /// - 4: Good (хорошо)
  /// - 3: Satisfactory (удовлетворительно)
  /// - 2: Unsatisfactory (неудовлетворительно)
  @JsonKey(fromJson: _parseStringToInt)
  final int value;

  /// Creates [Mark].
  ///
  /// Throws [ArgumentError] if [value] is not in [validValues].
  Mark({
    required super.id,
    required super.date,
    required super.subjectName,
    required this.value,
  }) : assert(
         validValues.contains(value),
         'Invalid mark value: $value. Valid values are: ${validValues.join(', ')}',
       );

  /// Creates [Mark] from JSON string.
  ///
  /// Example:
  /// ```dart
  /// final mark = Mark.fromJson('{"id": 123, "value": "5", "date": "2026-02-16", "subject_name": "Математика"}');
  /// ```
  factory Mark.fromJson(String source) => _$MarkFromJson(jsonDecode(source));

  /// Creates [Mark] from [Map].
  ///
  /// Map must contain: `id`, `value`, `date`, `subject_name`.
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

  /// Creates a copy with specified fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final updated = mark.copyWith(value: 5);
  /// ```
  Mark copyWith({int? id, DateTime? date, String? subjectName, int? value}) =>
      Mark(
        id: id ?? this.id,
        date: date ?? this.date,
        subjectName: subjectName ?? this.subjectName,
        value: value ?? this.value,
      );

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() => _$MarkToJson(this);

  @override
  String toString() =>
      'Mark(id: $id, date: $date, subjectName: $subjectName, value: $value)';
}

/// Parses mark value from API response and validates it.
///
/// Throws [InvalidMarkValueException] if value is not in [Mark.validValues].
int _parseStringToInt(dynamic value) {
  final intValue = switch (value) {
    final int i => i,
    final String s => int.parse(s),
    _ => throw ArgumentError('Cannot convert $value to int'),
  };

  if (!Mark.validValues.contains(intValue)) {
    throw InvalidMarkValueException(
      'Invalid mark value: $intValue. Valid values are: ${Mark.validValues.join(', ')}',
      mark: intValue,
    );
  }

  return intValue;
}
