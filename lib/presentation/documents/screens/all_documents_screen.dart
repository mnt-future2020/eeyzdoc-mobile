import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/core/utils/toast_message.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/presentation/documents/bindings/documents_binding.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';

import '../../../core/utils/scaffold_message.dart';
import '../../../utils/widget.dart';
import '../controllers/DocumentFilterController.dart';
import 'filter_bottom_sheet.dart';

class AllDocumentsScreen extends StatefulWidget {
  final bool documentAssign;

  const AllDocumentsScreen({super.key, required this.documentAssign});

  @override
  State<AllDocumentsScreen> createState() => _AllDocumentsScreenState();
}

class _AllDocumentsScreenState extends State<AllDocumentsScreen> {
  final DocumentsController controller = Get.find<DocumentsController>();
  final RouterController routerController = Get.find<RouterController>();
  bool _loadedOnce = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loadedOnce) {
        controller.isAssignedDocs = widget.documentAssign;
        controller.getDocuments(
          assignedDocuments: widget.documentAssign,
        );
        _loadedOnce = true;
      }
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

  }
  void _onScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        controller.loadMoreDebounced();
      }
    });
  }

  void _navigateToAddDocument() {
    controller.clearData();
    routerController.router.push(AppScreens.addDocumentScreen, extra: null);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.documentAssign == true ? 'My Documents' : 'All Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: widget.documentAssign == true
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        _navigateToAddDocument();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.red),
                            Text("Add", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          /* if (controller.documentsList.isEmpty) {
            return const Center(child: Text("No Clients Found"));
          }*/

          return _buildDocumentsList();
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            // ToastMessage.show("Yet to be Impl...");
            // Ensure controller exists
            if (!Get.isRegistered<DocumentFilterController>()) {
              Get.lazyPut(() => DocumentFilterController(), fenix: true);
            }
            Get.bottomSheet(
              FilterBottomSheet(documentAssign: widget.documentAssign),
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            );
          },
        ),
      );
  }


  Widget _buildFilterChips() {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.filters.map((filter) {
          final isSelected = controller.selectedFilter.value == filter;
          return FilterChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) => controller.updateFilter(filter),
            backgroundColor: Colors.white,
            selectedColor: Colors.red,
            side: BorderSide(color: Colors.grey[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDocumentsList() {


    return Obx(() {
      final documents = controller.documentsList;
      return RefreshIndicator(
        color: Colors.red,
        onRefresh: () async {
          await controller.getDocuments(
            assignedDocuments: widget.documentAssign,
            isLoadMoreRequest: false,
          );
        },
        child: documents.isEmpty
            ? Center(
                child: Text(
                  "No documents found",
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: documents.length + 1,
                itemBuilder: (context, index) {
                  if (index < documents.length) {
                    return _buildDocumentCard(documents[index]);
                  } else {
                    return controller.isLoadMore.value
                        ? const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox();
                  }
                },
              ),
      );
    });
  }

  Widget _buildDocumentCard(DocumentResponse document) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDocumentIcon(document.name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildFileInfo(document),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _buildStatusBadge(document),
              ],
            ),
            const SizedBox(height: 12),
            _buildDocumentDetails(document),
            const SizedBox(height: 12),
            _buildActionButtons(document),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentIcon(String fileName) {
    final icon = _getFileIcon(fileName);
    final color = _getFileColor(fileName);
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

  IconData _getFileIcon(String fileName) {
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

  Color _getFileColor(String fileName) {
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

  Widget _buildFileInfo(DocumentResponse document) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: cs.onPrimary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            document.name.split('.').last.toUpperCase(),
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (document.versionCount > 0) ...[
          Icon(Icons.history, size: 12, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text('v${document.versionCount}', style: theme.textTheme.labelSmall),
        ],
        if (document.commentCount > 0) ...[
          const SizedBox(width: 8),
          Icon(Icons.comment, size: 12, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text('${document.commentCount}', style: theme.textTheme.labelSmall),
        ],
      ],
    );
  }

  Widget _buildStatusBadge(DocumentResponse document) {
    final status = document.statusName ?? '';
    final color = getStatusColor(status);

    return status.isEmpty
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          );
  }

  Widget _buildDocumentDetails(DocumentResponse document) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildDetailChip(Icons.category, document.categoryName),
        _buildDetailChip(
          Icons.calendar_today,
          _formatDate(document.createdDate),
        ),
        if (document.workflowName != null)
          _buildDetailChip(Icons.work, document.workflowName!),
        _buildDetailChip(Icons.person, document.createdByName),
        if (document.companyName != null)
          _buildDetailChip(Icons.business, document.companyName!),
        if (document.signDate != null && document.signDate!.isNotEmpty)
          _buildDetailChip(
            Icons.edit_calendar,
            'Signed: ${_formatDate(document.signDate!)}',
          ),
        if (document.retentionAction != null)
          _buildDetailChip(
            Icons.schedule,
            'Retention: ${document.retentionPeriod ?? '0'} (Days) ${controller.retentionActions[document.retentionAction] ?? 'Unknown'}',
          ),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: cs.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DocumentResponse document) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewDocument(document),
            icon: const Icon(Icons.visibility, size: 16, color: Colors.red),
            label: const Text('View', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(foregroundColor: cs.primary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _editDocument(document),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: OutlinedButton.styleFrom(foregroundColor: cs.tertiary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.showMore(context, document),
            icon: const Icon(Icons.more_vert, size: 16),
            label: const Text('More'),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

  void _viewDocument(DocumentResponse document) {
    controller.selectedDocumentId.value = document.id;
    routerController.router.push(
      AppScreens.documentDetailsScreen,
      extra: document,
    );
    //  ScaffoldMessageShow.show("View Document \n Opening ${document.name}" ?? '');
  }

  void _editDocument(DocumentResponse document) {
    routerController.router.push(AppScreens.addDocumentScreen, extra: document);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
