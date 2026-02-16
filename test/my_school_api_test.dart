import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('homework class tests', () {
    test('fromMap', () {
      final homework = Homework.fromMap({
        'homework': 'выучить записи в тетради',
        'attachments': [],
        'materials': [],
        'date': '2026-02-16',
        'subject_name': 'Химия',
        'is_done': false,
      });

      expect(homework.date, DateTime(2026, 2, 16));
      expect(homework.subjectName, 'Химия');
      expect(homework.description, 'выучить записи в тетради');
      expect(homework.isDone, false);
      expect(homework.attachments.isEmpty, true);
    });
  });
}
