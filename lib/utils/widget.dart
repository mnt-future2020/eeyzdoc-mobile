import 'package:flutter/material.dart';

Widget buildWorkflowIcon(String fileName,BuildContext context) {
  final icon = getFileIcon(fileName);
  final color = getFileColor(fileName);
  final cs = Theme.of(context).colorScheme;
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: cs.brightness == Brightness.dark
          ? color.withOpacity(0.45)
          : color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, size: 20, color: color),
  );

}

Widget buildStatusBadge(String status) {
  final color = getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(status,
        style: const TextStyle(fontSize: 10, color: Colors.white)),
  );
}

Widget detailChip(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    ),
  );
}

Color getStatusColor(String status) {
  switch (status.trim().toLowerCase()) {
    case "new file":
      return Colors.green;
    case "initiated":
    case "in progress":
      return Colors.orange;
    case "failed":
    case "under review":
      return Colors.red;
    default:
      return Colors.blue;
  }
}

IconData getFileIcon(String fileName) {
  final extension = fileName.toLowerCase().split('.').last;
  switch (extension) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'xls':
    case 'xlsx':
      return Icons.table_chart;
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
      return Icons.image;
    case 'txt':
      return Icons.text_fields;
    default:
      return Icons.insert_drive_file;
  }

}

Color getFileColor(String fileName) {
  final extension = fileName.toLowerCase().split('.').last;
  switch (extension) {
    case 'pdf':
      return Colors.red;
    case 'doc':
    case 'docx':
      return Colors.blue;
    case 'xls':
    case 'xlsx':
      return Colors.green;
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

