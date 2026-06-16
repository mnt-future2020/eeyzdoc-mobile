import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/response/work_flow_details_response.dart';

class CompletedTransitionCard extends StatelessWidget {
  final CompletedWorkflowTransition transition;
  final List<CustomColor>? colors;

  const CompletedTransitionCard({
    super.key,
    required this.transition,
    this.colors,
  });

  Color _getStatusColor() {
    final color = colors?.firstWhere(
          (c) => c.name == transition.name,
      orElse: () => CustomColor(value: "completed"),
    );
    return color?.value == "pending"
        ? Colors.red
        : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: _getStatusColor()),
                const SizedBox(width: 8),
                Text(
                  transition.name ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  "Completed",
                  style: TextStyle(color: _getStatusColor()),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text("${transition.fromStepName??''}  ➜  ${transition.toStepName}"),
            const SizedBox(height: 4),
            Text("Performed By: ${transition.createdBy ?? '-'}"),
            Text("Date: ${DateFormat('dd-MM-yyyy HH:mm a').format(transition.createdDate!)??'-'} "),
            Text("Comment: ${transition.comment ?? '-'}"),
          ],
        ),
      ),
    );
  }
}
