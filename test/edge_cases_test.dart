import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('Edge cases', () {
    group('Homework edge cases', () {
      test('handles empty description', () {
        final homework = Homework.fromMap({
          'homework_id': 1,
          'homework': '',
          'materials': [],
          'date': '2026-02-16',
          'subject_name': 'Математика',
          'is_done': false,
        });

        expect(homework.description, isEmpty);
      });

      test('handles very long description', () {
        final longDescription = 'а' * 10000;
        final homework = Homework.fromMap({
          'homework_id': 1,
          'homework': longDescription,
          'materials': [],
          'date': '2026-02-16',
          'subject_name': 'Математика',
          'is_done': false,
        });

        expect(homework.description.length, 10000);
      });

      test('handles special characters in description', () {
        final homework = Homework.fromMap({
          'homework_id': 1,
          'homework': r"Специальные символы: !@#$%^&*()_+-=[]{}|;:',.<>?/\`~",
          'materials': [],
          'date': '2026-02-16',
          'subject_name': 'Математика',
          'is_done': false,
        });

        expect(homework.description.length, 52);
      });

      test('handles null is_done as false', () {
        final homework = Homework.fromMap({
          'homework_id': 1,
          'homework': 'задание',
          'materials': [],
          'date': '2026-02-16',
          'subject_name': 'Математика',
          'is_done': null,
        });

        expect(homework.isDone, false);
      });

      test('handles date with time component', () {
        final homework = Homework.fromMap({
          'homework_id': 1,
          'homework': 'задание',
          'materials': [],
          'date': '2026-02-16T10:30:00',
          'subject_name': 'Математика',
          'is_done': false,
        });

        expect(homework.date.year, 2026);
        expect(homework.date.month, 2);
        expect(homework.date.day, 16);
      });
    });

    test('handles date with timezone', () {
      final mark = Mark.fromMap({
        'id': 1,
        'value': '5',
        'date': '2026-02-16T12:00:00+03:00',
        'subject_name': 'Математика',
      });

      expect(mark.date.year, 2026);
      expect(mark.date.month, 2);
      expect(mark.date.day, 16);
    });
  });

  group('Mark edge cases', () {
    test('handles grade value (2)', () {
      final mark = Mark.fromMap({
        'id': 1,
        'value': '2',
        'date': '2026-02-16',
        'subject_name': 'Математика',
      });

      expect(mark.value, 2);
    });

    test('throws InvalidMarkValueException for value 1', () {
      expect(
        () => Mark.fromMap({
          'id': 1,
          'value': '1',
          'date': '2026-02-16',
          'subject_name': 'Математика',
        }),
        throwsA(isA<InvalidMarkValueException>()),
      );
    });

    test('throws InvalidMarkValueException for value 6', () {
      expect(
        () => Mark.fromMap({
          'id': 1,
          'value': '6',
          'date': '2026-02-16',
          'subject_name': 'Математика',
        }),
        throwsA(isA<InvalidMarkValueException>()),
      );
    });

    test('handles special characters in subject name', () {
      final mark = Mark.fromMap({
        'id': 1,
        'value': '5',
        'date': '2026-02-16',
        'subject_name': 'Основы религиозных культур и светской этики',
      });

      expect(mark.subjectName, 'Основы религиозных культур и светской этики');
    });

    group('Attachment edge cases', () {
      test('handles empty title', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/file.pdf',
          'title': '',
        });

        expect(attachment.title, isEmpty);
        expect(attachment.url, isNotEmpty);
      });

      test('handles URL with query parameters', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/file.pdf?token=abc123&expires=1234567890',
          'title': 'Файл',
        });

        expect(
          attachment.url,
          'https://example.com/file.pdf?token=abc123&expires=1234567890',
        );
      });

      test('handles URL with special characters', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/файл%20с%20пробелами.pdf',
          'title': 'Файл',
        });

        expect(attachment.url, contains('%20'));
      });

      test('handles very long URL', () {
        final longUrl = 'https://example.com/${'a' * 1000}/file.pdf';
        final attachment = Attachment.fromMap({
          'url': longUrl,
          'title': 'Файл',
        });

        expect(attachment.url!.length, greaterThan(1000));
      });
    });

    group('Serialization edge cases', () {
      test('Homework round-trip preserves all fields', () {
        final original = Homework(
          id: 999,
          date: DateTime(2026, 12, 31),
          subjectName: 'Предмет с эмодзи 📚',
          description: 'Задание с эмодзи ✏️📝',
          attachments: [],
          isDone: true,
        );

        final json = original.toJson();
        final restored = Homework.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.date, original.date);
        expect(restored.subjectName, original.subjectName);
        expect(restored.description, original.description);
        expect(restored.isDone, original.isDone);
        expect(restored.attachments.length, original.attachments.length);
      });

      test('Mark round-trip preserves all fields', () {
        final original = Mark(
          id: 888,
          date: DateTime(2026, 6, 15),
          subjectName: 'Математика',
          value: 5,
        );

        final json = original.toJson();
        final restored = Mark.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.date, original.date);
        expect(restored.subjectName, original.subjectName);
        expect(restored.value, original.value);
      });

      test('Attachment round-trip preserves all fields', () {
        final original = const Attachment(
          url: 'https://example.com/путь/к/файлу.pdf?парам=значение',
          title: 'Название с эмодзи 📎',
        );

        final json = original.toJson();
        final restored = Attachment.fromJson(json);

        expect(restored.url, original.url);
        expect(restored.title, original.title);
      });
    });

    group('hashCode consistency', () {
      test('same hashCode for equal Homework objects', () {
        final h1 = Homework(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          description: 'Задание',
          attachments: [],
        );
        final h2 = Homework(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          description: 'Задание',
          attachments: [],
        );

        expect(h1.hashCode, equals(h2.hashCode));
      });

      test('same hashCode for equal Mark objects', () {
        final m1 = Mark(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          value: 5,
        );
        final m2 = Mark(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          value: 5,
        );

        expect(m1.hashCode, equals(m2.hashCode));
      });

      test('same hashCode for equal Attachment objects', () {
        final a1 = const Attachment(
          url: 'https://example.com/f.pdf',
          title: 'Файл',
        );
        final a2 = const Attachment(
          url: 'https://example.com/f.pdf',
          title: 'Файл',
        );

        expect(a1.hashCode, equals(a2.hashCode));
      });
    });

    group('copyWith null safety', () {
      test('Homework.copyWith with null values uses original', () {
        final original = Homework(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          description: 'Задание',
          attachments: [],
          isDone: false,
        );

        final copy = original.copyWith(id: 2, date: null, subjectName: null);

        expect(copy.id, 2);
        expect(copy.date, original.date);
        expect(copy.subjectName, original.subjectName);
      });

      test('Mark.copyWith with null values uses original', () {
        final original = Mark(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          value: 5,
        );

        final copy = original.copyWith(id: 2, date: null, subjectName: null);

        expect(copy.id, 2);
        expect(copy.date, original.date);
        expect(copy.subjectName, original.subjectName);
      });
    });
  });
}
