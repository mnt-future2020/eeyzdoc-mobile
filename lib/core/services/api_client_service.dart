import 'package:dio/dio.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/exceptions/api_exceptions.dart';
import 'package:docuflow/core/services/interceptors/api_response_interceptor.dart';
import 'package:docuflow/core/services/interceptors/auth_interceptor.dart';
import 'package:docuflow/core/services/interceptors/no_encode_interceptor.dart';
import 'package:docuflow/core/utils/toast_message.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final Dio _dio;
  CancelToken? _cancelToken;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.headers = {'Content-Type': AppConstants.IS_CONTENT_TYPE};
    _dio.interceptors.addAll([
      AuthInterceptor(),
      // NoEncodeInterceptor(),
      LogInterceptor(),
      ApiResponseInterceptor(),
    ]);
  }
  CancelToken _getCancelToken() {
    // Cancel previous request
    _cancelToken?.cancel("Cancelled due to new request");
    _cancelToken = CancelToken();
    return _cancelToken!;
  }

  void cancelAllRequests() {
    _cancelToken?.cancel("Cancelled manually");
  }
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _getCancelToken(),
      );
      return response;
    } on DioException catch (e) {
      ToastMessage.show(ApiException.fromDioError(e).message);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {

      // ✅ THIS IS THE KEY FIX
      if (CancelToken.isCancel(e)) {
        debugPrint('Request cancelled safely: $url');
        throw const _RequestCancelled(); // special marker
      }

      throw ApiException(
        message: e.message ?? 'Something went wrong',
        statusCode: e.response!.statusCode??0,
      );
    }
  }


  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _getCancelToken(),
      );
      return response;
    } on DioException catch (e) {
      ToastMessage.show(ApiException.fromDioError(e).message);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _getCancelToken(),
      );
      return response;
    } on DioException catch (e) {
      ToastMessage.show(ApiException.fromDioError(e).message);
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> getUri(Uri uri, {Options? options}) async {
    try {
      final response = await _dio.getUri(uri, options: options);
      return response;
    } on DioException catch (e) {
      ToastMessage.show(ApiException.fromDioError(e).message);
      throw ApiException.fromDioError(e);
    }
  }
}
class _RequestCancelled implements Exception {
  const _RequestCancelled();
}