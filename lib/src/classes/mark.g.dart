// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mark _$MarkFromJson(Map<String, dynamic> json) => Mark(
  id: (json['id'] as num).toInt(),
  date: _dateTimeFromJson(json['date'] as String),
  subjectName: json['subject_name'] as String,
  value: _parseStringToInt(json['value']),
);

Map<String, dynamic> _$MarkToJson(Mark instance) => <String, dynamic>{
  'id': instance.id,
  'date': _dateTimeToIso8601String(instance.date),
  'subject_name': instance.subjectName,
  'value': instance.value,
};
