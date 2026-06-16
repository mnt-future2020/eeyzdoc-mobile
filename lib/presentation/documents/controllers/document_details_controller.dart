import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/data/models/request/document_audit_request.dart';
import 'package:docuflow/data/models/request/document_reminder_request.dart';
import 'package:docuflow/data/models/request/document_workflow_logs_request.dart';
import 'package:docuflow/data/models/response/document_audit_response.dart';
import 'package:docuflow/data/models/response/document_details_response.dart';
import 'package:docuflow/data/models/response/document_reminder_response.dart';
import 'package:docuflow/data/models/response/document_role_permission_response.dart';
import 'package:docuflow/data/models/response/document_version_history_response.dart';
import 'package:docuflow/data/models/response/document_workflow_logs_response.dart';
import 'package:docuflow/domain/usecases/document_details_usecase.dart';
import 'package:get/get.dart';

import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/mail_request.dart';
import '../dialog/dialog_widgets.dart';

class DocumentDetailsController extends GetxController {
  final DocumentDetailsUseCase documentDetailsUseCase;

  DocumentDetailsController({required this.documentDetailsUseCase});

  final routerController = Get.find<RouterController>();

  var isLoadingDetails = false.obs;
  var isLoadingAudits = false.obs;
  var isLoadingPermissions = false.obs;
  var isLoadingWorkLogs = false.obs;
  var isLoadingReminders = false.obs;
  var isLoadingVersionHistory = false.obs;

  Rx<DocumentDetailsResponse?> documentDetails = Rx(null);
  RxList<DocumentAuditResponse> auditList = <DocumentAuditResponse>[].obs;
  RxList<DocumentRolePermissionResponse> permissions =
      <DocumentRolePermissionResponse>[].obs;
  RxList<DocumentVersionHistoryResponse> versionHistory =
      <DocumentVersionHistoryResponse>[].obs;
  RxList<DocumentReminderResponse> remindersList =
      <DocumentReminderResponse>[].obs;
  RxList<DocumentWorkflowLogsResponse> workLogList =
      <DocumentWorkflowLogsResponse>[].obs;

  Future<void> loadDocumentDetails(String documentId) async {
    try {
      isLoadingDetails.value = true;

      final result = await documentDetailsUseCase.getDocumentDetails(
        documentId,
      );

      documentDetails.value = result;
    } catch (e) {
      print("Error loading document details: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> loadDocumentAudits() async {
    try {
      isLoadingAudits.value = true;

      final DocumentAuditRequest request = DocumentAuditRequest(
        documentId: documentDetails.value?.id ?? "",
        pageNumber: 1,
        pageSize: 50,
      );

      final result = await documentDetailsUseCase.getDocumentAudits(request);

      auditList.assignAll((result ?? []).whereType<DocumentAuditResponse>());
    } catch (e) {
      print("Error loading audits: $e");
    } finally {
      isLoadingAudits.value = false;
    }
  }

  Future<void> loadReminders() async {
    try {
      isLoadingReminders.value = true;

      final DocumentReminderRequest request = DocumentReminderRequest(
        documentId: documentDetails.value?.id ?? "",
        pageNumber: 1,
        pageSize: 50,
      );

      final result = await documentDetailsUseCase.getReminders(request);

      remindersList.assignAll(
        (result ?? []).whereType<DocumentReminderResponse>(),
      );
    } catch (e) {
      print("Error loading audits: $e");
    } finally {
      isLoadingReminders.value = false;
    }
  }

  Future<void> loadWorkflowLogs() async {
    try {
      isLoadingWorkLogs.value = true;

      final DocumentWorkflowLogsRequest request = DocumentWorkflowLogsRequest(
        documentId: documentDetails.value?.id ?? "",
        pageNumber: 1,
        pageSize: 50,
      );

      final result = await documentDetailsUseCase.getWorkflowLogs(request);

      workLogList.assignAll(
        (result ?? []).whereType<DocumentWorkflowLogsResponse>(),
      );
    } catch (e) {
      print("Error loading audits: $e");
    } finally {
      isLoadingWorkLogs.value = false;
    }
  }

  Future<void> loadDocumentPermissions(String documentId) async {
    try {
      isLoadingPermissions.value = true;

      final result = await documentDetailsUseCase.getDocumentRolePermissions(
        documentId,
      );

      permissions.assignAll(
        (result ?? []).whereType<DocumentRolePermissionResponse>(),
      );
    } catch (e) {
      print("Error loading permissions: $e");
    } finally {
      isLoadingPermissions.value = false;
    }
  }

  Future<void> loadVersionHistory(String documentId) async {
    try {
      isLoadingVersionHistory.value = true;

      final result = await documentDetailsUseCase.getDocumentVersionHistory(
        documentId,
      );

      versionHistory.assignAll(
        (result ?? []).whereType<DocumentVersionHistoryResponse>(),
      );
    } catch (e) {
      print("Error loading version history: $e");
    } finally {
      isLoadingVersionHistory.value = false;
    }
  }


  void restoreVersion(String documentId,String currentVersionId, String changeVersionId) {
    restoreConfirmationDialog(onNo: (){},onYes: (){
      restoreVersionHistoryApi(documentId,documentId,changeVersionId);
    }, title: ' Are you sure you want to restore this to current version??');
  }


  Future<void> restoreVersionHistoryApi(String documentId,String currentVersionId, String changeVersionId) async {
    try {

      final response = await documentDetailsUseCase.restoreVersionHistoryApi(currentVersionId,changeVersionId);
      if (response.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        versionHistory.value.clear();
        loadVersionHistory(documentId);
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {}
  }
  Future<bool> sendMail(MailRequest request) async {
    try {
      final result = await documentDetailsUseCase.sendMail(request);

      if (result != null && result.documentId != "") {
        print("Mail sent successfully.");
        return true;
      } else {
        print("Failed to send mail.");
        return false;
      }
    } catch (e) {
      print("Error sending mail: $e");
      return false;
    }
  }
  @override
  void onClose() {
    super.onClose();
  }
}
