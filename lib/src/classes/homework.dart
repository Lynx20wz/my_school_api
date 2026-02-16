import 'dart:convert' show jsonDecode, jsonEncode;

import '_school_object.dart';
import 'attachment.dart';

/// Represents a homework assignment.
class Homework extends SchoolObject {
  /// The text of the homework assignment.
  final String description;
  final List<Attachment> attachments;

  /// Whether the homework has been marked as done.
  bool isDone;

  Homework({
    required super.id,
    required super.date,
    required super.subjectName,
    required this.description,
    required this.attachments,
    this.isDone = false,
  });

  /// Creates a new [Homework] instance from a JSON string.
  ///
  /// Example JSON:
  /// {
  ///   "homework": "выучить записи в тетради",
  ///   "attachments": [],
  ///   "date": "2026-02-16",
  ///   "subject_name": "Химия",
  ///   "is_done": true,
  /// }
  factory Homework.fromJson(String source) =>
      Homework.fromMap(jsonDecode(source));

  /// Creates a new [Homework] instance from a [Map].
  ///
  /// Example [Map]:
  /// {
  ///   "homework": "выучить записи в тетради",
  ///   "attachments": [],
  ///   "date": "2026-02-16",
  ///   "subject_name": "Химия",
  ///   "is_done": true,
  /// }
  Homework.fromMap(Map<String, dynamic> map)
    : description = map['homework'],
      attachments = _getAttachments(map['materials']),
      isDone = map['is_done'] ?? false,
      super(
        id: map['homework_id'],
        date: DateTime.parse(map['date']),
        subjectName: map['subject_name'],
      );

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
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          subjectName == other.subjectName &&
          description == other.description &&
          attachments.length == other.attachments.length &&
          attachments.every((e) => other.attachments.contains(e)) &&
          isDone == other.isDone;

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

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
    'homework_id': id,
    'date': date.toIso8601String(),
    'subject_name': subjectName,
    'description': description,
    'attachments': attachments,
    'is_done': isDone,
  };

  @override
  String toString() =>
      'Homework(id: $id, date: $date, subjectName: $subjectName, description: $description, isDone: $isDone)';

  static List<Attachment> _getAttachments(List<dynamic> materials) {
    if (materials.isEmpty) return [];
    return materials.map((map) => Attachment.fromMap(map)).toList();
  }
}
