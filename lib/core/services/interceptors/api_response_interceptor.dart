import 'package:dio/dio.dart';
import 'package:docuflow/core/exceptions/api_exceptions.dart';
import 'package:docuflow/core/utils/toast_message.dart';

class ApiResponseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('────────────────────── REQUEST ───────────────────────');
    print('[${options.method}] ${options.uri}');

    if (options.headers.isNotEmpty) {
      print('Headers: ${options.headers}');
    }

    if (options.queryParameters.isNotEmpty) {
      print('Query Params: ${options.queryParameters}');
    }

    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;

        print('── FormData Fields:');
        for (var field in formData.fields) {
          print('  • ${field.key}: ${field.value}');
        }

        print('── FormData Files:');
        for (var file in formData.files) {
          final multipart = file.value;
          print(
            '  • ${file.key}: ${multipart.filename} '
                '(${multipart.length} bytes)',
          );
        }
      } else {
        print('Request Body: ${options.data}');
      }
    }

    print('────────────────────────────────────────────────────────');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('────────────────────── Response ───────────────────────');
    print('[${response.statusCode}] ${response.requestOptions.uri}');
    print('Response: ${response.data}');

    print('────────────────────────────────────────────────────────');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    print('──────────────────────── Error ────────────────────────');
    print('[${statusCode ?? 'No Status'}] ${err.requestOptions.uri}');
    print('Error Message: ${err.message}');

    print('────────────────────────────────────────────────────────');

    if ([401, 403, 407].contains(statusCode)) {
      final ex = ApiException(
        message: "Auth failure",
        statusCode: statusCode ?? 0,
      );
      ToastMessage.show(ex.message);

      return handler.reject(err.copyWith(message: ex.message, error: ex));
    }

    if (data is Map && data['message'] != null) {
      final message = data['message']?.toString() ?? "Something went wrong";
      final ex = ApiException(message: message, statusCode: statusCode ?? 0);

     // ToastMessage.show(ex.message);

      return handler.reject(err.copyWith(message: ex.message, error: ex));
    }

    final fallback = ApiException.fromDioError(err);

    ToastMessage.show(fallback.message);

    return handler.reject(
      err.copyWith(message: fallback.message, error: fallback),
    );
  }
}