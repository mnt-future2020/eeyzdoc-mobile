import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkflowLogsDetailsScreen extends StatefulWidget {
  final String documentId;

  const WorkflowLogsDetailsScreen({super.key, required this.documentId});

  @override
  State<WorkflowLogsDetailsScreen> createState() =>
      _WorkflowLogsDetailsScreenState();
}

class _WorkflowLogsDetailsScreenState extends State<WorkflowLogsDetailsScreen> {
  final controller = Get.find<DocumentDetailsController>();

  @override
  void initState() {
    super.initState();
    controller.loadWorkflowLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWorkLogs.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.workLogList.isEmpty) {
        return const Center(child: Text("No Workflow Logs Found"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.workLogList.length,
        itemBuilder: (context, index) {
          final log = controller.workLogList[index];

          return Card(
            elevation: 4,
            shadowColor: Colors.red.withOpacity(0.25),
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.red.withOpacity(0.45),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- HEADER ----------
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          log.workflowName ?? "Workflow",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ---------- DETAILS ----------
                    _row(context, "Transition", log.transitionName),
                    _row(context, "From Step", log.fromStepName),
                    _row(context, "To Step", log.toStepName),
                    _row(context, "Comment",
                        log.comment?.isEmpty == true ? '-' : log.comment),
                    _row(context, "Created By", log.createdByName),

                    if (log.createdDate != null)
                      _row(
                        context,
                        "Date",
                        DateFormat("dd-MM-yyyy hh:mm a")
                            .format(log.createdDate!),
                      ),
                  ],
                ),
              ),
            ),
          );

        },
      );
    });
  }

  Widget _row(BuildContext context, String title, String? value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$title:",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
