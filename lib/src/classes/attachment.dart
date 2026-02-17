import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

/// Represents an attachment associated with a homework assignment.
///
/// Attachments are files or resources (e.g., "ЦДЗ (Цифровое Домашнее Задание)").
@JsonSerializable(fieldRename: FieldRename.snake)
class Attachment {
  final String url;
  final String title;

  const Attachment({required this.url, required this.title});

  /// Creates [Attachment] from JSON string.
  ///
  /// Example:
  /// ```dart
  /// final attachment = Attachment.fromJson('{"url": "https://...", "title": "Homework"}');
  /// ```
  factory Attachment.fromJson(String source) =>
      _$AttachmentFromJson(jsonDecode(source));

  /// Creates [Attachment] from [Map].
  ///
  /// Map must contain: `url`, `title`.
  factory Attachment.fromMap(Map<String, dynamic> map) =>
      _$AttachmentFromJson(map);

  @override
  int get hashCode => Object.hash(url, title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment && url == other.url && title == other.title;

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() => _$AttachmentToJson(this);

  @override
  String toString() => 'Attachment(url: $url, title: $title)';
}
