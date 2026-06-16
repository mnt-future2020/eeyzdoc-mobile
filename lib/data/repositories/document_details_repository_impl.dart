import 'package:docuflow/data/datasources/remote/document_details_datasource.dart';
import 'package:docuflow/data/models/request/document_audit_request.dart';
import 'package:docuflow/data/models/request/document_reminder_request.dart';
import 'package:docuflow/data/models/request/document_workflow_logs_request.dart';
import 'package:docuflow/data/models/response/document_audit_response.dart';
import 'package:docuflow/data/models/response/document_details_response.dart';
import 'package:docuflow/data/models/response/document_reminder_response.dart';
import 'package:docuflow/data/models/response/document_role_permission_response.dart';
import 'package:docuflow/data/models/response/document_version_history_response.dart';
import 'package:docuflow/data/models/response/document_workflow_logs_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/document_details_repository.dart';

import '../models/request/mail_request.dart';
import '../models/response/mail_response.dart';

class DocumentDetailsRepositoryImpl implements DocumentDetailsRepository {
  final DocumentDetailsDatasource remoteDataSource;

  DocumentDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DocumentAuditResponse?>?> getDocumentAudits(
    DocumentAuditRequest request,
  ) async {
    final responseList = await remoteDataSource.getDocumentAudits(request);

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList
        .whereType<DocumentAuditResponse>()
        .toList();
    return cleanedList;
  }

  @override
  Future<DocumentDetailsResponse?> getDocumentDetails(String documentId) {
    return remoteDataSource.getDocumentDetails(documentId);
  }

  @override
  Future<List<DocumentRolePermissionResponse?>?> getDocumentRolePermissions(
    String documentId,
  ) async {
    final responseList = await remoteDataSource.getDocumentRolePermissions(
      documentId,
    );

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList
        .whereType<DocumentRolePermissionResponse>()
        .toList();
    return cleanedList;
  }

  @override
  Future<List<DocumentVersionHistoryResponse?>?> getDocumentVersionHistory(
    String documentId,
  ) async {
    final responseList = await remoteDataSource.getDocumentVersionHistory(
      documentId,
    );

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList
        .whereType<DocumentVersionHistoryResponse>()
        .toList();
    return cleanedList;
  }

  @override
  Future<List<DocumentWorkflowLogsResponse?>?> getWorkflowLogs(
    DocumentWorkflowLogsRequest request,
  ) async {
    final responseList = await remoteDataSource.getWorkflowLogs(request);

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList
        .whereType<DocumentWorkflowLogsResponse>()
        .toList();
    return cleanedList;
  }

  @override
  Future<List<DocumentReminderResponse?>?> getReminders(
    DocumentReminderRequest request,
  ) async {
    final responseList = await remoteDataSource.getReminders(request);

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList
        .whereType<DocumentReminderResponse>()
        .toList();
    return cleanedList;
  }
  @override
  Future<MailResponse?> sendMail(MailRequest request) {
    return remoteDataSource.sendMail(request);
  }

  @override
  Future<SuccessResponse> restoreVersionHistoryApi(String currentVersionId, String changeVersionId) {
    return remoteDataSource.restoreVersionHistoryApi(currentVersionId,changeVersionId);
  }
}
