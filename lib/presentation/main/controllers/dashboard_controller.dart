import 'package:dio/dio.dart';
import 'package:docuflow/presentation/documents/bindings/documents_binding.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/presentation/main/bindings/dashboard_binding.dart';
import 'package:docuflow/presentation/workflow/bindings/work_flow_binding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:docuflow/domain/usecases/dashboard_usecase.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/response/DocumentCategory.dart';
import '../../../data/models/response/document_response.dart';
import '../../../data/models/response/notification_response.dart';
import '../../../data/models/response/work_flow_response.dart';
import '../../documents/dialog/dialog_widgets.dart';
import '../../filerequest/controllers/file_request_controller.dart';
import '../../workflow/controllers/work_flow_controller.dart';

class DashboardController extends GetxController {
  final DashboardUseCase dashboardUseCase;

  DashboardController({required this.dashboardUseCase});
  CancelToken? _cancelToken;

  RxList<DocumentCategory> chartData = <DocumentCategory>[].obs;
  RxList<DocumentResponse> documentsList = <DocumentResponse>[].obs;
  RxList<NotificationResponse> notifications = <NotificationResponse>[].obs;
  final RouterController routerController = Get.find<RouterController>();

  final DocumentsController documentsController =
      Get.find<DocumentsController>();
  RxList<Map<String, dynamic>> cards = <Map<String, dynamic>>[].obs;
  var isNotificationsLoading = false.obs;
  final WorkFlowController workFlowController = Get.find<WorkFlowController>();

  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
    Colors.indigo,
  ];

  final List<IconData> icons = [
    Icons.category,
    Icons.insert_drive_file,
    Icons.description,
    Icons.assignment,
    Icons.folder_open,
    Icons.insert_drive_file,
    Icons.person,
  ];

  Future<void> getDocumentByCategory() async {
    try {
      final List<DocumentCategory> result = await dashboardUseCase.getDocumentByCategory();

      chartData.assignAll(result);

      cards.assignAll(
        result.asMap().entries.map((entry) {
          final index = entry.key;
          final cat = entry.value;

          return {
            'icon': icons[index % icons.length],
            'color': colors[index % colors.length],
            'label': cat.categoryName,
            'value': cat.documentCount.toString(),
          };
        }).toList(),
      );

      debugPrint("chartData length: ${chartData.length}");
    } catch (e, st) {
      debugPrint("chartData error: $e\n$st");
    }
  }


  @override
  void onInit() {
    super.onInit();
   // WorkFlowBinding().dependencies();
  }

  Future<void> loadDashboard() async {
    _cancelToken?.cancel("Dashboard reload");
    _cancelToken = CancelToken();

    try {
      isNotificationsLoading.value = true;

      final categoriesFuture = dashboardUseCase.getDocumentByCategory(cancelToken: _cancelToken);
      final documentsFuture = dashboardUseCase.getRecentDocuments(cancelToken: _cancelToken);
      final notificationsFuture = dashboardUseCase.getNotifications(cancelToken: _cancelToken);

      final categories = await categoriesFuture;
      final documents = await documentsFuture;
      final notifs = await notificationsFuture;
      chartData.assignAll(categories);

      cards.value = chartData.asMap().entries.map((entry) {
        final index = entry.key;
        final cat = entry.value;

        return {
          'icon': icons[index % icons.length],
          'color': colors[index % colors.length],
          'label': cat.categoryName,
          'value': cat.documentCount.toString(),
        };
      }).toList();

      // ---------- Recent Documents ----------
      documentsList.assignAll((documents ?? []).whereType<DocumentResponse>());
      notifications.assignAll((notifs ?? []).whereType<NotificationResponse>());

    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("Dashboard request cancelled");
        return;
      }
      debugPrint("Dashboard error: $e");
    } finally {
      isNotificationsLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadDashboard();
  }

  Future<void> getRecentDocumentList() async {
    documentsList.value.clear();
    try {
     var data = await dashboardUseCase.getRecentDocuments() ?? [];
     documentsList.assignAll((data ?? []).whereType<DocumentResponse>());

    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      //isLoading.value = false;
    }
  }

  Future<void> getNotifications() async {
    try {
      isNotificationsLoading.value = true;

      final result = await dashboardUseCase.getNotifications(cancelToken: _cancelToken);

      notifications.assignAll((result ?? []).whereType<NotificationResponse>());
    } catch (e) {
      print("Error loading notifications: $e");
    } finally {
      isNotificationsLoading.value = false;
    }
  }

  RxBool showNotifications = false.obs;
  final GlobalKey notificationKey = GlobalKey();

  void toggleNotifications() {
    showNotifications.value = !showNotifications.value;
  }

  void hideNotifications() {
    if (showNotifications.value) {
      showNotifications.value = false;
    }
  }

  RxInt selectedFileIndex = (-1).obs;

  void toggleFileInfo(int index) {
    if (selectedFileIndex.value == index) {
      selectedFileIndex.value = -1;
    } else {
      selectedFileIndex.value = index;
    }
  }

  void documentDelete(
    String documentId,
    String title,
    String body,
    String type,
    DocumentsController controller,
    bool recentFile,
  ) {
    showDocumentDeleteDialog(
      onNo: () {},
      onYes: () {
        deleteDocumentApi(
          documentId: documentId,
          documentType: type,
          controller: controller,
          recentFile: recentFile,
        );
      },
      title: title,
      documentId: documentId,
      body: body,
      type: type,
      controller: controller,
    );
  }

  Future<void> deleteDocumentApi({
    required String documentId,
    required String documentType,
    required DocumentsController controller,
    required bool recentFile,
  }) async {
    try {
      // isLoading.value = true;

      final response = await controller.documentsUseCase.deleteDocumentApi(
        documentId,
        documentType,
      );
      operationAPi(
        documentId: documentId,
        operationName: documentType,
        controller: controller,
        recentFile: recentFile,
      );
      ScaffoldMessageShow.show("${response.message}");
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> operationAPi({
    required String documentId,
    required String operationName,
    required DocumentsController controller,
    required bool recentFile,
  }) async {
    try {
      // isLoading.value = true;

      final response = await controller.documentsUseCase.operationNameApi(
        documentId,
        operationName,
      );

      if (response.status == "Success") {
        selectedFileIndex.value = -1;

        if (recentFile) {
          getRecentDocumentList();
        } else {
          controller.getDocuments();
        }
        Get.back();
      } else {
        ScaffoldMessageShow.show("${response.message}");
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {
      // isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _cancelToken?.cancel("Dashboard disposed");
    super.onClose();
  }
}
