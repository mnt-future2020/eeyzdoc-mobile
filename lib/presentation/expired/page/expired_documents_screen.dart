import 'package:docuflow/data/models/response/archived_response.dart';
import 'package:docuflow/data/models/response/expired_response.dart';
import 'package:docuflow/presentation/archived/controllers/archived_controller.dart';
import 'package:docuflow/presentation/expired/controllers/expired_controller.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/router_controller.dart';
import '../../../utils/widget.dart';

class ExpiredDocumentsScreen extends StatelessWidget {
  ExpiredDocumentsScreen({super.key});

  final controller = Get.find<ExpiredController>();
  final RouterController routerController = Get.find<RouterController>();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        controller.getExpiredRequestList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Expired',
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
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  color: Colors.red,
                  onRefresh: () async => controller.refreshFirstPage(),
                  child: _buildDocumentsList(),
                ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!controller.isLoadMore.value && controller.hasMoreData) {
          controller.getExpiredRequestList(isPagination: true);
        }
      }
    });

    return Obx(() {
      final items = controller.expiredList;

      return items.isNotEmpty
          ? ListView.builder(
              controller: _scrollController,
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return buildArchivedDocumentCard(
                    context,
                    items[index]!,
                    (doc) => controller.restore(doc, context),
                    (doc) => controller.archived(doc, context),
                  );
                } else {
                  return controller.isLoadMore.value
                      ? const Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox();
                }
              },
            )
          : GestureDetector(
              onTap: () {
                controller.getExpiredRequestList();
              },
              child: Center(
                child: Text(
                  'No Expired Documents',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            );
    });
  }

  Widget buildArchivedDocumentCard(
    BuildContext context,
    ExpiredResponse doc,
    Function(ExpiredResponse) onRestore,
    Function(ExpiredResponse) onDelete,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc.name ?? "Untitled Document",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// Details
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                detailChip(Icons.category, doc.categoryName ?? "No Category"),
                detailChip(Icons.storage, doc.location ?? "No Storage"),
                detailChip(Icons.flag, doc.statusName ?? "Unknown Status"),
                if (doc.expiredDate != null)
                  detailChip(
                    Icons.calendar_today,
                    "Expired: ${DateFormat('dd-MM-yyyy').format(doc.expiredDate!)}",
                  ),
                doc.description == null
                    ? SizedBox.shrink()
                    : detailChip(Icons.description, doc.description ?? ''),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.restore,
                      size: 18,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      "Activate",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () => onRestore(doc),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text(
                      "Archive",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => onDelete(doc),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color ?? Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
