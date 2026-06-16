import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/presentation/workflow/pages/CompletedTransitionCard.dart';
import 'package:docuflow/presentation/workflow/pages/WorkflowInfoSection.dart';
import 'package:docuflow/presentation/workflow/pages/WorkflowTimeline.dart';
import 'package:flutter/material.dart';

import '../controllers/work_flow_controller.dart';
import 'package:get/get.dart';


class WorkFlowDetailsPage extends StatelessWidget {
  final WorkFlowDetailsResponse details;

  const WorkFlowDetailsPage({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workflow Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkflowTimeline(
            nodes: details.nodes ?? [],
            links: details.links ?? [],
            colors: details.customColors ?? [],
          ),

          const SizedBox(width: 10),

          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkflowInfoSection(details: details),

                const SizedBox(height: 20),

                const Text(
                  "Completed Transitions",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                ),
                const SizedBox(height: 10),

                ...details.completedWorkflowTransitions?.map(
                      (t) => CompletedTransitionCard(
                    transition: t,
                    colors: details.customColors,
                  ),
                ).toList() ??
                    [],

              ],
            ),
          )
        ],
      ),
    );
  }
}
