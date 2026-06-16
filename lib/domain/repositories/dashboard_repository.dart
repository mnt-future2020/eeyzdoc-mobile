import 'package:dio/dio.dart';

import '../../data/models/response/DocumentCategory.dart';
import '../../data/models/response/document_response.dart';
import '../../data/models/response/notification_response.dart';

abstract class DashboardRepository {
  Future<List<DocumentCategory>> getDocumentByCategory({
    CancelToken? cancelToken,
  });

  Future<List<DocumentResponse?>?> getRecentDocuments({
    CancelToken? cancelToken,
  });

  Future<List<NotificationResponse?>?> getNotifications({
    CancelToken? cancelToken,
  });
}
