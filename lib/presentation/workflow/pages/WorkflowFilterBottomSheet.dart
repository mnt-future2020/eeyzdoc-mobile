import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/work_flow_controller.dart';

class WorkflowFilterBottomSheet extends StatelessWidget {
  final bool myWorkFlow;
  const WorkflowFilterBottomSheet({super.key, required this.myWorkFlow});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkFlowController>();

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filter Workflows",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: controller.searchCtrl,
              decoration: const InputDecoration(
                labelText: "Search (all fields)",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => controller.getWorkFLowList(),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: controller.documentNameCtrl,
              decoration: const InputDecoration(
                labelText: "Search by Document Name",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => controller.getWorkFLowList(),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: controller.workflowNameCtrl,
              decoration: const InputDecoration(
                labelText: "Search by Workflow Name",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => controller.getWorkFLowList(),
            ),
            const SizedBox(height: 10),

            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedStatus.value.isEmpty
                    ? null
                    : controller.selectedStatus.value,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: controller.statusList
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedStatus.value = value ?? "";
                  controller.getWorkFLowList();
                },
              );
            }),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Close",
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => controller.resetFilters(myWorkFlow),
                  child: const Text(
                    "Reset All",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

  }

}
