import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:http/http.dart' show get;
import 'package:intl/intl.dart' show DateFormat;
import 'package:my_school_api/src/classes/mark.dart';

import 'classes/homework.dart';

class MySchoolParser {
  static const _baseUrl = 'https://authedu.mosreg.ru/api';

  final String token;
  final int studentId;

  MySchoolParser._(this.token, this.studentId);

  /// Fetches homework for a student within a given date range.
  ///
  /// Returns homework in range from [from] to [to] as a list of [Homework] objects.
  /// If [to] is not provided, it defaults to [from].
  Future<List<Homework>> getHomework(DateTime from, {DateTime? to}) async {
    to ??= from;

    if (from.isAfter(to)) {
      throw ArgumentError('Invalid date range');
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

  /// Fetches marks for a student within a given date range.
  ///
  /// Returns marks in range from [from] to [to] as a list of [Mark] objects.
  /// If [to] is not provided, it defaults to [from].
  Future<List<Mark>> getMarks(DateTime from, {DateTime? to}) async {
    if (DateTime.now().isBefore(from)) {
      log('\033[43m[WARN] Attempted to fetch marks before current date\033[0m');
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

  static Future<MySchoolParser> init(String token, {int? studentId}) async {
    final id = studentId ?? await _getStudentId(token);
    return MySchoolParser._(token, id);
  }

  static Map<String, String> _getHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-mes-subsystem': 'familyweb',
  };

  static Future<int> _getStudentId(String token) =>
      get(
        Uri.parse('https://myschool.mosreg.ru/acl/api/users/profile_info'),
        headers: _getHeaders(token)..['Auth-Token'] = token,
      ).then((response) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data[0]['id'];
        } else if (response.statusCode == 401) {
          throw Exception('Invalid token');
        } else {
          throw Exception('Failed to get student ID: ${response.body}');
        }
      });
}
