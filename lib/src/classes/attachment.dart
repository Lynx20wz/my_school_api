import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

/// Represents an attachment associated with a homework assignment.
///
/// Attachments are files or resources (e.g., "ЦДЗ (Цифровое Домашнее Задание)")
/// that can be attached to homework assignments.
@JsonSerializable(fieldRename: FieldRename.snake)
class Attachment {
  /// The URL of the attachment.
  final String url;

  /// The title or name of the attachment.
  final String title;

  /// Creates an [Attachment] instance.
  ///
  /// [url] must be a valid URL to the attachment resource.
  /// [title] is the display name of the attachment.
  const Attachment({required this.url, required this.title});

  /// Creates an [Attachment] from a JSON-encoded string.
  ///
  /// Example:
  /// ```dart
  /// final attachment = Attachment.fromJson('{"url": "https://...", "title": "Homework"}');
  /// ```
  factory Attachment.fromJson(String source) =>
      _$AttachmentFromJson(jsonDecode(source));

  /// Creates an [Attachment] from a [Map].
  ///
  /// The map should contain:
  /// - `url`: The URL of the attachment (required)
  /// - `title`: The title of the attachment (required)
  factory Attachment.fromMap(Map<String, dynamic> map) =>
      _$AttachmentFromJson(map);

  @override
  int get hashCode => Object.hash(url, title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment && url == other.url && title == other.title;

  /// Converts this [Attachment] to a JSON-encoded string.
  String toJson() => jsonEncode(toMap());

  /// Converts this [Attachment] to a [Map].
  ///
  /// Returns a map with `url` and `title` keys.
  Map<String, dynamic> toMap() => _$AttachmentToJson(this);

  @override
  String toString() => 'Attachment(url: $url, title: $title)';
}
