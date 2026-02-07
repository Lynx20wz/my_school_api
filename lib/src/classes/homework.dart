class Homework {
  final String subject;
  final String description;
  final List<String> links;

  Homework(this.subject, this.description, this.links);
  Homework.fromJson(Map<String, dynamic> json)
    : subject = json['subject_name'],
      description = json['description'],
      links = List<String>.from(json['attachments']);

  @override
  String toString() {
    return '$subject: $description\nLinks:${links.join('\n')}';
  }
}
