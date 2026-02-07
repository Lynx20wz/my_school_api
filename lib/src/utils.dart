import 'dart:io';

/// Returns the date of Monday:
/// If [date] is workday returns the previous Monday
/// Else if [date] is weekend returns the next Monday
DateTime getMonday(DateTime date) {
  final indexOfDay = date.weekday;
  return indexOfDay < 6
      ? date.subtract(Duration(days: indexOfDay - 1))
      : date.subtract(Duration(days: indexOfDay - 8));
}

String getToken() {
  String? token;

  do {
    print('Enter the token:');
    token = stdin.readLineSync()?.trim();

    if (token == null || token.isEmpty) {
      print('Token cannot be empty!');
      continue;
    }

    if (!token.startsWith('eyJhb')) {
      print('Invalid token format!');
      token = null;
    }
  } while (token == null);

  return token;
}
