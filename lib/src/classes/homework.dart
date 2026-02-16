import 'dart:convert' show jsonDecode, jsonEncode;

import '_school_object.dart';
import 'attachment.dart';

class Homework extends SchoolObject {
  final String description;
  final List<Attachment> attachments;
  bool isDone;

  Homework({
    required super.date,
    required super.subjectName,
    required this.description,
    required this.attachments,
    this.isDone = false,
  });

  factory Homework.fromJson(String source) =>
      Homework.fromMap(jsonDecode(source));

  Homework.fromMap(Map<String, dynamic> map)
    : description = map['homework'],
      attachments = _getAttachments(map['materials']),
      isDone = map['is_done'] ?? false,
      super(
        date: DateTime.parse(map['date']),
        subjectName: map['subject_name'],
      );

  @override
  int get hashCode =>
      Object.hash(date, subjectName, description, Object.hashAll(attachments));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Homework &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          subjectName == other.subjectName &&
          description == other.description &&
          attachments.length == other.attachments.length &&
          attachments.every((e) => other.attachments.contains(e));

  Homework copyWith({
    DateTime? date,
    String? subjectName,
    String? description,
    List<Attachment>? attachments,
  }) => Homework(
    date: date ?? this.date,
    subjectName: subjectName ?? this.subjectName,
    description: description ?? this.description,
    attachments: attachments ?? this.attachments,
  );

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'subject_name': subjectName,
    'description': description,
    'attachments': attachments,
  };

  @override
  String toString() =>
      'Homework(date: $date, subjectName: $subjectName, description: $description)';

  static List<Attachment> _getAttachments(List<dynamic> materials) {
    if (materials.isEmpty) return [];
    return materials.map((map) => Attachment.fromMap(map)).toList();
  }
}
