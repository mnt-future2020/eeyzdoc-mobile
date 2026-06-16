import 'package:docuflow/data/models/response/FileRequestDocumentResponse.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../app/routes/router_controller.dart';
import '../../../constants/urlConstants.dart' as AppConstants;
import '../../../core/constants/app_screens.dart';
import '../../../core/services/download_service.dart';
import '../../../data/models/response/file_request_response.dart';
import '../controllers/file_request_controller.dart';

class FileRequestViewPage extends StatelessWidget {
  final String fileId;

  FileRequestViewPage({super.key, required this.fileId});
  final RouterController routerController = Get.find<RouterController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FileRequestController>();
    final RouterController routerController = Get.find<RouterController>();

    return FocusDetector(
      onVisibilityGained: () {
        controller.loadFileDetails(fileId);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Uploaded Documents',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.red,
          elevation: 1,

        ),
        body: Column(
          children: [
              Obx(
                () => controller.isLoading.value
                    ? Expanded(
                      child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 300),
                            Center(child: CircularProgressIndicator()),
                          ],
                        ),
                    )
                    : controller.fileDetailsList.isEmpty
                    ? Expanded(
                      child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 300),
                            Center(
                              child: Text(
                                "No Data found",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                    )
                    : Expanded(
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          itemCount: controller.fileDetailsList.length,
                          itemBuilder: (_, index) {
                            final item = controller.fileDetailsList[index];
                            return buildFileCard(context, item);
                          },
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
      style: const TextStyle(fontSize: 10, color: Colors.white),
    );
  }

  Widget buildFileCard(
    BuildContext context,
    FileRequestDocument? file,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insert_drive_file, size: 40, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file!.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: file.fileRequestDocumentStatus == 1
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: buildStatus(file.fileRequestDocumentStatus!),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Details Chips
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                detailChip(
                  Icons.calendar_today,
                  "Uploaded: ${DateFormat('dd-MM-yyyy HH:mm a').format(file.createdDate)}",
                ),
              ],
            ),
            file.reason==null?SizedBox.shrink():  Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                detailChip(
                  Icons.file_copy_outlined,
                  "Reason: ${file.reason}",
                ),
              ],
            ),
           /* file.approvalOrRejectedById!=null&&file.approvedRejectedDate!=null?SizedBox.shrink(): Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: ()
                    {

                    },
                    icon: const Icon(
                      Icons.file_copy, size: 14, color: Colors.green,),
                    label: const Text(
                      "Approve", style: TextStyle(color: Colors.green,),),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {

                    },
                    icon: const Icon(
                      Icons.edit, size: 14, color: Colors.red,),
                    label: const Text(
                      "Reject", style: TextStyle(color: Colors.red,),),
                  ),
                ),
              ],
            ),*/
            SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: OutlinedButton.icon(
                onPressed: () {
                  startDownload(
                      file.id??'',
                      file.name,false
                  );
                },
                icon: const Icon(Icons.download, size: 18, color: Colors.orangeAccent),
                label: const Text(
                  "Download",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ),
            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }

  Widget detailChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.red),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Future<void> startDownload(
      String fileId,
      String fileName,
      bool startDownload,
      ) async {
    final url =
        '${AppConstants.baseUrl}/api/file-request-document/$fileId/download';

    debugPrint("Click Data : $url");

    final taskId = await DownloadService().enqueueDownload(
      url: url,
      filename: fileName,
    );

    if (taskId != null) {
      debugPrint('Enqueued download with taskId: $taskId');
      routerController.router.push(AppScreens.downloadsScreen);
    } else {
      debugPrint('Failed to enqueue download');
    }
  }

}
