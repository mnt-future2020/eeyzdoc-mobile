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

import '../../data/models/request/mail_request.dart';
import '../../data/models/response/mail_response.dart';

class DocumentDetailsUseCase {
  final DocumentDetailsRepository repository;

  DocumentDetailsUseCase(this.repository);

  Future<List<DocumentAuditResponse?>?> getDocumentAudits(
    DocumentAuditRequest request,
  ) {
    return repository.getDocumentAudits(request);
  }

  Future<List<DocumentRolePermissionResponse?>?> getDocumentRolePermissions(
    String documentId,
  ) {
    return repository.getDocumentRolePermissions(documentId);
  }

  Future<List<DocumentVersionHistoryResponse?>?> getDocumentVersionHistory(
    String documentId,
  ) {
    return repository.getDocumentVersionHistory(documentId);
  }

  Future<DocumentDetailsResponse?> getDocumentDetails(String documentId) {
    return repository.getDocumentDetails(documentId);
  }

  Future<List<DocumentWorkflowLogsResponse?>?> getWorkflowLogs(
    DocumentWorkflowLogsRequest request,
  ) {
    return repository.getWorkflowLogs(request);
  }

  Future<List<DocumentReminderResponse?>?> getReminders(
    DocumentReminderRequest request,
  ) {
    return repository.getReminders(request);
  }
  Future<MailResponse?> sendMail(MailRequest request) {
    return repository.sendMail(request);
  }
  Future<SuccessResponse> restoreVersionHistoryApi(String currentVersionId, String changeVersionId) async{
    return repository.restoreVersionHistoryApi(currentVersionId,changeVersionId);
  }

}
