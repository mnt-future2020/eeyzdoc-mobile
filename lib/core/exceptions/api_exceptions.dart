import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  static const Map<int, String> httpStatusMessages = {
    // Information responses
    100: 'Continue',
    101: 'Switching Protocols',
    102: 'Processing (WebDAV)',
    103: 'Early Hints',
    // Success responses
    200: 'OK',
    201: 'Created',
    202: 'Accepted',
    203: 'Non-Authoritative Information',
    204: 'No Content',
    205: 'Reset Content',
    206: 'Partial Content',
    207: 'Multi-Status (WebDAV)',
    208: 'Already Reported (WebDAV)',
    226: 'IM Used',
    // Redirection messages
    300: 'Multiple Choices',
    301: 'Moved Permanently',
    302: 'Found',
    303: 'See Other',
    304: 'Not Modified',
    305: 'Use Proxy',
    306: 'Unused',
    307: 'Temporary Redirect',
    308: 'Permanent Redirect',
    // Client error responses
    400: 'Bad Request',
    401: 'Unauthorized',
    402: 'Payment Required',
    403: 'Forbidden',
    404: 'Page Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Timeout',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Payload Too Large',
    414: 'URI Too Long',
    415: 'Unsupported Media Type',
    416: 'Range Not Satisfiable',
    417: 'Expectation Failed',
    418: "I'm a teapot",
    421: 'Misdirected Request',
    422: 'Unprocessable Content (WebDAV)',
    423: 'Locked (WebDAV)',
    424: 'Failed Dependency (WebDAV)',
    425: 'Too Early',
    426: 'Upgrade Required',
    428: 'Precondition Required',
    429: 'Too Many Requests',
    431: 'Request Header Fields Too Large',
    451: 'Unavailable For Legal Reasons',
    // Server error responses
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    506: 'Variant Also Negotiates',
    507: 'Insufficient Storage (WebDAV)',
    508: 'Loop Detected (WebDAV)',
    510: 'Not Extended',
    511: 'Network Authentication Required',
  };

  static const Map<String, String> customErrorMessages = {
    'TIMEOUT_ERROR': 'Request timed out. Please try again.',
    'PARSING_ERROR': 'Data parsing error. Please contact support.',
    'FETCH_ERROR': 'Network error. Please try again later.',
    'CUSTOM_ERROR': 'An unexpected error occurred. Please try again later.',
  };

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: customErrorMessages['TIMEOUT_ERROR']!,
          statusCode: 408,
        );
      case DioExceptionType.badCertificate:
        return ApiException(message: 'Bad certificate', statusCode: 495);
      case DioExceptionType.badResponse:
        return ApiException(
          message: _handleErrorResponse(error.response),
          statusCode: error.response?.statusCode ?? 400,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled', statusCode: 499);
      case DioExceptionType.connectionError:
        return ApiException(
          message: customErrorMessages['FETCH_ERROR']!,
          statusCode: 503,
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? customErrorMessages['CUSTOM_ERROR']!,
          statusCode: 500,
        );
    }
  }

  static String _handleErrorResponse(Response? response) {
    try {
      if (response?.data != null) {
        if (response?.data is Map) {
          final errorData = response!.data as Map<String, dynamic>;
          if (errorData.containsKey('message')) {
            return errorData['message'];
          }
        } else if (response?.data is String) {
          return response!.data as String;
        }
      }

      return httpStatusMessages[response?.statusCode] ??
          response?.statusMessage ??
          customErrorMessages['CUSTOM_ERROR']!;
    } catch (e) {
      return customErrorMessages['PARSING_ERROR']!;
    }
  }

  @override
  String toString() =>
      'ApiException(message: $message, statusCode: $statusCode)';
}
