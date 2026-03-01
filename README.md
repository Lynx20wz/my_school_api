# My School API

Dart library for working with the "My School" (Моя Школа) API system (Moscow Region).  
Allows programmatic access to student homework assignments and marks.

> **Disclaimer:** This is an unofficial package. Use at your own risk.  
> A valid authentication token from `authedu.mosreg.ru` is required.

## Features

- ✅ Fetch homework assignments by date
- ✅ Fetch student marks by date
- ✅ Subject information
- ✅ Homework attachments
- ✅ Homework completion status

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  my_school_api: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Obtaining a Token

You can get a token from your browser:

1. Go to [My School](https://myschool.mosreg.ru)
2. Log in
3. Open DevTools (F12) → Network tab
4. Find any API request and copy the `Authorization` header value (without `Bearer `)

Alternatively, use an existing token from the mobile app or other sources.

## Usage

### Initialization

```dart
import 'package:my_school_api/my_school_api.dart';

void main() async {
  // Initialize with token
  final api = await MySchoolApi.init('YOUR_TOKEN');
}
```

### Fetching Marks

```dart
// Marks for a specific date
final marks = await api.getMarks(DateTime(2026, 2, 16));

for (final mark in marks) {
  print('${mark.subjectName}: ${mark.value} (${mark.date})');
}

// Marks for a date range
final weekMarks = await api.getMarks(
  DateTime(2026, 2, 10),
  to: DateTime(2026, 2, 16),
);
```

### Fetching Homework

```dart
// Homework for a specific date
final homework = await api.getHomework(DateTime(2026, 2, 16));

for (final hw in homework) {
  print('${hw.subjectName}: ${hw.description}');
  print('Done: ${hw.isDone}');
  
  // Attachments
  if (hw.attachments.isNotEmpty) {
    for (final attachment in hw.attachments) {
      print('  📎 ${attachment.name}: ${attachment.url}');
    }
  }
}

// Homework for a date range
final weekHomework = await api.getHomework(
  DateTime(2026, 2, 10),
  to: DateTime(2026, 2, 16),
);
```

## Classes

### `Mark` — Student Mark

| Field | Type | Description |
|-------|------|-------------|
| `id` | `int` | Unique identifier |
| `date` | `DateTime` | Date of the mark |
| `subjectName` | `String` | Subject name |
| `value` | `int` | Mark value (2-5) |

### `Homework` — Homework Assignment

| Field | Type | Description |
|-------|------|-------------|
| `id` | `int` | Unique identifier |
| `date` | `DateTime` | Assignment date |
| `subjectName` | `String` | Subject name |
| `description` | `String` | Assignment text |
| `attachments` | `List<Attachment>` | File attachments |
| `isDone` | `bool` | Completion status |

### `Attachment` — File Attachment

| Field | Type | Description |
|-------|------|-------------|
| `name` | `String` | File name |
| `url` | `String?` | File URL |

## Examples

See more examples in the [example file](example/my_school_api_example.dart).

## Requirements

- Dart SDK: `^3.10.8`

## Dependencies

- `http` — HTTP requests
- `intl` — date formatting
- `path` — path manipulation
- `json_annotation` - json serialization

## Limitations

- `markHomeworkAsDone()` method is not yet implemented
- Tokens have limited lifetime (about 2 weeks)
- API may change without notice

## Status

This package is in early development.  
API changes and instability are expected.

## License

MIT — see [LICENSE](LICENSE) file.

## Contributing

PRs are welcome! For major changes, please open an issue first.

---

**Unofficial client.** Not affiliated with the official "Моя школа" system developers.
