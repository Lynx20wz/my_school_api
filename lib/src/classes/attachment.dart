import 'dart:convert' show jsonDecode, jsonEncode;

/// Represents an attachment associated with a homework or mark.
///
/// Attachments are files or resources, for example: "ЦДЗ (Цифровое Домашнее Задание)", that can be attached to homework.
class Attachment {
  final String url;
  final String title;

  const Attachment({required this.url, required this.title});

  factory Attachment.fromJson(String source) =>
      Attachment.fromMap(jsonDecode(source));

  Attachment.fromMap(Map<String, dynamic> map)
    : url = map['url'] ?? '',
      title = map['title'];

  @override
  int get hashCode => Object.hash(url, title);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          title == other.title;

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {'url': url, 'title': title};
}
