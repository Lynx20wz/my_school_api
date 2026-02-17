import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('Mark', () {
    group('fromMap', () {
      test('creates Mark from valid map with string value', () {
        final mark = Mark.fromMap({
          'id': 98765,
          'value': '5',
          'date': '2026-02-16',
          'subject_name': 'Русский язык',
        });

        expect(mark.id, 98765);
        expect(mark.value, 5);
        expect(mark.date, DateTime(2026, 2, 16));
        expect(mark.subjectName, 'Русский язык');
      });

      test('creates Mark from valid map with int value', () {
        final mark = Mark.fromMap({
          'id': 54321,
          'value': 4,
          'date': '2026-02-17',
          'subject_name': 'Алгебра',
        });

        expect(mark.id, 54321);
        expect(mark.value, 4);
        expect(mark.subjectName, 'Алгебра');
      });

      test('creates Mark with Cyrillic subject name', () {
        final mark = Mark.fromMap({
          'id': 11111,
          'value': '3',
          'date': '2026-03-01',
          'subject_name': 'Литература',
        });

        expect(mark.subjectName, 'Литература');
        expect(mark.value, 3);
      });

      test('creates Mark with all valid grade values', () {
        final mark2 = Mark.fromMap({'id': 1, 'value': '2', 'date': '2026-02-16', 'subject_name': 'Математика'});
        final mark3 = Mark.fromMap({'id': 2, 'value': '3', 'date': '2026-02-16', 'subject_name': 'Математика'});
        final mark4 = Mark.fromMap({'id': 3, 'value': '4', 'date': '2026-02-16', 'subject_name': 'Математика'});
        final mark5 = Mark.fromMap({'id': 4, 'value': '5', 'date': '2026-02-16', 'subject_name': 'Математика'});

        expect(mark2.value, 2);
        expect(mark3.value, 3);
        expect(mark4.value, 4);
        expect(mark5.value, 5);
      });

      test('throws ArgumentError for invalid value 1', () {
        expect(
          () => Mark.fromMap({'id': 1, 'value': '1', 'date': '2026-02-16', 'subject_name': 'Математика'}),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid value 0', () {
        expect(
          () => Mark.fromMap({'id': 1, 'value': '0', 'date': '2026-02-16', 'subject_name': 'Математика'}),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid value 6', () {
        expect(
          () => Mark.fromMap({'id': 1, 'value': '6', 'date': '2026-02-16', 'subject_name': 'Математика'}),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid negative value', () {
        expect(
          () => Mark.fromMap({'id': 1, 'value': '-1', 'date': '2026-02-16', 'subject_name': 'Математика'}),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('fromJson', () {
      test('creates Mark from valid JSON string', () {
        final json = '{"id": 12345, "value": "5", "date": "2026-02-20", "subject_name": "Физика"}';
        final mark = Mark.fromJson(json);

        expect(mark.id, 12345);
        expect(mark.value, 5);
        expect(mark.date, DateTime(2026, 2, 20));
        expect(mark.subjectName, 'Физика');
      });

      test('throws ArgumentError for invalid value in JSON', () {
        final json = '{"id": 1, "value": "6", "date": "2026-02-16", "subject_name": "Математика"}';
        expect(() => Mark.fromJson(json), throwsA(isA<ArgumentError>()));
      });
    });

    group('constructor validation', () {
      test('creates Mark with valid value 2', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 2);
        expect(mark.value, 2);
      });

      test('creates Mark with valid value 3', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 3);
        expect(mark.value, 3);
      });

      test('creates Mark with valid value 4', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 4);
        expect(mark.value, 4);
      });

      test('creates Mark with valid value 5', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);
        expect(mark.value, 5);
      });

      test('throws AssertionError for invalid value 1', () {
        expect(
          () => Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws AssertionError for invalid value 6', () {
        expect(
          () => Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 6),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws AssertionError for invalid value 0', () {
        expect(
          () => Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 0),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws AssertionError for invalid negative value', () {
        expect(
          () => Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: -5),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('toMap', () {
      test('converts Mark to map', () {
        final mark = Mark(
          id: 99999,
          date: DateTime(2026, 5, 15),
          subjectName: 'Химия',
          value: 5,
        );

        final map = mark.toMap();

        expect(map['id'], 99999);
        expect(map['subject_name'], 'Химия');
        expect(map['value'], 5);
        expect(map['date'], isA<String>());
      });

      test('toMap produces valid ISO 8601 date', () {
        final mark = Mark(
          id: 1,
          date: DateTime(2026, 12, 25, 10, 30, 0),
          subjectName: 'Математика',
          value: 5,
        );

        final map = mark.toMap();
        expect(map['date'], contains('2026-12-25'));
      });
    });

    group('toJson', () {
      test('converts Mark to JSON string', () {
        final mark = Mark(
          id: 77777,
          date: DateTime(2026, 6, 1),
          subjectName: 'Биология',
          value: 4,
        );

        final json = mark.toJson();
        final decoded = Mark.fromJson(json);

        expect(decoded.id, mark.id);
        expect(decoded.date, mark.date);
        expect(decoded.subjectName, mark.subjectName);
        expect(decoded.value, mark.value);
      });
    });

    group('copyWith', () {
      late Mark original;

      setUp(() {
        original = Mark(
          id: 100,
          date: DateTime(2026, 1, 1),
          subjectName: 'История',
          value: 5,
        );
      });

      test('returns copy with same values when no arguments', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.date, original.date);
        expect(copy.subjectName, original.subjectName);
        expect(copy.value, original.value);
        expect(copy, isNot(same(original)));
      });

      test('updates id when provided', () {
        final copy = original.copyWith(id: 200);

        expect(copy.id, 200);
        expect(original.id, 100);
      });

      test('updates date when provided', () {
        final copy = original.copyWith(date: DateTime(2026, 2, 1));

        expect(copy.date, DateTime(2026, 2, 1));
        expect(original.date, DateTime(2026, 1, 1));
      });

      test('updates subjectName when provided', () {
        final copy = original.copyWith(subjectName: 'Физика');

        expect(copy.subjectName, 'Физика');
        expect(original.subjectName, 'История');
      });

      test('updates value when provided', () {
        final original = Mark(id: 100, date: DateTime(2026, 1, 1), subjectName: 'Математика', value: 3);
        final copy = original.copyWith(value: 5);

        expect(copy.value, 5);
        expect(original.value, 3);
      });

      test('throws AssertionError when updating to invalid value', () {
        final original = Mark(id: 100, date: DateTime(2026, 1, 1), subjectName: 'Математика', value: 5);
        expect(() => original.copyWith(value: 6), throwsA(isA<AssertionError>()));
      });

      test('updates multiple fields at once', () {
        final original = Mark(id: 100, date: DateTime(2026, 1, 1), subjectName: 'Математика', value: 3);
        final copy = original.copyWith(
          id: 200,
          date: DateTime(2026, 6, 15),
          subjectName: 'Физика',
          value: 5,
        );

        expect(copy.id, 200);
        expect(copy.date, DateTime(2026, 6, 15));
        expect(copy.subjectName, 'Физика');
        expect(copy.value, 5);
      });
    });

    group('equality', () {
      test('equal marks have same hashCode', () {
        final m1 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);
        final m2 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(m1.hashCode, equals(m2.hashCode));
      });

      test('different ids make marks unequal', () {
        final m1 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);
        final m2 = Mark(id: 2, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(m1, isNot(equals(m2)));
      });

      test('different dates make marks unequal', () {
        final m1 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);
        final m2 = Mark(id: 1, date: DateTime(2026, 2, 17), subjectName: 'Математика', value: 5);

        expect(m1, isNot(equals(m2)));
      });

      test('different subjectNames make marks unequal', () {
        final m1 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);
        final m2 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Физика', value: 5);

        expect(m1, isNot(equals(m2)));
      });

      test('different values make marks unequal', () {
        final m1 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 4);
        final m2 = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(m1, isNot(equals(m2)));
      });

      test('identical mark is equal to itself', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(mark, equals(mark));
      });

      test('mark is not equal to non-Mark object', () {
        final mark = Mark(id: 1, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(mark, isNot(equals('not a mark')));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        final mark = Mark(id: 123, date: DateTime(2026, 2, 16), subjectName: 'Математика', value: 5);

        expect(
          mark.toString(),
          'Mark(id: 123, date: 2026-02-16 00:00:00.000, subjectName: Математика, value: 5)',
        );
      });
    });

    group('validValues', () {
      test('contains only 2, 3, 4, 5', () {
        expect(Mark.validValues, equals({2, 3, 4, 5}));
      });

      test('does not contain invalid values', () {
        expect(Mark.validValues.contains(1), false);
        expect(Mark.validValues.contains(6), false);
        expect(Mark.validValues.contains(0), false);
        expect(Mark.validValues.contains(-1), false);
      });
    });
  });
}
