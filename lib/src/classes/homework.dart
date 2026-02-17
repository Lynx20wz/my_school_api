import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';

import '_school_object.dart';
import 'attachment.dart';
part 'homework.g.dart';

/// Represents a homework assignment for a specific subject.
///
/// Includes description, optional attachments, and completion status.
@JsonSerializable(fieldRename: FieldRename.snake)
class Homework extends SchoolObject {
  @JsonKey(name: 'homework_id')
  @override
  final int id;

  /// Homework description text.
  @JsonKey(name: 'homework')
  final String description;

  /// List of attachments (files, links, ЦДЗ).
  @JsonKey(name: 'materials', fromJson: _getAttachments)
  final List<Attachment> attachments;

  /// Whether the homework is marked as completed.
  @JsonKey(defaultValue: false)
  final bool isDone;

  /// Creates [Homework].
  Homework({
    required super.date,
    required super.subjectName,
    required this.id,
    required this.description,
    required this.attachments,
    this.isDone = false,
  }) : super(id: id);

  /// Creates [Homework] from JSON string.
  ///
  /// Example:
  /// ```dart
  /// final homework = Homework.fromJson('{"homework_id": 123, "homework": "..."}');
  /// ```
  factory Homework.fromJson(String source) =>
      _$HomeworkFromJson(jsonDecode(source));

  /// Creates [Homework] from [Map].
  ///
  /// Map must contain: `homework_id`, `homework`, `materials`, `date`, `subject_name`.
  ///
  /// Example:
  /// ```dart
  /// final homework = Homework.fromMap({
  ///   'homework_id': 123,
  ///   'homework': 'выучить записи',
  ///   'materials': [],
  ///   'date': '2026-02-16',
  ///   'subject_name': 'Химия',
  /// });
  /// ```
  factory Homework.fromMap(Map<String, dynamic> map) => _$HomeworkFromJson(map);

  @override
  int get hashCode => Object.hash(
    id,
    date,
    subjectName,
    description,
    Object.hashAll(attachments),
    isDone,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Homework &&
          id == other.id &&
          date == other.date &&
          subjectName == other.subjectName &&
          description == other.description &&
          attachments.length == other.attachments.length &&
          attachments.every((e) => other.attachments.contains(e)) &&
          isDone == other.isDone;

  /// Creates a copy with specified fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final updated = homework.copyWith(isDone: true);
  /// ```
  Homework copyWith({
    int? id,
    DateTime? date,
    String? subjectName,
    String? description,
    List<Attachment>? attachments,
    bool? isDone,
  }) => Homework(
    id: id ?? this.id,
    date: date ?? this.date,
    subjectName: subjectName ?? this.subjectName,
    description: description ?? this.description,
    attachments: attachments ?? this.attachments,
    isDone: isDone ?? this.isDone,
  );

  @override
  String toString() =>
      'Homework(id: $id, date: $date, subjectName: $subjectName, description: $description, isDone: $isDone)';

  /// Converts [Homework] to JSON string.
  String toJson() => jsonEncode(toMap());

  /// Converts [Homework] to [Map].
  Map<String, dynamic> toMap() => _$HomeworkToJson(this);
}

/// Parses attachments from API response.
///
/// Returns empty list if [materials] is null or empty.
List<Attachment> _getAttachments(List<dynamic>? materials) {
  if (materials == null || materials.isEmpty) return [];
  return materials.map((map) => Attachment.fromMap(map)).toList();
}
