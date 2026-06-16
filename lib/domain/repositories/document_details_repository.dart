import 'package:docuflow/data/models/request/document_audit_request.dart';
import 'package:docuflow/data/models/request/document_reminder_request.dart';
import 'package:docuflow/data/models/request/document_workflow_logs_request.dart';
import 'package:docuflow/data/models/response/document_audit_response.dart';
import 'package:docuflow/data/models/response/document_details_response.dart';
import 'package:docuflow/data/models/response/document_reminder_response.dart';
import 'package:docuflow/data/models/response/document_role_permission_response.dart';
import 'package:docuflow/data/models/response/document_version_history_response.dart';
import 'package:docuflow/data/models/response/document_workflow_logs_response.dart';

import '../../data/models/request/mail_request.dart';
import '../../data/models/response/mail_response.dart';
import '../../data/models/response/success_response.dart';

abstract class DocumentDetailsRepository {
  Future<List<DocumentAuditResponse?>?> getDocumentAudits(
    DocumentAuditRequest request,
  );
  Future<List<DocumentRolePermissionResponse?>?> getDocumentRolePermissions(
    String documentId,
  );
  Future<List<DocumentVersionHistoryResponse?>?> getDocumentVersionHistory(
    String documentId,
  );
  Future<DocumentDetailsResponse?> getDocumentDetails(String documentId);
  Future<List<DocumentWorkflowLogsResponse?>?> getWorkflowLogs(
    DocumentWorkflowLogsRequest request,
  );

  Future<List<DocumentReminderResponse?>?> getReminders(
    DocumentReminderRequest request,
  );
  Future<MailResponse?> sendMail(MailRequest request);

  Future<SuccessResponse> restoreVersionHistoryApi(String currentVersionId, String changeVersionId);

}
