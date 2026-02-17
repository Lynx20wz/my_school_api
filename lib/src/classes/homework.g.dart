// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Homework _$HomeworkFromJson(Map<String, dynamic> json) => Homework(
  date: DateTime.parse(json['date'] as String),
  subjectName: json['subject_name'] as String,
  id: (json['homework_id'] as num).toInt(),
  description: json['homework'] as String,
  attachments: _getAttachments(json['materials'] as List?),
  isDone: json['is_done'] as bool? ?? false,
);

Map<String, dynamic> _$HomeworkToJson(Homework instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'subject_name': instance.subjectName,
  'homework_id': instance.id,
  'homework': instance.description,
  'materials': instance.attachments,
  'is_done': instance.isDone,
};
