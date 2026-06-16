import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GeneralDetailsScreen extends StatefulWidget {
  final String documentId;

  const GeneralDetailsScreen({super.key, required this.documentId});

  @override
  State<GeneralDetailsScreen> createState() => _GeneralDetailsScreenState();
}

class _GeneralDetailsScreenState extends State<GeneralDetailsScreen> {
  late final DocumentDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DocumentDetailsController>();
    controller.loadDocumentDetails(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingDetails.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final doc = controller.documentDetails.value;

      if (doc == null) {
        return const Center(child: Text("No details available"));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: Colors.red.shade600,
                width: 6,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _detailRow("Name", doc.name),
                _detailRow("Description", doc.description),
                _detailRow("Category", doc.categoryName),
                _detailRow("Location", doc.location),
                _detailRow("Company", doc.companyName),
                _detailRow("Status", doc.statusName),
                _detailRow("Created By", doc.createdByName),
                _detailRow("Updated By", doc.updatedByName),

                doc.createdDate != null
                    ? _detailRow(
                  "Created Date",
                  DateFormat('dd-MM-yyyy hh:mm a').format(doc.createdDate!.toLocal()),
                )
                    : const SizedBox.shrink(),

                doc.modifiedDate != null
                    ? _detailRow(
                  "Modified Date",
                  DateFormat('dd-MM-yyyy hh:mm a').format(doc.modifiedDate!.toLocal()),
                )
                    : const SizedBox.shrink(),

                _detailRow("Retention Period", doc.retentionPeriod?.toString()),
                _detailRow("Retention Action", doc.retentionAction?.toString()),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  value ?? "—",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            height: 1,
            color: Colors.red.withOpacity(0.15),
          )
        ],
      ),
    );
  }
}
