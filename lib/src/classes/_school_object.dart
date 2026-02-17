/// Base abstract class for school-related objects.
///
/// Provides common fields shared by [Homework] and [Mark]:
/// - [id]: Unique identifier
/// - [date]: Date associated with the object
/// - [subjectName]: Name of the school subject
abstract class SchoolObject {
  /// Unique identifier for this object.
  final int id;

  /// The date associated with this school object.
  final DateTime date;

  /// The name of the subject.
  ///
  /// Examples: 'Математика', 'Русский язык', 'Физика'.
  final String subjectName;

  /// Creates a [SchoolObject].
  ///
  /// [id] must be a unique identifier.
  /// [date] is the associated date.
  /// [subjectName] is the name of the subject.
  const SchoolObject({
    required this.id,
    required this.date,
    required this.subjectName,
  });
}
