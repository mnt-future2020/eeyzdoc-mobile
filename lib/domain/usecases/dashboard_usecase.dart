import 'package:dio/dio.dart';
import 'package:docuflow/domain/repositories/dashboard_repository.dart';

import '../../data/models/response/DocumentCategory.dart';
import '../../data/models/response/document_response.dart';
import '../../data/models/response/notification_response.dart';

class DashboardUseCase {
  final DashboardRepository repository;

  DashboardUseCase(this.repository);

  Future<List<DocumentCategory>> getDocumentByCategory({
    CancelToken? cancelToken,
  }) async {
    return repository.getDocumentByCategory(cancelToken: cancelToken);
  }

  Future<List<NotificationResponse?>?> getNotifications({
    CancelToken? cancelToken,
  }) async {
    return repository.getNotifications(cancelToken: cancelToken);
  }

  Future<List<DocumentResponse?>?> getRecentDocuments({
    CancelToken? cancelToken,
  }) async {
    return repository.getRecentDocuments(cancelToken: cancelToken);
  }
}

