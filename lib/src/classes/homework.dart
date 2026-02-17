import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';

part 'homework.g.dart';

/// Represents a homework assignment for a specific subject.
///
/// Homework assignments include a description, optional attachments,
/// and a completion status. They are associated with a specific date
/// and subject.
@JsonSerializable(fieldRename: FieldRename.snake)
class Homework {
  /// Unique identifier for this homework assignment.
  @JsonKey(name: 'homework_id')
  final int id;

  /// The date when the homework was assigned.
  final DateTime date;

  /// The name of the subject for which the homework was assigned.
  ///
  /// Examples: 'Математика', 'Русский язык', 'Химия'.
  final String subjectName;

  /// The text description of the homework assignment.
  ///
  /// Contains the actual task description, e.g., "выучить записи в тетради".
  @JsonKey(name: 'homework')
  final String description;

  /// List of attachments associated with this homework.
  ///
  /// Attachments may include files, links, or digital homework materials (ЦДЗ).
  @JsonKey(name: 'materials', fromJson: _getAttachments)
  final List<Attachment> attachments;

  /// Whether the homework has been marked as completed.
  ///
  /// Defaults to `false` when the homework is created.
  @JsonKey(defaultValue: false)
  final bool isDone;

  /// Creates a [Homework] instance.
  ///
  /// [id] must be a unique identifier.
  /// [date] is the date when the homework was assigned.
  /// [subjectName] is the name of the subject.
  /// [description] is the homework task text.
  /// [attachments] is a list of file attachments (defaults to empty list).
  /// [isDone] indicates completion status (defaults to false).
  Homework({
    required this.id,
    required this.date,
    required this.subjectName,
    required this.description,
    required this.attachments,
    this.isDone = false,
  });

  /// Creates a [Homework] from a JSON-encoded string.
  ///
  /// Example:
  /// ```dart
  /// final homework = Homework.fromJson('''
  ///   {
  ///     "homework_id": 123,
  ///     "homework": "выучить записи в тетради",
  ///     "materials": [],
  ///     "date": "2026-02-16",
  ///     "subject_name": "Химия",
  ///     "is_done": false
  ///   }
  /// ''');
  /// ```
  factory Homework.fromJson(String source) =>
      _$HomeworkFromJson(jsonDecode(source));

  /// Creates a [Homework] from a [Map].
  ///
  /// The map should contain:
  /// - `homework_id`: Unique identifier (required)
  /// - `homework`: Homework description text (required)
  /// - `materials`: List of attachment objects (required, may be empty)
  /// - `date`: Date in ISO 8601 format (required)
  /// - `subject_name`: Subject name (required)
  /// - `is_done`: Completion status (optional, defaults to false)
  ///
  /// Example:
  /// ```dart
  /// final homework = Homework.fromMap({
  ///   'homework_id': 123,
  ///   'homework': 'выучить записи в тетради',
  ///   'materials': [],
  ///   'date': '2026-02-16',
  ///   'subject_name': 'Химия',
  ///   'is_done': false,
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

  /// Creates a copy of this [Homework] with specified fields replaced.
  ///
  /// Example:
  /// ```dart
  /// final updatedHomework = homework.copyWith(isDone: true);
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

  /// Converts this [Homework] to a JSON-encoded string.
  String toJson() => jsonEncode(toMap());

  /// Converts this [Homework] to a [Map].
  ///
  /// Returns a map with the following keys:
  /// - `homework_id`: Unique identifier
  /// - `date`: Assignment date in ISO 8601 format
  /// - `subject_name`: Subject name
  /// - `description`: Homework description
  /// - `materials`: List of attachment maps
  /// - `is_done`: Completion status
  Map<String, dynamic> toMap() => _$HomeworkToJson(this);

  @override
  String toString() =>
      'Homework(id: $id, date: $date, subjectName: $subjectName, description: $description, isDone: $isDone)';
}

/// Parses a list of attachments from the API response materials.
///
/// [materials] is a list of maps from the API response.
/// Returns an empty list if [materials] is empty or null.
List<Attachment> _getAttachments(List<dynamic>? materials) {
  if (materials == null || materials.isEmpty) return [];
  return materials.map((map) => Attachment.fromMap(map)).toList();
}
