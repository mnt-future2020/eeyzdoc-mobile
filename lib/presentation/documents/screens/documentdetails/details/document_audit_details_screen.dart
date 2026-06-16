import 'package:docuflow/data/models/response/document_audit_response.dart';
import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DocumentAuditDetailsScreen extends StatefulWidget {
  final String documentId;

  const DocumentAuditDetailsScreen({super.key, required this.documentId});

  @override
  State<DocumentAuditDetailsScreen> createState() =>
      _DocumentAuditDetailsScreenState();
}

class _DocumentAuditDetailsScreenState
    extends State<DocumentAuditDetailsScreen> {
  late final DocumentDetailsController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<DocumentDetailsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDocumentAudits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAudits.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.auditList.isEmpty) {
        return const Center(child: Text("No Audit Records Found"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.auditList.length,
        itemBuilder: (context, index) {
          final audit = controller.auditList[index];
          return _auditCard(audit);
        },
      );
    });
  }
  Widget _auditCard(DocumentAuditResponse audit) {
    Color opColor;
    switch (audit.operationName?.toLowerCase()) {
      case "create":
        opColor = Colors.green;
        break;
      case "update":
        opColor = Colors.orange;
        break;
      case "delete":
        opColor = Colors.red;
        break;
      case "read":
        opColor = Colors.blue;
        break;
      default:
        opColor = Colors.grey.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 1,
            color: opColor.withOpacity(0.20),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Header ----------
        Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            colors: [Colors.red.shade800, Colors.red.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                audit.operationName ?? "Operation",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),

          // ---------- Body ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row(Icons.lock_outline, "Permission (User)", audit.permissionUser),
                _row(Icons.shield_outlined, "Permission (Role)", audit.permissionRole),
                audit.createdDate==null?SizedBox.shrink(): _row(Icons.calendar_month, "Created Date", DateFormat('dd-MM-yyyy hh:mm a').format(audit.createdDate!.toLocal())),
                _row(Icons.person, "Created By", audit.createdBy),
                _row(Icons.edit, "Modified By", audit.modifiedBy),

                if (audit.deletedBy != null && audit.deletedBy!.isNotEmpty)
                  _row(Icons.delete_forever, "Deleted By", audit.deletedBy),

                if (audit.deletedAt != null)
                  _row(Icons.schedule, "Deleted At", audit.deletedAt?.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _row(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.blueGrey),
          ),
          const SizedBox(width: 10),

          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value ?? "—",
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

}
