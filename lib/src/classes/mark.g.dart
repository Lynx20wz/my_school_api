// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mark _$MarkFromJson(Map<String, dynamic> json) => Mark(
  id: (json['id'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  subjectName: json['subject_name'] as String,
  value: _parseStringToInt(json['value']),
);

Map<String, dynamic> _$MarkToJson(Mark instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'subject_name': instance.subjectName,
  'value': instance.value,
};
