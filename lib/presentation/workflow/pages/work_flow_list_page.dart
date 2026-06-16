import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/data/models/response/work_flow_response.dart';
import 'package:docuflow/presentation/workflow/controllers/work_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/scaffold_message.dart';
import '../../../utils/widget.dart';
import 'WorkflowFilterBottomSheet.dart';

class WorkFlowListPage extends StatelessWidget {
  final bool myWorkFlow;

  const WorkFlowListPage({super.key, required this.myWorkFlow});

  @override
  Widget build(BuildContext context) {
    WorkFlowController controller = Get.put(Get.find<WorkFlowController>());
    final RouterController routerController = Get.find<RouterController>();

    return FocusDetector(
      onVisibilityGained: () {
        controller.getWorkFLowList();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:  Text(
            'Work Flow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => routerController.openDrawer(),
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 1,
        ),
        body: Obx(

          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.workFlowResponseList.isEmpty) {
              return const Center(child: Text("No WorkFlow Found",style: TextStyle(color: Colors.black),));
            }
           return _buildWorkFLowList(controller);
          }
        ),
        floatingActionButton: Obx(() {
          return controller.workFlowResponseList.isNotEmpty
              ? FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              Get.bottomSheet(
                WorkflowFilterBottomSheet(myWorkFlow: false,),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              );
            },
          )
              : SizedBox.shrink(); // hide FAB if list is empty
        }),

      ),
    );
  }

  Widget _buildWorkFLowList(WorkFlowController controller) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!controller.isLoadMore.value && controller.hasMoreData) {
          controller.getWorkFLowList(isLoadMoreRequest: true);
        }
      }
    });

    return RefreshIndicator(
      color: Colors.red,
      onRefresh: () async {
        controller.resetPagination();
        if (myWorkFlow) {
          await controller.getMyWorkFLowList();
        } else {
          await controller.getWorkFLowList();
        }
      },
      child: Obx(() {
        final documents = controller.workFlowResponseList;

        return ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: documents.length + 1,
          itemBuilder: (context, index) {
            if (index < documents.length) {
              return buildWorkflowCard(
                context,
                documents[index]!,
                controller,
              );
            } else {
              return controller.isLoadMore.value
                  ? const Padding(
                padding: EdgeInsets.all(15),
                child: Center(child: CircularProgressIndicator()),
              )
                  : const SizedBox();
            }
          },
        );
      }),
    );
  }

  Widget buildWorkflowCard(
    BuildContext context,
    WorkFlowResponse item,
    WorkFlowController controller,
  ) {
    myWorkFlow && item.nextTransitions != null && item.nextTransitions!.isNotEmpty
        ? detailChip(Icons.timeline, item.nextTransitions!.first.fromToStepName ?? '')
        : SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildWorkflowIcon(item.documentName ?? '',context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.documentName ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),
                      Text(
                        item.workflowName ?? '',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                buildStatusBadge(item.status ?? ''),
              ],
            ),

            const SizedBox(height: 12),

            /// DETAILS ROW
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              detailChip(
                Icons.calendar_today,
                "Created: ${item.createdDate != null ? DateFormat('dd-MM-yyyy HH:mm a').format(item.createdDate!.toLocal()) : '-'}",
              ),

              myWorkFlow
                  ? SizedBox.shrink()
                  : detailChip(
                Icons.update,
                "Updated: ${item.modifiedDate != null ? DateFormat('dd-MM-yyyy HH:mm a').format(item.modifiedDate!.toLocal()) : '-'}",
              ),

              myWorkFlow && item.nextTransitions != null && item.nextTransitions!.isNotEmpty
                  ? detailChip(Icons.timeline, item.nextTransitions!.first.fromToStepName ?? '')
                  : SizedBox.shrink(),

              myWorkFlow ? detailChip(Icons.person, item.initiatedBy ?? '') : SizedBox.shrink(),

              myWorkFlow ? SizedBox.shrink() : detailChip(Icons.person, item.createdByName ?? ''),
            ],
          ),

            const SizedBox(height: 12),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.viewWorkflow(item.id),
                    icon: const Icon(
                      Icons.visibility,
                      size: 18,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "View",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                if (!myWorkFlow && item.status != "Cancelled" &&
                    item.nextTransitions != null &&
                    item.nextTransitions!.isNotEmpty)
                  Expanded(
                    child: Builder(
                      builder: (btnContext) {
                        return OutlinedButton.icon(
                          onPressed: () {
                            final RenderBox button =
                                btnContext.findRenderObject() as RenderBox;
                            final RenderBox overlay =
                                Overlay.of(
                                      btnContext,
                                    ).context.findRenderObject()
                                    as RenderBox;

                            final offset = button.localToGlobal(
                              Offset.zero,
                              ancestor: overlay,
                            );

                            showMenu(
                              color: Colors.red,
                              context: btnContext,
                              position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy + button.size.height,
                                overlay.size.width - offset.dx,
                                0,
                              ),
                              items: item.nextTransitions!.map((t) {
                                return PopupMenuItem(
                                  child: Text(
                                    "${t.name} (${t.fromStepName} → ${t.toStepName})",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.white),
                                  ),

                                  onTap: () =>
                                      controller.openWorkflowSteps(item),
                                );
                              }).toList(),
                            );
                          },
                          icon: const Icon(Icons.more_horiz, size: 18),
                          label: const Text("Steps"),
                        );
                      },
                    ),
                  ),
                const SizedBox(width: 8),

                // --- Cancel Button ---
                if (!myWorkFlow &&item.status != "Cancelled")
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        cancelWorkflowDialog(
                          context,
                          item.id!,
                          item.workflowName!,
                          controller,
                        );
                      },
                      icon: const Icon(
                        Icons.cancel,
                        size: 18,
                        color: Colors.red,
                      ),
                      label: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void cancelWorkflowDialog(
  BuildContext context,
  String? workflowId,
  String workflowName,
  WorkFlowController controller,
) {
  if (workflowId == null || workflowId.isEmpty) {
    ScaffoldMessageShow.show('Invalid Workflow Id');
    return;
  }

  TextEditingController commentController = TextEditingController();
  RxBool isError = false.obs;

  Get.dialog(
    Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to Cancel this workflow?\n$workflowName",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Comment"),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter comment",
                ),
              ),
              if (isError.value)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    "Comment is required",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        if (commentController.text.trim().isEmpty) {
                          isError.value = true;
                          return;
                        }
                        Get.back();
                        controller.cancelWorkflow(
                          workflowId,
                          commentController.text.trim(),
                        );
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
