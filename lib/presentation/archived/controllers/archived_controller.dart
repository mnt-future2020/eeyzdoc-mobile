import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/archived_request_query.dart';
import 'package:docuflow/data/models/request/file_request_add.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/archived_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/domain/usecases/archived_usecase.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/domain/usecases/file_request_usecase.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/document_filter_request.dart';
import '../../../data/models/response/file_request_response.dart';
import '../../../data/models/response/work_flow_response.dart';
import '../../../domain/usecases/reminder_usecase.dart';
import 'package:go_router/go_router.dart'; // ADD THIS

class ArchivedController extends GetxController {
  RxList<ArchivedResponse?> archivedList = <ArchivedResponse>[].obs;
  var isLoading = false.obs;
  var isArchiveLoading = false.obs;
  RxInt pageSize = 10.obs;
  int skip = 0;
  bool hasMoreData = true;
  final routerController = Get.find<RouterController>();

  final ArchivedUseCase archivedUseCase;
  final DocumentsUseCase documentsUseCase;
  RxBool isLoadMore = false.obs;

  ArchivedController({
    required this.archivedUseCase,
    required this.documentsUseCase,
  });

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getArchivedRequestList({bool isPagination = false}) async {
    try {
      if (isPagination) {
        isLoadMore.value = true;
      } else {
        skip = 0;
        hasMoreData = true;
        isLoading.value = true;
        archivedList.clear();
      }

      final filter = ArchivedRequestQuery(
        pageSize: pageSize.value,
        skip: skip,
        orderBy: "deletedAt desc",
      );

      final result = await archivedUseCase.getArchivedApi(filter);

      if (result != null && result.isNotEmpty) {
        archivedList.addAll(result.whereType<ArchivedResponse>());
        skip += pageSize.value;
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      debugPrint("Pagination Error: $e");
    } finally {
      if (!isPagination) isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void refreshFirstPage() {
    archivedList.clear();
    getArchivedRequestList();
  }

  Future<void> restore(ArchivedResponse arc, BuildContext context) async {
    _showDocumentDeleteDialog(context, arc.id, arc.name, "", "Restore");
  }

  Future<void> delete(ArchivedResponse arc, BuildContext context) async {
    _showDocumentDeleteDialog(
      context,
      arc.id,
      " Are you sure you want to delete?",
      "By deleting the document, it will no longer be accessible in the future, and the following data will be deleted from the system:\nVersion History\nMeta Tags\nComment\nNotifications\nReminders\nPermissions",
      "Delete",
    );
  }

  void _showDocumentDeleteDialog(
    BuildContext context,
    String documentId,
    String title,
    String body,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text(body),
          actions: [
            TextButton(
              child: const Text("No", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isLoading.value?CircularProgressIndicator(): Text("Yes", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(type=="Delete")
                  {
                    deleteDocumentApi(
                      context: dialogContext,
                      documentId: documentId,
                      documentType: type,
                    );
                  }
                else{
                  restoreDocumentApi(
                    context: dialogContext,
                    documentId: documentId,
                    documentType: type,
                  );
                }

              },
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteDocumentApi({required BuildContext context,required String documentId,required String documentType}) async {
    try {
      isArchiveLoading.value = true;

      final response = await documentsUseCase.deleteDocumentApi(documentId,documentType);
      operationAPi(
        documentId: documentId,
        operationName: documentType,
      );
      ScaffoldMessageShow.show("${response.message}");
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isArchiveLoading.value = false;
    }
  }
  Future<void> restoreDocumentApi({required BuildContext context,required String documentId,required String documentType}) async {
    try {
      isArchiveLoading.value = true;

      final response = await archivedUseCase.sendToRestoreApi(documentId);
      operationAPi(
        documentId: documentId,
        operationName: documentType,
      );
      ScaffoldMessageShow.show("${response.message}");
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isArchiveLoading.value = false;
    }
  }

  Future<void> operationAPi({
    required String documentId,
    required String operationName,
  }) async {
    try {
      isArchiveLoading.value = true;

      final response = await documentsUseCase.operationNameApi(
        documentId,
        operationName,
      );

      if (response.status == "Success") {

          final index = archivedList.indexWhere((d) => d!.id == documentId);
          if (index != -1) {
            archivedList.removeAt(index);
            archivedList.refresh();
          }

      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      isArchiveLoading.value = false;
    }
  }

  void resetForm() {}
}
