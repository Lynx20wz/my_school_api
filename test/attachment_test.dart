import 'package:my_school_api/my_school_api.dart';
import 'package:test/test.dart';

void main() {
  group('Attachment', () {
    group('fromMap', () {
      test('creates Attachment from valid map', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/document.pdf',
          'title': 'Документ PDF',
        });

        expect(attachment.url, 'https://example.com/document.pdf');
        expect(attachment.title, 'Документ PDF');
      });

      test('creates Attachment with empty title', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/file.txt',
          'title': '',
        });

        expect(attachment.url, 'https://example.com/file.txt');
        expect(attachment.title, isEmpty);
      });

      test('creates Attachment with Cyrillic title', () {
        final attachment = Attachment.fromMap({
          'url': 'https://example.com/цдз.pdf',
          'title': 'Цифровое Домашнее Задание',
        });

        expect(attachment.title, 'Цифровое Домашнее Задание');
      });
    });

    group('fromJson', () {
      test('creates Attachment from valid JSON string', () {
        final json =
            '{"url": "https://example.com/img.png", "title": "Изображение"}';
        final attachment = Attachment.fromJson(json);

        expect(attachment.url, 'https://example.com/img.png');
        expect(attachment.title, 'Изображение');
      });
    });

    group('toMap', () {
      test('converts Attachment to map', () {
        final attachment = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Тестовый файл',
        );

        final map = attachment.toMap();

        expect(map, {
          'url': 'https://example.com/file.pdf',
          'title': 'Тестовый файл',
        });
      });
    });

    group('toJson', () {
      test('converts Attachment to JSON string', () {
        final attachment = const Attachment(
          url: 'https://example.com/doc.pdf',
          title: 'Документ',
        );

        final json = attachment.toJson();
        final decoded = Attachment.fromJson(json);

        expect(decoded.url, attachment.url);
        expect(decoded.title, attachment.title);
      });
    });

    group('equality', () {
      test('equal attachments have same hashCode', () {
        final a1 = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Файл',
        );
        final a2 = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Файл',
        );

        expect(a1.hashCode, equals(a2.hashCode));
      });

      test('different urls make attachments unequal', () {
        final a1 = const Attachment(
          url: 'https://example.com/file1.pdf',
          title: 'Файл',
        );
        final a2 = const Attachment(
          url: 'https://example.com/file2.pdf',
          title: 'Файл',
        );

        expect(a1, isNot(equals(a2)));
      });

      test('different titles make attachments unequal', () {
        final a1 = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Название 1',
        );
        final a2 = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Название 2',
        );

        expect(a1, isNot(equals(a2)));
      });

      test('identical attachments are equal', () {
        final attachment = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Файл',
        );

        expect(attachment, equals(attachment));
      });

      test('attachment is not equal to non-Attachment object', () {
        final attachment = const Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Файл',
        );

        expect(attachment, isNot(equals('not an attachment')));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        const attachment = Attachment(
          url: 'https://example.com/file.pdf',
          title: 'Документ',
        );

        expect(
          attachment.toString(),
          'Attachment(url: https://example.com/file.pdf, title: Документ)',
        );
      });
    });
  });
}
