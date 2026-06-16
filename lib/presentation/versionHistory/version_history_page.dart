import 'package:docuflow/data/models/response/document_response.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../documents/screens/documentdetails/details/version_history_details_screen.dart';

class VersionHistoryPage extends StatelessWidget {
  final DocumentResponse documentResponse;
  const VersionHistoryPage({super.key, required this.documentResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Version History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: VersionHistoryDetailsScreen(documentId: documentResponse.id,documentName: documentResponse.name,),
    );
  }
}
