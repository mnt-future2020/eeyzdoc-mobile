import 'package:dio/dio.dart';

class NoEncodeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final originalQueryParameters = Map<String, dynamic>.from(
      options.queryParameters,
    );
    options.queryParameters.clear();

    if (originalQueryParameters.isNotEmpty) {
      final qp = originalQueryParameters.entries
          .map((e) => "${e.key}=${_decodeValue(e.value)}")
          .join("&");

      options.path = "${options.path}?$qp";
    }

    handler.next(options);
  }

  String _decodeValue(dynamic value) {
    if (value is String) {
      return Uri.decodeComponent(value);
    }
    return value.toString();
  }
}
