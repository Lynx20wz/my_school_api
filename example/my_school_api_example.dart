import 'package:my_school_api/my_school_api.dart';

void main() async {
  const token = String.fromEnvironment('AUTH_TOKEN');
  final parser = await MySchoolParser.init(token);
  final date = DateTime(2026, 02, 13);

  print(await parser.getMarks(date));
  print(await parser.getHomework(date));
}
