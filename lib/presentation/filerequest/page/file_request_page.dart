import 'package:docuflow/core/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../app/routes/router_controller.dart';
import '../../../core/constants/app_screens.dart';
import '../../../data/models/response/file_request_response.dart';
import '../controllers/file_request_controller.dart';

class FileRequestPage extends StatelessWidget {
  final controller = Get.find<FileRequestController>();
  final RouterController routerController = Get.find<RouterController>();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        controller.getFileRequestList();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'File Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Builder(
              builder: (context) =>
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => routerController.openDrawer(),
                  ),
            ),
            backgroundColor: Colors.red,
            elevation: 1,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    controller.resetForm();
                    routerController.router.push(
                        AppScreens.fileRequestAddScreen);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
          body: Column(
            children: [

              /// 🔍 SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: controller.searchCtrl,
                  decoration: InputDecoration(
                    hintText: "Search by subject...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    controller.filterList(value);
                  },
                ),
              ),

              /// LIST OR EMPTY VIEW
              Expanded(
                child: Obx(
                      () => RefreshIndicator(
                        color: Colors.red,
                    onRefresh: () async {
                      controller.searchCtrl.clear();     // optional
                      await controller.getFileRequestList();
                    },
                    child: controller.isLoading.value
                        ?  ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 300),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                        : controller.filteredList.isEmpty
                        ?  ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 300),
                        Center(
                          child: Text(
                            "No file requests found",
                            style:
                            TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                        : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: controller.filteredList.length,
                      itemBuilder: (_, index) {
                        final item = controller.filteredList[index];
                        return buildFileCard(context, item, controller);
                      },
                    ),
                  ),
                ),
              ),

            ],
          ),
      ),
    );
  }

  String formatDate(DateTime date) =>
      DateFormat("MM/dd/yyyy h:mm:ss a").format(date);

  Widget buildStatus(int status) {
    return Text(
        status == 1 ? "Uploaded" : "Created",
        style: const TextStyle(fontSize: 10, color: Colors.white)
    );
  }

//        color: status == 1 ? Colors.green : Colors.orange,
  Widget buildFileCard(BuildContext context,
      FileRequestResponse? file,
      FileRequestController controller,) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP ROW → Icon + Title + File Size/Badge
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  size: 40,
                  color: Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file!.subject ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: file.fileRequestStatus == 1 ? Colors.green : Colors
                        .orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: buildStatus(file.fileRequestStatus!),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Details Chips
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                detailChip(Icons.person, file.createdBy ?? "Unknown"),
                if (file.allowExtension!.isNotEmpty)
                  detailChip(Icons.label, file.allowExtension!),
                if (file.email!.isNotEmpty) detailChip(Icons.email, file.email!),
                detailChip(
                  Icons.calendar_today,
                  "Uploaded: ${DateFormat('dd-MM-yyyy HH:mm a').format(
                      file.createdDate!)}",
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.viewFileDetailsRequest(file.id!),
                    icon: const Icon(
                      Icons.file_copy, size: 14, color: Colors.orange,),
                    label: const Text(
                      "View", style: TextStyle(color: Colors.orange,),),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.editFileRequest(file),
                    icon: const Icon(
                      Icons.edit, size: 14, color: Colors.green,),
                    label: const Text(
                      "Edit", style: TextStyle(color: Colors.green,),),
                  ),
                ),
              ],
            ),    Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showFileDeleteDialog(context,
                          "Are you sure you want to delete ${file.subject}",
                          file, controller);
                    },
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                controller.isLinkExpired(file.linkExpiryTime)?  Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.copyFileRequest(context, file),
                    icon: const Icon(Icons.copy, size: 14),
                    label: const Text("Copy"),
                  ),
                ):SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 KB";
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(2)} ${sizes[i]}';
  }

  Widget detailChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16,color: Colors.red,),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  void showFileDeleteDialog(BuildContext context,
      String title,
      FileRequestResponse fileRequestResponse,
      FileRequestController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          actions: [
            TextButton(
              child: const Text("No", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Yes", style: TextStyle(color: Colors.white)),
              onPressed: () {
                controller.deleteFileRequest(context, fileRequestResponse);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
