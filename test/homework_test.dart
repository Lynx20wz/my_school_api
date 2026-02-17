import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('Homework', () {
    group('fromMap', () {
      test('creates Homework from valid map', () {
        final homework = Homework.fromMap({
          'homework_id': 12345,
          'homework': 'выучить записи в тетради',
          'materials': [],
          'date': '2026-02-16',
          'subject_name': 'Химия',
          'is_done': false,
        });

        expect(homework.id, 12345);
        expect(homework.date, DateTime(2026, 2, 16));
        expect(homework.subjectName, 'Химия');
        expect(homework.description, 'выучить записи в тетради');
        expect(homework.isDone, false);
        expect(homework.attachments, isEmpty);
      });

      test('creates Homework with isDone defaulting to false', () {
        final homework = Homework.fromMap({
          'homework_id': 11111,
          'homework': 'решить задачу',
          'materials': [],
          'date': '2026-02-17',
          'subject_name': 'Математика',
        });

        expect(homework.isDone, false);
      });

      test('creates Homework with isDone set to true', () {
        final homework = Homework.fromMap({
          'homework_id': 22222,
          'homework': 'прочитать главу 5',
          'materials': [],
          'date': '2026-02-18',
          'subject_name': 'Литература',
          'is_done': true,
        });

        expect(homework.isDone, true);
      });

      test('creates Homework with Cyrillic subject and description', () {
        final homework = Homework.fromMap({
          'homework_id': 33333,
          'homework': 'упражнение 567',
          'materials': [],
          'date': '2026-02-19',
          'subject_name': 'Русский язык',
          'is_done': false,
        });

        expect(homework.subjectName, 'Русский язык');
        expect(homework.description, 'упражнение 567');
      });
    });

    group('fromMap with attachments', () {
      test('creates Homework with single attachment', () {
        final homework = Homework.fromMap({
          'homework_id': 44444,
          'homework': 'посмотреть видео',
          'materials': [
            {'url': 'https://example.com/video.mp4', 'title': 'Видео урока'}
          ],
          'date': '2026-02-20',
          'subject_name': 'Физика',
          'is_done': false,
        });

        expect(homework.attachments.length, 1);
        expect(homework.attachments.first.url, 'https://example.com/video.mp4');
        expect(homework.attachments.first.title, 'Видео урока');
      });

      test('creates Homework with multiple attachments', () {
        final homework = Homework.fromMap({
          'homework_id': 55555,
          'homework': 'выполнить проект',
          'materials': [
            {'url': 'https://example.com/doc1.pdf', 'title': 'Инструкция'},
            {'url': 'https://example.com/doc2.pdf', 'title': 'Шаблон'},
            {'url': 'https://example.com/image.png', 'title': 'Пример'},
          ],
          'date': '2026-02-21',
          'subject_name': 'Информатика',
          'is_done': false,
        });

        expect(homework.attachments.length, 3);
        expect(homework.attachments[0].title, 'Инструкция');
        expect(homework.attachments[1].title, 'Шаблон');
        expect(homework.attachments[2].title, 'Пример');
      });

      test('creates Homework with ЦДЗ attachment', () {
        final homework = Homework.fromMap({
          'homework_id': 66666,
          'homework': 'ЦДЗ упражнение',
          'materials': [
            {
              'url': 'https://myschool.mosreg.ru/cdz/123',
              'title': 'ЦДЗ (Цифровое Домашнее Задание)'
            }
          ],
          'date': '2026-02-22',
          'subject_name': 'Английский язык',
          'is_done': true,
        });

        expect(homework.attachments.length, 1);
        expect(
          homework.attachments.first.title,
          'ЦДЗ (Цифровое Домашнее Задание)',
        );
      });
    });

    group('fromJson', () {
      test('creates Homework from valid JSON string', () {
        final json = '''
        {
          "homework_id": 77777,
          "homework": "подготовиться к контрольной",
          "materials": [],
          "date": "2026-02-23",
          "subject_name": "История",
          "is_done": false
        }
        ''';

        final homework = Homework.fromJson(json);

        expect(homework.id, 77777);
        expect(homework.subjectName, 'История');
        expect(homework.description, 'подготовиться к контрольной');
      });
    });

    group('toMap', () {
      test('converts Homework to map', () {
        final homework = Homework(
          id: 88888,
          date: DateTime(2026, 3, 1),
          subjectName: 'География',
          description: 'прочитать параграф 12',
          attachments: [],
          isDone: false,
        );

        final map = homework.toMap();

        expect(map['homework_id'], 88888);
        expect(map['subject_name'], 'География');
        expect(map['homework'], 'прочитать параграф 12');
        expect(map['is_done'], false);
        expect(map['materials'], isA<List>());
      });

      test('toMap includes attachments', () {
        final homework = Homework(
          id: 99999,
          date: DateTime(2026, 3, 2),
          subjectName: 'Биология',
          description: 'лабораторная работа',
          attachments: [
            const Attachment(url: 'https://example.com/lab.pdf', title: 'Лабораторная'),
          ],
          isDone: true,
        );

        final map = homework.toMap();

        expect(map['materials'], isA<List>());
        expect((map['materials'] as List).length, 1);
      });
    });

    group('toJson', () {
      test('converts Homework to JSON string', () {
        final homework = Homework(
          id: 10101,
          date: DateTime(2026, 3, 3),
          subjectName: 'ОБЖ',
          description: 'выучить правила',
          attachments: [],
          isDone: false,
        );

        final json = homework.toJson();
        final decoded = Homework.fromJson(json);

        expect(decoded.id, homework.id);
        expect(decoded.date, homework.date);
        expect(decoded.subjectName, homework.subjectName);
        expect(decoded.description, homework.description);
        expect(decoded.isDone, homework.isDone);
      });
    });

    group('copyWith', () {
      late Homework original;

      setUp(() {
        original = Homework(
          id: 100,
          date: DateTime(2026, 1, 1),
          subjectName: 'Математика',
          description: 'Исходное задание',
          attachments: [],
          isDone: false,
        );
      });

      test('returns copy with same values when no arguments', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.date, original.date);
        expect(copy.subjectName, original.subjectName);
        expect(copy.description, original.description);
        expect(copy.isDone, original.isDone);
        expect(copy, isNot(same(original)));
      });

      test('updates id when provided', () {
        final copy = original.copyWith(id: 200);
        expect(copy.id, 200);
        expect(original.id, 100);
      });

      test('updates date when provided', () {
        final copy = original.copyWith(date: DateTime(2026, 6, 15));
        expect(copy.date, DateTime(2026, 6, 15));
      });

      test('updates subjectName when provided', () {
        final copy = original.copyWith(subjectName: 'Физика');
        expect(copy.subjectName, 'Физика');
      });

      test('updates description when provided', () {
        final copy = original.copyWith(description: 'Новое задание');
        expect(copy.description, 'Новое задание');
      });

      test('updates isDone when provided', () {
        final copy = original.copyWith(isDone: true);
        expect(copy.isDone, true);
        expect(original.isDone, false);
      });

      test('updates attachments when provided', () {
        final newAttachments = [
          const Attachment(url: 'https://example.com/new.pdf', title: 'Новый файл'),
        ];
        final copy = original.copyWith(attachments: newAttachments);

        expect(copy.attachments.length, 1);
        expect(copy.attachments.first.title, 'Новый файл');
      });

      test('updates multiple fields at once', () {
        final copy = original.copyWith(
          id: 200,
          date: DateTime(2026, 12, 25),
          subjectName: 'Химия',
          description: 'Новое задание',
          isDone: true,
        );

        expect(copy.id, 200);
        expect(copy.date, DateTime(2026, 12, 25));
        expect(copy.subjectName, 'Химия');
        expect(copy.description, 'Новое задание');
        expect(copy.isDone, true);
      });
    });

    group('equality', () {
      test('equal homework have same hashCode', () {
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

      test('different ids make homework unequal', () {
        final h1 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: []);
        final h2 = Homework(id: 2, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: []);

        expect(h1, isNot(equals(h2)));
      });

      test('different descriptions make homework unequal', () {
        final h1 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание 1', attachments: []);
        final h2 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание 2', attachments: []);

        expect(h1, isNot(equals(h2)));
      });

      test('different isDone make homework unequal', () {
        final h1 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: [], isDone: false);
        final h2 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: [], isDone: true);

        expect(h1, isNot(equals(h2)));
      });

      test('different attachments make homework unequal', () {
        final h1 = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: []);
        final h2 = Homework(
          id: 1,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          description: 'Задание',
          attachments: [const Attachment(url: 'https://example.com/f.pdf', title: 'Файл')],
        );

        expect(h1, isNot(equals(h2)));
      });

      test('identical homework is equal to itself', () {
        final homework = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: []);

        expect(homework, equals(homework));
      });

      test('homework is not equal to non-Homework object', () {
        final homework = Homework(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', description: 'Задание', attachments: []);

        expect(homework, isNot(equals('not homework')));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        final homework = Homework(
          id: 123,
          date: DateTime(2026, 2, 16),
          subjectName: 'Математика',
          description: 'Упражнение 5',
          attachments: [],
          isDone: false,
        );

        expect(
          homework.toString(),
          'Homework(id: 123, date: 2026-02-16 00:00:00.000, subjectName: Математика, description: Упражнение 5, isDone: false)',
        );
      });
    });
  });
}
