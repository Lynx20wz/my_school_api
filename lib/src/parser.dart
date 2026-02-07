import 'dart:convert' show jsonDecode;

import 'package:http/http.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'classes/homework.dart';

const baseUrl = 'https://authedu.mosreg.ru/api';

class Parser {
  final String token;
  late final int studentId;

  Parser._({required this.token, required this.studentId});

  static Future<Parser> create({required String token, int? studentId}) async {
    final id = studentId ?? await _getStudentId(token);
    return Parser._(token: token, studentId: id);
  }

  Future<List<Homework>> getHomework(DateTime from, DateTime to) async {
    if (from.isAfter(to)) {
      throw ArgumentError('Invalid date range');
    }

    final dateFormat = DateFormat('y-MM-dd');

    final response = await get(
      Uri.parse('$baseUrl/family/web/v1/homeworks').replace(
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
      return json.map((e) => Homework.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load homework: ${response.body}');
    }
  }

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

  static Map<String, String> _getHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json;charset=UTF-8',
    'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0',
    'X-mes-subsystem': 'familyweb',
  };
}
