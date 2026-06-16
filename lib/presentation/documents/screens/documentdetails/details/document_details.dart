import 'package:docuflow/data/models/request/CommentArgs.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/comments_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/comments_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/document_audit_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/general_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/permission_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/remainders_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/version_history_details_screen.dart';
import 'package:docuflow/presentation/documents/screens/documentdetails/details/workflow_logs_details_screen.dart';
import 'package:flutter/material.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentResponse documentResponse;

  const DocumentDetailsScreen({super.key, required this.documentResponse});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> tabs = const [
    "General",
    "Permission",
    "Version History",
    "Comments",
    "Document Audit",
    "Reminders",
    "Workflow Logs",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),

          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          GeneralDetailsScreen(documentId: widget.documentResponse.id),
          PermissionDetailsScreen(documentId:widget.documentResponse.id),
          VersionHistoryDetailsScreen(documentId: widget.documentResponse.id,documentName: widget.documentResponse.name,),
          CommentsScreen(commentArgs: CommentArgs(documentId: widget.documentResponse.id, documentName: widget.documentResponse.name, flagAppbar: false)),
          DocumentAuditDetailsScreen(documentId: widget.documentResponse.id),
          RemaindersDetailsScreen(documentId: widget.documentResponse.id),
          WorkflowLogsDetailsScreen(documentId: widget.documentResponse.id),
        ],
      ),
    );
  }
}
