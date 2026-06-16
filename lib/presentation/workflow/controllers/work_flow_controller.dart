import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/core/utils/toast_message.dart';
import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/presentation/documents/dialog/dialog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/workflow_comment_request.dart';
import '../../../data/models/response/StartWorkflowResponse.dart';
import '../../../data/models/response/work_flow_response.dart';
import '../../../domain/usecases/reminder_usecase.dart';
import 'package:go_router/go_router.dart'; // ADD THIS

class WorkFlowController extends GetxController {
  final WorkFlowUseCase workFlowUseCase;

  RxList<WorkFlowResponse?> workFlowResponseList = <WorkFlowResponse>[].obs;

  var workFLowDetailsResponse = Rxn<WorkFlowDetailsResponse>();

  WorkFlowController({required this.workFlowUseCase});

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  bool isOpeningWorkflow = false;

  int pageSize = 10;
  int skip = 0;
  bool hasMoreData = true;
  final routerController = Get.find<RouterController>();
  final documentController = Get.find<DocumentsController>();
  var documentNameCtrl = TextEditingController();
  var workflowNameCtrl = TextEditingController();
  var searchCtrl = TextEditingController();
  var selectedStatus = "".obs; // "" = no filter
  var statusList = [
    "--None--",
    "Initiated",
    "InProgress",
    "Completed",
    "Cancelled",
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getWorkFLowList({bool isLoadMoreRequest = false}) async {
    if (isLoadMoreRequest) {
      if (!hasMoreData) return; // No need to call API if no more data
      isLoadMore.value = true;
    } else {
      skip = 0;
      hasMoreData = true;
      isLoading.value = true;
      workFlowResponseList.clear();
    }

    try {
      final request = DocumentWorkflowRequest(
        fields: "",
        orderBy: "modifiedDate desc",
        pageSize: pageSize,
        skip: skip,
        searchQuery: searchCtrl.text.trim(),
        documentName: documentNameCtrl.text.trim(),
        workflowName: workflowNameCtrl.text.trim(),
        status: selectedStatus.value,
      );

      final response =
          await workFlowUseCase.getWorkFLowRequestApi(request) ?? [];

      if (response.isNotEmpty) {
        workFlowResponseList.addAll(response.whereType<WorkFlowResponse>());
        skip += pageSize;
      } else {
        hasMoreData = false;
      }
    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false; // Reset load more flag
    }
  }

  Future<void> getMyWorkFLowList() async {
    isLoading.value = true;
    workFlowResponseList.clear(); // Clear old data
    try {
      final response = await workFlowUseCase.getMyWorkFLowApi() ?? [];

      // Filter out null items
      workFlowResponseList.value = response
          .whereType<WorkFlowResponse>()
          .toList();

      print("WorkFlowResponseList ${workFlowResponseList.length}");
    } catch (e, st) {
      print("WorkFlow error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelWorkflow(String workflowId, String comment) async {
    try {
      final response = await workFlowUseCase.cancelWorkflow(
        workflowId,
        comment,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        workFlowResponseList.value.clear();
        getWorkFLowList();
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {}
  }

  Future<void> performTransitionCommentsAdd(
    WorkflowCommentRequest workflowCommentRequest,
  ) async {
    try {
      final response = await workFlowUseCase.workflowCommentsApi(
        workflowCommentRequest,
      );

      if (response!.status == "Success") {
        ScaffoldMessageShow.show(response.message ?? '');
        workFlowResponseList.value.clear();
        getWorkFLowList();
      } else {
        ScaffoldMessageShow.show(response.message ?? '');
      }
    } catch (e) {
      ScaffoldMessageShow.show(e.toString());
    } finally {}
  }

  Future<void> getWorkFLowDetailsRequest(String documentId) async {
    isLoading.value = true;
    try {
      print("Work Flow Id : $documentId");
      workFLowDetailsResponse.value = await workFlowUseCase
          .getWorkFLowDetailsRequestApi(documentId);
      print(
        "WorkFLowDetailsResponse ${workFLowDetailsResponse.value!.workflowId ?? ''}",
      );
      viewWorkflowDetailsResponse(workFLowDetailsResponse.value);
    } catch (e, st) {
      print("WorkFlow Details error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }

  void resetPagination() {
    skip = 0;
    hasMoreData = true;
    workFlowResponseList.clear();
  }

  void viewWorkflow(String? workFlowId) async {
    await getWorkFLowDetailsRequest(workFlowId ?? '');
  }

  void viewWorkflowDetailsResponse(WorkFlowDetailsResponse? item) {
    final router = Get.find<RouterController>().router;

    if (isOpeningWorkflow) {
      router.push(AppScreens.workFlowsDetailsScreen, extra: item);
    } else {
      router.pushReplacement(AppScreens.workFlowsDetailsScreen, extra: item);
    }
  }

  void openWorkflowSteps(WorkFlowResponse item) {
    showWorkFLowCommentDialog(
      title:
          " Are you sure you want to proceed with this workflow transition ?:: ${item.workflowName} ?",
      onYes: (comment) {
        var workflowCommentRequest = WorkflowCommentRequest(
          comment: comment,
          documentId: item.documentId,
          documentWorkflowId: item.id,
          transitionId: item.nextTransitions![0].id,
        );
        performTransitionCommentsAdd(workflowCommentRequest);
      },
      onNo: () {
        print("User cancelled");
      },
    );
  }

  void moreOptions(WorkFlowResponse item) {
    Get.bottomSheet(
      Container(
        height: 200,
        color: Colors.white,
        child: const Center(child: Text("More options coming soon...")),
      ),
    );
  }

  void resetFilters(bool myWorkFlow) {
    searchCtrl.clear();
    documentNameCtrl.clear();
    workflowNameCtrl.clear();
    selectedStatus.value = "";
    if (myWorkFlow) {
      getMyWorkFLowList();
    } else {
      getWorkFLowList();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
