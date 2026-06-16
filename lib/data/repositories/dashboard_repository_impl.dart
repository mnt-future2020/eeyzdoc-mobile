import 'package:dio/dio.dart';
import 'package:docuflow/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:docuflow/data/models/response/DocumentCategory.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/domain/repositories/dashboard_repository.dart';

import '../models/response/notification_response.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DocumentCategory>> getDocumentByCategory({CancelToken? cancelToken}) async{
    final response = await remoteDataSource.getDocumentByCategory();
    return response;
  }

  @override
  Future<List<NotificationResponse?>?> getNotifications({CancelToken? cancelToken}) async{
    final responseList = await remoteDataSource.getNotifications();

    if (responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<NotificationResponse>().toList();
    return cleanedList;
  }

  @override
  Future<List<DocumentResponse?>?> getRecentDocuments({CancelToken? cancelToken}) async{
    final responseList = await remoteDataSource.getRecentDocuments();

    if (responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<DocumentResponse>().toList();
    return cleanedList;
  }

}
