import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:http/http.dart' show get;
import 'package:intl/intl.dart' show DateFormat;

import 'classes/homework.dart';
import 'classes/mark.dart';
import 'exceptions.dart';

/// A Dart client for the "My School" (Моя Школа) API system (Moscow Region).
///
/// Provides methods to fetch homework assignments and student marks.
///
/// ## Usage
///
/// ```dart
/// import 'package:my_school_api/my_school_api.dart';
///
/// void main() async {
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
/// The API requires a Bearer token obtained from browser dev tools or the mobile app.
///
/// See also:
/// - [Homework] for homework assignment details
/// - [Mark] for student mark details
class MySchoolApi {
  /// Base URL for the My School API.
  static const _baseUrl = 'https://authedu.mosreg.ru/api';

  /// The authentication token for API requests.
  final String token;

  /// The unique identifier of the student.
  late final int _studentId;

  /// Private constructor. Use [MySchoolApi.init] to create an instance.
  MySchoolApi._(this.token, this._studentId);

  /// Fetches homework assignments for a date range.
  ///
  /// [from] is the start date (inclusive).
  /// [to] is the end date (inclusive), defaults to [from] if not provided.
  ///
  /// Example:
  /// ```dart
  /// final homework = await api.getHomework(DateTime(2026, 2, 16));
  /// ```
  ///
  /// Throws [InvalidDateRangeException] if [from] is after [to].
  /// Throws [ApiRequestException] if the API request fails.
  Future<List<Homework>> getHomework(DateTime from, {DateTime? to}) async {
    to ??= from;

    if (from.isAfter(to)) {
      throw InvalidDateRangeException(
        '"from" date must be before or equal to "to" date',
        from: from,
        to: to,
      );
    }

    final dateFormat = DateFormat('y-MM-dd');

    final response = await get(
      Uri.parse('$_baseUrl/family/web/v1/homeworks').replace(
        queryParameters: {
          'from': dateFormat.format(from),
          'to': dateFormat.format(to),
          'student_id': _studentId.toString(),
        },
      ),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['payload'];
      return json.map((e) => Homework.fromMap(e)).toList();
    } else {
      throw ApiRequestException(
        'Failed to load homework',
        statusCode: response.statusCode,
        url: '$_baseUrl/family/web/v1/homeworks',
        responseBody: response.body,
      );
    }
  }

  /// Fetches student marks for a date range.
  ///
  /// [from] is the start date (inclusive).
  /// [to] is the end date (inclusive), defaults to [from] if not provided.
  ///
  /// Example:
  /// ```dart
  /// final marks = await api.getMarks(DateTime(2026, 2, 16));
  /// ```
  ///
  /// Logs a warning if [from] is in the future.
  /// Throws [InvalidDateRangeException] if [from] is after [to].
  /// Throws [ApiRequestException] if the API request fails.
  Future<List<Mark>> getMarks(DateTime from, {DateTime? to}) async {
    if (DateTime.now().isBefore(from)) {
      log(
        r'\033[43m[WARN] Attempted to fetch marks before current date\033[0m',
      );
    }

    to ??= from;

    if (from.isAfter(to)) {
      throw InvalidDateRangeException(
        '"from" date must be before or equal to "to" date',
        from: from,
        to: to,
      );
    }

    final dateFormat = DateFormat('y-MM-dd');

    final response = await get(
      Uri.parse('$_baseUrl/family/web/v1/marks').replace(
        queryParameters: {
          'from': dateFormat.format(from),
          'to': dateFormat.format(to),
          'student_id': _studentId.toString(),
        },
      ),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['payload'];
      return json.map((e) => Mark.fromMap(e)).toList();
    } else {
      throw ApiRequestException(
        'Failed to load marks',
        statusCode: response.statusCode,
        url: '$_baseUrl/family/web/v1/marks',
        responseBody: response.body,
      );
    }
  }

  /// Marks a homework assignment as completed.
  ///
  /// [homework] is the [Homework] to mark as done.
  ///
  /// ## Not implemented
  ///
  /// Throws [UnimplementedError].
  Future<void> markHomeworkAsDone(Homework homework) async =>
      throw UnimplementedError();

  /// Initializes a [MySchoolApi] instance.
  ///
  /// [token] is the Bearer token for authentication.
  ///
  /// The student ID is fetched automatically from the API.
  ///
  /// Example:
  /// ```dart
  /// final api = await MySchoolApi.init('YOUR_TOKEN');
  /// ```
  ///
  /// Throws [AuthenticationException] if the token is invalid.
  /// Throws [StudentIdNotFoundException] if student ID cannot be retrieved.
  static Future<MySchoolApi> init(String token) async {
    final id = await _getStudentId(token);
    return MySchoolApi._(token, id);
  }

  /// Returns HTTP headers for API requests.
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
  /// Throws [AuthenticationException] if the token is invalid.
  /// Throws [StudentIdNotFoundException] if no student ID is found.
  static Future<int> _getStudentId(String token) =>
      get(
        Uri.parse('https://myschool.mosreg.ru/acl/api/users/profile_info'),
        headers: _getHeaders(token)..['Auth-Token'] = token,
      ).then((response) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List<dynamic>;
          if (data.isEmpty || data[0]['id'] == null) {
            throw const StudentIdNotFoundException(
              'No student ID found in the API response',
            );
          }
          return data[0]['id'] as int;
        } else if (response.statusCode == 401) {
          throw const AuthenticationException(
            'Invalid token: Authentication failed. Please check your token.',
            statusCode: 401,
          );
        } else {
          throw ApiRequestException(
            'Failed to get student ID',
            statusCode: response.statusCode,
            url: 'https://myschool.mosreg.ru/acl/api/users/profile_info',
            responseBody: response.body,
          );
        }
      });
}
