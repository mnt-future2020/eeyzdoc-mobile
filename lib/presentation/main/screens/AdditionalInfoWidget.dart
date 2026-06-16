import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/response/document_response.dart';
import '../controllers/dashboard_controller.dart';
import 'dashboard_screen.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final String documentId;
  final String fileName;
  final String uploader;
  final String uploadDate;
  final DocumentResponse documentResponse;
  final DashboardController controller;

  const AdditionalInfoWidget({
    super.key,
    required this.documentId,
    required this.fileName,
    required this.uploader,
    required this.uploadDate,
    required this.controller,
    required this.documentResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.insert_drive_file,
              size: 20,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,color: Colors.black
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Uploaded by: $uploader',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
                Text(
                  _formatDate(uploadDate),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  controller.documentsController.selectedDocument.value =
                      documentResponse;
                  controller.documentsController.selectedDocumentId.value =
                      documentId;
                  _showMore(context, documentResponse);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy hh:mm a').format(date.toLocal());
    } catch (e) {
      return isoDate;
    }
  }

  void _showMore(BuildContext context, DocumentResponse documentResponse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => MoreActionsMenu(
       documentResponse: documentResponse,
        flagShow: true,
      ),
    );
  }
}
