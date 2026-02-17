import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('MySchoolApiException', () {
    test('has correct message', () {
      const exception = MySchoolApiExceptionImpl('Test message');
      expect(exception.message, equals('Test message'));
      expect(
        exception.toString(),
        equals('MySchoolApiException: Test message'),
      );
    });

    test('can be caught as base exception type', () {
      try {
        throw const AuthenticationException('Auth failed', statusCode: 401);
      } on MySchoolApiException catch (e) {
        expect(e.message, equals('Auth failed'));
      }
    });
  });

  group('AuthenticationException', () {
    test('has correct message and statusCode', () {
      const exception = AuthenticationException(
        'Invalid token',
        statusCode: 401,
      );

      expect(exception.message, equals('Invalid token'));
      expect(exception.statusCode, equals(401));
      expect(
        exception.toString(),
        equals('AuthenticationException (status: 401): Invalid token'),
      );
    });

    test('can be caught specifically', () {
      try {
        throw const AuthenticationException('Token expired', statusCode: 401);
      } on AuthenticationException catch (e) {
        expect(e.statusCode, equals(401));
        expect(e.message, equals('Token expired'));
      }
    });
  });

  group('StudentIdNotFoundException', () {
    test('has correct message', () {
      const exception = StudentIdNotFoundException('No student ID found');

      expect(exception.message, equals('No student ID found'));
      expect(
        exception.toString(),
        equals('MySchoolApiException: No student ID found'),
      );
    });

    test('can be caught specifically', () {
      try {
        throw const StudentIdNotFoundException('Student not found');
      } on StudentIdNotFoundException catch (e) {
        expect(e.message, equals('Student not found'));
      }
    });
  });

  group('ApiRequestException', () {
    test('has correct message, statusCode, url, and responseBody', () {
      const exception = ApiRequestException(
        'Failed to load data',
        statusCode: 500,
        url: 'https://api.example.com/data',
        responseBody: '{"error": "Internal server error"}',
      );

      expect(exception.message, equals('Failed to load data'));
      expect(exception.statusCode, equals(500));
      expect(exception.url, equals('https://api.example.com/data'));
      expect(
        exception.responseBody,
        equals('{"error": "Internal server error"}'),
      );
      expect(
        exception.toString(),
        contains('ApiRequestException (status: 500): Failed to load data'),
      );
      expect(exception.toString(), contains('Internal server error'));
    });

    test('handles null responseBody', () {
      const exception = ApiRequestException(
        'Network error',
        statusCode: 0,
        url: 'https://api.example.com/data',
      );

      expect(exception.responseBody, isNull);
      expect(
        exception.toString(),
        equals('ApiRequestException (status: 0): Network error'),
      );
    });

    test('can be caught specifically', () {
      try {
        throw const ApiRequestException(
          'Server error',
          statusCode: 503,
          url: 'https://api.example.com',
        );
      } on ApiRequestException catch (e) {
        expect(e.statusCode, equals(503));
        expect(e.message, equals('Server error'));
      }
    });
  });

  group('InvalidDateRangeException', () {
    test('has correct message and dates', () {
      final from = DateTime(2026, 2, 20);
      final to = DateTime(2026, 2, 10);
      final exception = InvalidDateRangeException(
        'from must be before to',
        from: from,
        to: to,
      );

      expect(exception.message, equals('from must be before to'));
      expect(exception.from, equals(from));
      expect(exception.to, equals(to));
      expect(
        exception.toString(),
        contains('InvalidDateRangeException: from must be before to'),
      );
      expect(exception.toString(), contains('2026-02-20'));
      expect(exception.toString(), contains('2026-02-10'));
    });

    test('can be caught specifically', () {
      try {
        throw InvalidDateRangeException(
          'Invalid range',
          from: DateTime(2026, 2, 20),
          to: DateTime(2026, 2, 10),
        );
      } on InvalidDateRangeException catch (e) {
        expect(e.message, equals('Invalid range'));
        expect(e.from.isAfter(e.to), isTrue);
      }
    });
  });

  group('Exception hierarchy', () {
    test('all custom exceptions extend MySchoolApiException', () {
      const authException = AuthenticationException(
        'Auth error',
        statusCode: 401,
      );
      const studentException = StudentIdNotFoundException('No student');
      const apiException = ApiRequestException(
        'API error',
        statusCode: 500,
        url: 'https://api.example.com',
      );
      final dateException = InvalidDateRangeException(
        'Bad dates',
        from: DateTime(2026, 2, 20),
        to: DateTime(2026, 2, 10),
      );

      expect(authException, isA<MySchoolApiException>());
      expect(studentException, isA<MySchoolApiException>());
      expect(apiException, isA<MySchoolApiException>());
      expect(dateException, isA<MySchoolApiException>());
    });

    test('can catch all exceptions as MySchoolApiException', () {
      final exceptions = [
        const AuthenticationException('Auth error', statusCode: 401),
        const StudentIdNotFoundException('No student'),
        const ApiRequestException(
          'API error',
          statusCode: 500,
          url: 'https://api.example.com',
        ),
        InvalidDateRangeException(
          'Bad dates',
          from: DateTime(2026, 2, 20),
          to: DateTime(2026, 2, 10),
        ),
      ];

      for (final exception in exceptions) {
        try {
          throw exception;
        } on MySchoolApiException catch (e) {
          expect(e, isA<MySchoolApiException>());
        }
      }
    });
  });
}

/// Implementation class for testing the abstract base exception.
class MySchoolApiExceptionImpl extends MySchoolApiException {
  const MySchoolApiExceptionImpl(super.message);
}
