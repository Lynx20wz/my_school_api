import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('getMonday', () {
    final testCases = [
      (DateTime(2026, 1, 5), DateTime(2026, 1, 5)),
      (DateTime(2026, 1, 6), DateTime(2026, 1, 5)),
      (DateTime(2026, 1, 7), DateTime(2026, 1, 5)),
      (DateTime(2026, 1, 8), DateTime(2026, 1, 5)),
      (DateTime(2026, 1, 9), DateTime(2026, 1, 5)),
      (DateTime(2026, 1, 10), DateTime(2026, 1, 12)),
      (DateTime(2026, 1, 11), DateTime(2026, 1, 12)),
    ];

    for (var i = 0; i < testCases.length; i++) {
      final (input, expected) = testCases[i];
      test('case $i (${_dayName(input.weekday)})', () {
        expect(getMonday(input), expected);
      });
    }
  });
}

String _dayName(int weekday) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][weekday - 1];
