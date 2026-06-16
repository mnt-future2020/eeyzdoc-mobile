import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkflowInfoSection extends StatelessWidget {
  final WorkFlowDetailsResponse details;
  const WorkflowInfoSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Name", details.workflowName),
            _infoRow("Description", details.workflowDescription),
            _infoRow("Created By", details.createdBy),
            _infoRow("Initiated By", details.initiatedBy),
            _infoRow("Created Date", DateFormat('dd-MM-yyyy HH:mm a').format(details.createdDate!.toLocal())),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }
}
