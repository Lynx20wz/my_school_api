/// Base exception for all My School API errors.
///
/// All exceptions thrown by [MySchoolApi] extend this class.
///
/// Example:
/// ```dart
/// try {
///   final api = await MySchoolApi.init('TOKEN');
/// } on MySchoolApiException catch (e) {
///   print('API error: $e');
/// }
/// ```
abstract class MySchoolApiException implements Exception {
  final String message;

  const MySchoolApiException(this.message);

  @override
  String toString() => 'MySchoolApiException: $message';
}

/// Exception thrown when authentication fails.
///
/// Typically means the token is invalid, expired, or missing.
class AuthenticationException extends MySchoolApiException {
  /// HTTP status code returned by the server.
  final int statusCode;

  const AuthenticationException(super.message, {required this.statusCode});

  @override
  String toString() =>
      'AuthenticationException (status: $statusCode): $message';
}

/// Exception thrown when the student ID cannot be retrieved.
///
/// May occur if the API returns an unexpected format or the user has no student accounts.
class StudentIdNotFoundException extends MySchoolApiException {
  const StudentIdNotFoundException(super.message);
}

/// Exception thrown when an API request fails for reasons other than authentication.
///
/// Includes server errors (5xx), client errors (4xx), and network issues.
class ApiRequestException extends MySchoolApiException {
  /// HTTP status code returned by the server.
  final int statusCode;

  /// Requested URL.
  final String url;

  /// Response body, if available.
  final String? responseBody;

  const ApiRequestException(
    super.message, {
    required this.statusCode,
    required this.url,
    this.responseBody,
  });

  @override
  String toString() {
    final buffer = StringBuffer(
      'ApiRequestException (status: $statusCode): $message',
    );
    if (responseBody != null && responseBody!.isNotEmpty) {
      buffer.write('\nResponse: $responseBody');
    }
    return buffer.toString();
  }
}

/// Exception thrown when an invalid date range is provided.
///
/// Occurs when [from] is after [to].
class InvalidDateRangeException extends MySchoolApiException {
  /// Start date that was provided.
  final DateTime from;

  /// End date that was provided.
  final DateTime to;

  const InvalidDateRangeException(
    super.message, {
    required this.from,
    required this.to,
  });

  @override
  String toString() =>
      'InvalidDateRangeException: $message (from: $from, to: $to)';
}

/// Exception thrown when an invalid mark value is provided.
///
/// Thrown when a mark outside the valid range (2, 3, 4, 5) is encountered.
class InvalidMarkValueException extends MySchoolApiException {
  /// Invalid mark value that was provided.
  final int mark;

  const InvalidMarkValueException(super.message, {required this.mark});

  @override
  String toString() => 'InvalidMarkValueException: $message (mark: $mark)';
}
