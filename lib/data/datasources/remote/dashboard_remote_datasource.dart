import 'package:dio/dio.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:flutter/material.dart';

import '../../../constants/PreferenceUtils.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/response/DocumentCategory.dart';
import '../../models/response/document_response.dart';
import '../../models/response/notification_response.dart';

abstract class DashboardRemoteDataSource {
  Future<List<DocumentCategory>> getDocumentByCategory({
    CancelToken? cancelToken,
  });

  Future<List<DocumentResponse>> getRecentDocuments({
    CancelToken? cancelToken,
  });

  Future<List<NotificationResponse>> getNotifications({
    CancelToken? cancelToken,
  });
}


class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient dioClient;

  DashboardRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<DocumentCategory>> getDocumentByCategory({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dioClient.get(
        AppConstants.getDocumentByCategory,
        cancelToken: cancelToken,
      );

      final List data = response.data ?? [];

      return data
          .map((e) => DocumentCategory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("getDocumentByCategory cancelled");
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<List<NotificationResponse>> getNotifications({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dioClient.get(
        AppConstants.notificationsList,
        cancelToken: cancelToken,
      );

      final List data = response.data ?? [];

      return data
          .map((e) => NotificationResponse.fromJson(e))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("getNotifications cancelled");
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<List<DocumentResponse>> getRecentDocuments({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dioClient.get(
        AppConstants.recentDocuments,
        queryParameters: const {"count": 5},
        cancelToken: cancelToken,
      );

      final List data = response.data ?? [];

      return data
          .map((e) => DocumentResponse.fromJson(e))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("getRecentDocuments cancelled");
        return [];
      }
      rethrow;
    }
  }
}



