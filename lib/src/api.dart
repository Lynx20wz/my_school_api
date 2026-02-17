import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:http/http.dart' show get;
import 'package:intl/intl.dart' show DateFormat;

import 'classes/homework.dart';
import 'classes/mark.dart';

/// A Dart client for the "My School" (Моя Школа) API system (Moscow Region).
///
/// This class provides methods to interact with the educational platform,
/// allowing you to fetch homework assignments and student marks.
///
/// ## Usage
///
/// ```dart
/// import 'package:my_school_api/my_school_api.dart';
///
/// void main() async {
///   // Initialize the API client with your authentication token
///   final api = await MySchoolApi.init('YOUR_AUTH_TOKEN');
///
///   // Fetch homework for a specific date
///   final homework = await api.getHomework(DateTime(2026, 2, 16));
///
///   // Fetch marks for a date range
///   final marks = await api.getMarks(
///     DateTime(2026, 2, 10),
///     to: DateTime(2026, 2, 16),
///   );
/// }
/// ```
///
/// ## Authentication
///
/// The API requires a Bearer token for authentication. You can obtain this token
/// from the browser's developer tools or from the mobile app.
///
/// See also:
/// - [Homework] class for homework assignment details
/// - [Mark] class for student mark details
class MySchoolApi {
  /// Base URL for the My School API.
  static const _baseUrl = 'https://authedu.mosreg.ru/api';

  /// The authentication token used for API requests.
  final String token;

  /// The unique identifier of the student.
  final int studentId;

  /// Private constructor used internally.
  ///
  /// Use [MySchoolApi.init] to create an instance.
  MySchoolApi._(this.token, this.studentId);

  /// Fetches homework assignments for a student within a given date range.
  ///
  /// [from] is the start date of the range (inclusive).
  /// [to] is the end date of the range (inclusive). If not provided,
  /// it defaults to [from] (single day).
  ///
  /// Returns a list of [Homework] objects for the specified date range.
  ///
  /// Example:
  /// ```dart
  /// // Get homework for a single day
  /// final homework = await api.getHomework(DateTime(2026, 2, 16));
  ///
  /// // Get homework for a week
  /// final weekHomework = await api.getHomework(
  ///   DateTime(2026, 2, 10),
  ///   to: DateTime(2026, 2, 16),
  /// );
  ///
  /// for (final hw in homework) {
  ///   print('${hw.subjectName}: ${hw.description}');
  /// }
  /// ```
  ///
  /// Throws an [ArgumentError] if [from] is after [to].
  /// Throws an [Exception] if the API request fails.
  Future<List<Homework>> getHomework(DateTime from, {DateTime? to}) async {
    to ??= from;

    if (from.isAfter(to)) {
      throw ArgumentError('Invalid date range: "from" date must be before or equal to "to" date.');
    }

    final dateFormat = DateFormat('y-MM-dd');

    final response = await get(
      Uri.parse('$_baseUrl/family/web/v1/homeworks').replace(
        queryParameters: {
          'from': dateFormat.format(from),
          'to': dateFormat.format(to),
          'student_id': studentId.toString(),
        },
      ),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['payload'];
      return json.map((e) => Homework.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load homework: ${response.body}');
    }
  }

  /// Fetches student marks within a given date range.
  ///
  /// [from] is the start date of the range (inclusive).
  /// [to] is the end date of the range (inclusive). If not provided,
  /// it defaults to [from] (single day).
  ///
  /// Returns a list of [Mark] objects for the specified date range.
  ///
  /// Example:
  /// ```dart
  /// // Get marks for a single day
  /// final marks = await api.getMarks(DateTime(2026, 2, 16));
  ///
  /// // Get marks for a month
  /// final monthMarks = await api.getMarks(
  ///   DateTime(2026, 2, 1),
  ///   to: DateTime(2026, 2, 28),
  /// );
  ///
  /// for (final mark in marks) {
  ///   print('${mark.subjectName}: ${mark.value}');
  /// }
  /// ```
  ///
  /// Logs a warning if [from] is in the future.
  /// Throws an [Exception] if the API request fails.
  Future<List<Mark>> getMarks(DateTime from, {DateTime? to}) async {
    if (DateTime.now().isBefore(from)) {
      log(
        r'\033[43m[WARN] Attempted to fetch marks before current date\033[0m',
      );
    }

    to ??= from;

    final dateFormat = DateFormat('y-MM-dd');

    final response = await get(
      Uri.parse('$_baseUrl/family/web/v1/marks').replace(
        queryParameters: {
          'from': dateFormat.format(from),
          'to': dateFormat.format(to),
          'student_id': studentId.toString(),
        },
      ),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['payload'];
      return json.map((e) => Mark.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load marks: ${response.body}');
    }
  }

  /// Marks a homework assignment as completed.
  ///
  /// [homework] is the [Homework] object to mark as done.
  ///
  /// ## Not implemented
  ///
  /// This method currently throws an [UnimplementedError].
  /// Functionality may be added in a future version.
  Future<void> markHomeworkAsDone(Homework homework) async =>
      throw UnimplementedError();

  /// Initializes a [MySchoolApi] instance with the provided authentication token.
  ///
  /// [token] is the Bearer token for API authentication.
  /// [studentId] is an optional student ID. If not provided, it will be
  /// automatically fetched from the API.
  ///
  /// Returns a configured [MySchoolApi] instance.
  ///
  /// Example:
  /// ```dart
  /// // Auto-detect student ID
  /// final api = await MySchoolApi.init('YOUR_TOKEN');
  ///
  /// // Specify student ID manually
  /// final api = await MySchoolApi.init('YOUR_TOKEN', studentId: 12345);
  /// ```
  ///
  /// Throws an [Exception] if the token is invalid or if fetching the student ID fails.
  static Future<MySchoolApi> init(String token, {int? studentId}) async {
    final id = studentId ?? await _getStudentId(token);
    return MySchoolApi._(token, id);
  }

  /// Returns HTTP headers required for API requests.
  ///
  /// [token] is the authentication token.
  static Map<String, String> _getHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-mes-subsystem': 'familyweb',
      };

  /// Fetches the student ID from the API.
  ///
  /// [token] is the authentication token.
  ///
  /// Returns the student ID as an integer.
  ///
  /// Throws an [Exception] with message "Invalid token" if authentication fails.
  /// Throws an [Exception] if the request fails for any other reason.
  static Future<int> _getStudentId(String token) => get(
        Uri.parse('https://myschool.mosreg.ru/acl/api/users/profile_info'),
        headers: _getHeaders(token)..['Auth-Token'] = token,
      ).then((response) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data[0]['id'];
        } else if (response.statusCode == 401) {
          throw Exception('Invalid token: Authentication failed. Please check your token.');
        } else {
          throw Exception('Failed to get student ID: ${response.body}');
        }
      });
}
