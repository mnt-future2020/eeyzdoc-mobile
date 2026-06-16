import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/core/services/download_service.dart';
import 'package:docuflow/data/models/response/document_response.dart';

import 'package:docuflow/presentation/documents/bindings/documents_binding.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/request/CommentArgs.dart';
import '../../documents/controllers/documents_controller.dart';
import '../../documents/dialog/dialog_widgets.dart';
import 'AdditionalInfoWidget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.find<DashboardController>();
  final RouterController routerController = Get.find<RouterController>();
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: (){
        controller.loadDashboard();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: GestureDetector(
          onTap: controller.hideNotifications,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [_buildMainContent(), _buildNotificationPanel()],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.red,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => routerController.openDrawer(),
        ),
      ),
      title: const Text(
        'Dashboard',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download, color: Colors.white),
          onPressed: () => {
            routerController.router.push(AppScreens.downloadsScreen),
          },
        ),
        IconButton(
          key: controller.notificationKey,
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: controller.toggleNotifications,
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
          onPressed: () =>
              routerController.router.push(AppScreens.profileScreen),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: () async {
        await controller.loadDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildCardsGrid(),
            const SizedBox(height: 16),
            /* Text(
              'Documents by Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),*/
            /*  Obx(
              () => controller.chartData.value.isNotEmpty
                  ? DocumentCategoryChart(categories: controller.chartData.value)
                  : SizedBox.shrink(),
            ),*/
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Recent Files',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    routerController.router.push(
                      AppScreens.allDocumentsScreen,
                      extra: true,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildRecentFiles(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsGrid() {
    return Obx(
      () => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemCount: controller.cards.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final card = controller.cards[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    card['icon'] as IconData,
                    size: 22,
                    color: card['color'] as Color,
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Value text
                        Text(
                          card['value'].toString(),
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.color, // 👈 Dark safe
                              ),
                        ),

                        /// Label text
                        Text(
                          card['label'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color
                                    ?.withOpacity(
                                      0.7,
                                    ), // 👈 Grey effect in both themes
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentFiles() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.documentsList.length,
        itemBuilder: (context, index) {
          final file = controller.documentsList[index];

          return Column(
            children: [
              Obx(() {
                final isSelected =
                    controller.selectedFileIndex.value == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.withOpacity(0.06)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.red.withOpacity(0.4)
                          : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),

                    // File Icon
                    leading: _buildDocumentIcon(file!.name ?? ''),

                    // Title + Date
                    title: Text(
                      file.name ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(file.createdDate ?? ''),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),

                    // View / Close indicator
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isSelected ? 'Close' : 'View',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          isSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 18,
                          color: Colors.red[800],
                        ),
                      ],
                    ),

                    onTap: () => controller.toggleFileInfo(index),
                  ),
                );
              }),

              // EXPANDED INFO SECTION
              Obx(() {
                final isSelected =
                    controller.selectedFileIndex.value == index;

                return AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isSelected
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    margin: const EdgeInsets.only(top: 6, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AdditionalInfoWidget(
                      fileName: file?.name ?? "",
                      documentId: file?.id ?? "",
                      uploader: file?.createdByName ?? "",
                      uploadDate: file?.createdDate ?? "",
                      documentResponse: file!,
                      controller: controller,
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy hh:mm a').format(date);
    } catch (e) {
      return isoDate;
    }
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
            ? color.withOpacity(0.25)
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

  Widget _buildNotificationPanel() {
    return Obx(() {
      if (!controller.showNotifications.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 0,
        right: 12,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.notifications,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Notifications',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(),

                  Expanded(
                    child: SingleChildScrollView(child: _notificationsList()),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        routerController.router.push(
                          AppScreens.notificationsScreen,
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _notificationsList() {
    return ListView.builder(
      itemCount: controller.notifications.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.red.withOpacity(0.1),
            radius: 16,
            child: Icon(
              controller.notifications[index].notificationType == 2
                  ? Icons.insert_drive_file_outlined
                  : Icons.change_circle_outlined,
              color: Colors.red,
              size: 16,
            ),
          ),
          title: Text(
            trimMiddle(controller.notifications[index].title, 28),
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 12),
          ),
          subtitle: Text(
            "${controller.notifications[index].subtitle}\n${controller.notifications[index].timeStamp}",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              height: 1.2,
            ),
          ),
          onTap: () async{
            if (isNavigating) return;
            isNavigating = true;

            if (controller.notifications[index].notificationType == 3) {
              controller.workFlowController.isOpeningWorkflow=true;
              await controller.workFlowController
                  .getWorkFLowDetailsRequest(controller.notifications[index].documentWorkflowId ?? '');
            }

            if (controller.notifications[index].notificationType == 2) {
              print("Data : ${controller.notifications[index].fileRequestId}");
              GoRouter.of(context).push(
                AppScreens.fileDetailsScreen,
                extra: controller.notifications[index].fileRequestId,
              );
            }

            isNavigating = false;

          },
        );
      },
    );
  }
}

String trimMiddle(String text, int maxLength) {
  if (text.length <= maxLength) return text;

  final keep = maxLength ~/ 2;
  return text.substring(0, keep) + ' ... ' + text.substring(text.length - keep);
}

class MoreActionsMenu extends StatelessWidget {
  final DocumentResponse documentResponse;
  final bool flagShow;

  MoreActionsMenu({
    super.key,
    required this.flagShow,
    required this.documentResponse,
  });

  final RouterController routerController = Get.find<RouterController>();

  Future<void> startDownload(String docId, String fileName) async {
    final taskId = await DownloadService().enqueueDownload(
      url: '${AppConstants.baseUrl}/api/document/$docId/download/false',
      filename: fileName,
    );

    if (taskId != null) {
      debugPrint('Enqueued download with taskId: $taskId');
      routerController.router.push(AppScreens.downloadsScreen);
    } else {
      debugPrint('Failed to enqueue download');
    }
  }

  @override
  Widget build(BuildContext context) {
    DocumentsBinding().dependencies();
    final DocumentsController controller = Get.find<DocumentsController>();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            flagShow ? _item(context, Icons.edit, "Edit") : SizedBox.shrink(),
            _item(context, Icons.share, "Share"),
            Obx(
              () => controller.isShareLinkLoading.value
                  ? IgnorePointer(
                      child: _item(context, Icons.link, "Get Shareable Link"),
                    )
                  : _item(context, Icons.link, "Get Shareable Link"),
            ),
            _item(context, Icons.fingerprint, "Document Signature"),
            _item(context, Icons.play_arrow, "Start Workflow"),
            flagShow
                ? _item(context, Icons.info_outline, "Details")
                : SizedBox(),
            _item(context, Icons.download, "Download"),
            _item(context, Icons.upload_file, "Upload New Version File"),
            _item(context, Icons.history, "Version History"),
            _item(context, Icons.comment, "Comment"),
            _item(context, Icons.add_alert, "Add Reminder"),
            _item(context, Icons.email, "Send Email"),
            _item(context, Icons.archive, "Archive", recentFile: flagShow),
            _item(context, Icons.delete, "Delete", recentFile: flagShow),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title, {
        bool recentFile = true,
      }) {
    DocumentsBinding().dependencies();
    final DocumentsController controller = Get.find<DocumentsController>();
    final DashboardController dashboardController = Get.find<DashboardController>();
    final theme = Theme.of(context);

    void openMailComposer() {
      routerController.router.push(AppScreens.emailComposerScreen);
    }

    return ListTile(
      leading: Icon(icon, size: 20, color: theme.iconTheme.color),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
      ),
      tileColor: theme.colorScheme.surface, // adapts to light/dark mode
      hoverColor: theme.colorScheme.primary.withOpacity(0.1),
      onTap: () {
        if (title == "Edit") {
          routerController.router.push(
            AppScreens.addDocumentScreen,
            extra: documentResponse,
          );
          dashboardController.selectedFileIndex.value=-1;
          Navigator.pop(context);

        } else if (title == "Share") {
          routerController.router.push(AppScreens.documentShareListScreen);
          Navigator.pop(context);
        } else if (title == "Get Shareable Link") {
          shareLinkPreviewCheck(context, documentResponse.id, controller);
        } else if (title == "Document Signature") {
          routerController.router.push(AppScreens.documentSignatureScreen);
          Navigator.pop(context);
        } else if (title == "Start Workflow") {
          showStartWorkFLowDialog(documentResponse.id, controller);
        } else if (title == "Comment") {
          routerController.router.push(AppScreens.commentsScreen,extra: CommentArgs(documentId:documentResponse.id,documentName: documentResponse.name,flagAppbar: true));
          Navigator.pop(context);
        } else if (title == "Details") {
          routerController.router.push(
            AppScreens.documentDetailsScreen,extra: documentResponse
          );
          Navigator.pop(context);
        } else if (title == "Download") {
          startDownload(documentResponse.id, documentResponse.name);
          Navigator.pop(context);
        } else if (title == "Upload New Version File") {
          routerController.router.push(AppScreens.uploadNewVersion);
          Navigator.pop(context);
        } else if (title == "Add Reminder") {
          routerController.router.push(
            AppScreens.remindersAddScreen,
            extra: {'reminderId': null, 'documentId': documentResponse.id},
          );
          Navigator.pop(context);
        } else if (title == "Version History") {
          routerController.router.push(
            AppScreens.versionHistory,
            extra: documentResponse,
          );
          Navigator.pop(context);
        } else if (title == "Send Email") {
          openMailComposer();
          Navigator.pop(context);
        } else if (title == "Archive") {
          dashboardController.documentDelete(
            documentResponse.id,
            "Are you sure you want to archive?",
            documentResponse.name,
            title,
            controller,
            recentFile,
          );
          Navigator.pop(context);
        } else if (title == "Delete") {
          dashboardController.documentDelete(
            documentResponse.id,
            "Are you sure you want to delete?",
            "By deleting the document, it will no longer be accessible in the future, and the following data will be deleted from the system:\nVersion History\nMeta Tags\nComment\nNotifications\nReminders\nPermissions",
            title,
            controller,
            recentFile,
          );
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

}
