import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/core/services/download_service.dart';
import 'package:docuflow/data/models/response/document_version_history_response.dart';
import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/widgets/pickers/file_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../dialog/dialog_widgets.dart';

class VersionHistoryDetailsScreen extends StatefulWidget {
  final String documentId;
  final String documentName;

  const VersionHistoryDetailsScreen({super.key, required this.documentId, required this.documentName});

  @override
  State<VersionHistoryDetailsScreen> createState() =>
      _VersionHistoryDetailsScreenState();
}

class _VersionHistoryDetailsScreenState
    extends State<VersionHistoryDetailsScreen> {
  late final DocumentDetailsController detailsController;
  final DocumentsController docController = Get.find<DocumentsController>();
  final RouterController routerController = Get.find<RouterController>();

  @override
  void initState() {
    super.initState();

    detailsController = Get.find<DocumentDetailsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailsController.loadVersionHistory(widget.documentId);
    });
  }

  Future<dynamic> openFilePicker(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Select File",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 180,
            child: SingleFilePicker(
              file: null,
              onChanged: (file) {
                Navigator.pop(context, file);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickAndUploadNewVersion(BuildContext context) async {
    final file = await openFilePicker(context);

    if (file == null) return;

    docController.selectedDocumentFile.value = file;
    docController.docIdController.text = widget.documentId;

    await docController.uploadFile();

    await detailsController.loadVersionHistory(widget.documentId);
  }

  Future<void> startDownload(String docId, String fileName,bool startDownload) async {
    final taskId = await DownloadService().enqueueDownload(
      url: '${AppConstants.baseUrl}/api/document/$docId/download/$startDownload',
      filename: fileName,
    );

    print("Click Data : ${AppConstants.baseUrl}/api/document/$docId/download/$startDownload");
    if (taskId != null) {
      debugPrint('Enqueued download with taskId: $taskId');
      routerController.router.push(AppScreens.downloadsScreen);
    } else {
      debugPrint('Failed to enqueue download');
    }
  }

  void viewFile(String? url) {
    if (url == null || url.isEmpty) {
      Get.snackbar(
        "Error",
        "File URL unavailable",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final cleanedPath = url.startsWith("/") ? url.substring(1) : url;
    final fullUrl = "${AppConstants.baseUrl}/$cleanedPath";

    print("Opening in WebView: $fullUrl");

    routerController.router.push(
      '${AppScreens.fileWebViewViewer}?url=$fullUrl',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        Obx(
          () => ElevatedButton.icon(
            onPressed: docController.isLoading.value
                ? null
                : () => pickAndUploadNewVersion(context),
            icon: docController.isLoading.value
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.upload, color: Colors.white),
            label: const Text(
              "Upload New Version",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: Obx(() {
            if (detailsController.isLoadingVersionHistory.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (detailsController.versionHistory.isEmpty) {
              return const Center(child: Text("No Version History Found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: detailsController.versionHistory.length,
              itemBuilder: (context, index) {
                final version = detailsController.versionHistory[index];

                return _versionCard(version);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _versionCard(DocumentVersionHistoryResponse version) {
    final bool isCurrent = version.isCurrentVersion == true;
    String? currentVersionId;

    if (isCurrent) {
      currentVersionId = version.id;
      print("$currentVersionId");
    }
    final parsedDate = parseDate(version.modifiedDate);

    String formattedDate = "";

    if (parsedDate != null) {
      final localDate = parsedDate.toLocal();
      formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(localDate);
    }


    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCurrent ? Colors.green : Colors.black12).withOpacity(0.20),
            offset: const Offset(0, 3),
            blurRadius: 8,
          )
        ],
        border: Border.all(
          color: isCurrent ? Colors.green.withOpacity(0.4) : Colors.grey.shade200,
          width: isCurrent ? 1.2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ────────────────── Header Row ──────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: isCurrent
                          ? [Colors.green, Colors.greenAccent]
                          : [Colors.grey.shade600, Colors.grey.shade400],
                    ),
                  ),
                  child: Text(
                    isCurrent ? "Current Version" : "Version",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),

                if (version.modifiedDate != null)
                  Text( formattedDate.isEmpty ? "-" : formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // ────────────────── Version Details ──────────────────
            _row("Added By", version.createdByUser),
            _row("Signed By", version.signedByUser),
            version.signDate == null
                ? const SizedBox.shrink()
                : _row(
              "Sign Date",
              DateFormat('dd-MM-yyyy hh:mm a').format(version.signDate!.toLocal()),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ────────────────── Actions Row ──────────────────
            isCurrent?SizedBox.shrink(): Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               /* _actionIcon(
                  icon: Icons.visibility,
                  color: Colors.blue,
                  tooltip: "View",
                  onTap: () => viewFile(version.url),
                ),*/
                _actionIcon(
                  icon: Icons.download,
                  color: Colors.green,
                  tooltip: "Download",
                  onTap: () {
                    startDownload(
                        version.id??'',
                      widget.documentName,true
                    );
                  },
                ),
                if (!isCurrent)
                  _actionIcon(
                    icon: Icons.restore,
                    color: Colors.orange,
                    tooltip: "Restore as Current",
                    onTap: () {
                      detailsController.restoreVersion(widget.documentId,currentVersionId??'',version.id??'');
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
  DateTime? parseDate(dynamic date) {
    if (date == null) return null;

    if (date is DateTime) {
      return date;
    }

    if (date is String) {
      try {
        // Handle ISO formats
        return DateTime.parse(date);
      } catch (_) {
        // Handle "yyyy-MM-dd HH:mm:ss UTC"
        try {
          return DateFormat("yyyy-MM-dd HH:mm:ss 'UTC'").parseUtc(date);
        } catch (_) {
          return null;
        }
      }
    }

    return null;
  }

// ---------------- Styled Row ----------------
  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "—",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

}
