import 'dart:convert' show jsonDecode, jsonEncode;

import '_school_object.dart';

class Mark extends SchoolObject {
  /// The value of the mark.
  final int value;

  const Mark({
    required super.id,
    required super.date,
    required super.subjectName,
    required this.value,
  });

  factory Mark.fromJson(String source) => Mark.fromMap(jsonDecode(source));

  Mark.fromMap(Map<String, dynamic> map)
    : value = int.parse(map['value']),
      super(
        id: map['id'],
        date: DateTime.parse(map['date']),
        subjectName: map['subject_name'],
      );

  @override
  int get hashCode => Object.hash(id, date, subjectName, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mark &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          subjectName == other.subjectName &&
          other.value == value;

  Mark copyWith({int? id, DateTime? date, String? subjectName, int? value}) =>
      Mark(
        id: id ?? this.id,
        date: date ?? this.date,
        subjectName: subjectName ?? this.subjectName,
        value: value ?? this.value,
      );

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'subject_name': subjectName,
    'value': value,
  };

  @override
  String toString() =>
      'Mark(id: $id, date: $date, subjectName: $subjectName, value: $value)';
}
