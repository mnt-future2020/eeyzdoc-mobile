import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/document_audit_request.dart';
import 'package:docuflow/data/models/request/document_reminder_request.dart';
import 'package:docuflow/data/models/request/document_workflow_logs_request.dart';
import 'package:docuflow/data/models/response/document_audit_response.dart';
import 'package:docuflow/data/models/response/document_details_response.dart';
import 'package:docuflow/data/models/response/document_reminder_response.dart';
import 'package:docuflow/data/models/response/document_role_permission_response.dart';
import 'package:docuflow/data/models/response/document_version_history_response.dart';
import 'package:docuflow/data/models/response/document_workflow_logs_response.dart';

import '../../models/request/mail_request.dart';
import '../../models/response/mail_response.dart';
import '../../models/response/success_response.dart';

abstract class DocumentDetailsDatasource {
  Future<DocumentDetailsResponse?> getDocumentDetails(String documentId);

  Future<List<DocumentAuditResponse?>?> getDocumentAudits(
    DocumentAuditRequest request,
  );

  Future<List<DocumentRolePermissionResponse?>?> getDocumentRolePermissions(
    String documentId,
  );

  Future<List<DocumentVersionHistoryResponse?>?> getDocumentVersionHistory(
    String documentId,
  );

  Future<SuccessResponse> restoreVersionHistoryApi(String currentVersionId, String changeVersionId);

  Future<MailResponse?> sendMail(MailRequest request);

  //. https://eezydoc.v7testsite.in/api/documentComment/917763cb-e52f-42da-9fa9-b87583d9cfa9
  // Future<List<DocumentCommentsResponse?>?> getDocumentComments(
  //   DocumentCommentsRequest request,
  // );

  // https://eezydoc.v7testsite.in/api/reminder/all?fields=&orderBy=startDate%20desc&pageSize=10&skip=0&searchQuery=&subject=&message=&frequency=&documentId=917763cb-e52f-42da-9fa9-b87583d9cfa9
  Future<List<DocumentReminderResponse?>?> getReminders(
    DocumentReminderRequest request,
  );

  Future<List<DocumentWorkflowLogsResponse?>?> getWorkflowLogs(
    DocumentWorkflowLogsRequest request,
  );
}

class DocumentDetailsDatasourceImpl implements DocumentDetailsDatasource {
  final ApiClient dioClient;

  DocumentDetailsDatasourceImpl(this.dioClient);

  @override
  Future<List<DocumentAuditResponse?>?> getDocumentAudits(
    DocumentAuditRequest request,
  ) async {

    try {
      final response = await dioClient.get(
        AppConstants.documentAuditsList,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => DocumentAuditResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<DocumentDetailsResponse?> getDocumentDetails(String documentId) async {

    try {
      final response = await dioClient.get(
        '${AppConstants.documentDetails}/$documentId',
      );

      return DocumentDetailsResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<DocumentRolePermissionResponse?>?> getDocumentRolePermissions(
    String documentId,
  ) async {

    try {
      final response = await dioClient.get(
        '${AppConstants.shareDocumentRolePermissionApi}/$documentId',
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => DocumentRolePermissionResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<DocumentVersionHistoryResponse?>?> getDocumentVersionHistory(
    String documentId,
  ) async {

    try {
      final response = await dioClient.get(
        '${AppConstants.documentVersionApi}/$documentId',
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => DocumentVersionHistoryResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<DocumentWorkflowLogsResponse?>?> getWorkflowLogs(
    DocumentWorkflowLogsRequest request,
  ) async {

    try {
      final response = await dioClient.get(
        AppConstants.workflowLogs,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => DocumentWorkflowLogsResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<DocumentReminderResponse?>?> getReminders(
    DocumentReminderRequest request,
  ) async {

    try {
      final response = await dioClient.get(
        AppConstants.documentRemaindersList,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => DocumentReminderResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }


  @override
  Future<MailResponse?> sendMail(MailRequest request) async {

    try {
      final response = await dioClient.post(
        AppConstants.sendEmail,
        data: request.toJson(),
      );

      return MailResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<SuccessResponse> restoreVersionHistoryApi(String currentVersionId, String changeVersionId) async{
    try {
      final response = await dioClient.post(
        "${AppConstants.documentVersionApi}/$currentVersionId/restore/$changeVersionId",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          status: "Success",
          message: "Restore successfully",
        );

      } else {
        return SuccessResponse(
          message: "Failed to cancel Restore. Please try again.",
          status: "Failure",
        );
      }
    } catch (e) {
      return SuccessResponse(
        message: "An error occurred. Please try again later.",
        status: "Failure",
      );
    }
  }

}
