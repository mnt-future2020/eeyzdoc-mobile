import 'package:docuflow/my_documents_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/app_router.dart';
import '../../../app/routes/router_controller.dart';
import '../../../core/constants/app_screens.dart';
import '../../filerequest/bindings/file_request_binding.dart';
import '../../filerequest/page/file_request_view_page.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DashboardController controller = Get.find<DashboardController>();
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Obx(() {
        if (controller.isNotificationsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications available",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final item = controller.notifications[index];

            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Icon(
                  item.notificationType == 0
                      ? Icons.insert_drive_file_outlined
                      : Icons.change_circle_outlined,
                  color: Colors.red,
                  size: 18,
                ),
              ),

              title: Text(
                trimMiddle(item.title, 40),
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: Text(
                "${item.subtitle}\n${item.timeStamp}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
              onTap: () async{
                if (isNavigating) return;
                isNavigating = true;

                if (item.notificationType == 3) {
                   controller.workFlowController.isOpeningWorkflow=false;
                  await controller.workFlowController
                      .getWorkFLowDetailsRequest(item.documentWorkflowId ?? '');
                }

                if (item.notificationType == 2) {
                  print("Data : ${item.fileRequestId}");
                  GoRouter.of(context).push(
                    AppScreens.fileDetailsScreen,
                    extra: item.fileRequestId,
                  );
                }


              },
            );
          },
        );
      }),
    );
  }
}

String trimMiddle(String text, int maxLength) {
  if (text.length <= maxLength) return text;

  final keep = maxLength ~/ 2;
  return text.substring(0, keep) + ' ... ' + text.substring(text.length - keep);
}
