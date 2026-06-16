import 'package:flutter/material.dart';
import '../../../data/models/response/work_flow_details_response.dart';

class WorkflowTimeline extends StatelessWidget {
  final List<Node> nodes;
  final List<Link> links;
  final List<CustomColor> colors;

  const WorkflowTimeline({
    super.key,
    required this.nodes,
    required this.links,
    required this.colors,
  });

  Color _getNodeColor(String stepName) {
    final item = colors.firstWhere(
          (c) => c.name?.contains(stepName) ?? false,
      orElse: () => CustomColor(value: "default"),
    );

    switch (item.value) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.red;
      case "inprogress":
        return Colors.orange;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
   return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: nodes.asMap().entries.map((entry) {
      int index = entry.key;
      Node node = entry.value;

      return Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _getNodeColor(node.label ?? ""),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                node.label ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),

          // ---- Line Between Steps ----
          if (index < nodes.length - 1)
            Container(
              width: 40, // line length
              height: 2, // required so it's visible
              margin: const EdgeInsets.only(bottom: 18), // align with circle
              color: Colors.grey.shade400,
            ),
        ],
      );
    }).toList(),
    );
  }
}
