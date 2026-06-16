import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DrawerNavBar extends StatelessWidget {
  final Widget child;

  const DrawerNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RouterController>();
    final router = GoRouter.of(context);

    final items = [
      (AppScreens.allDocumentsScreen, 'All Documents', Icons.folder),
      (
        AppScreens.myDocumentsScreen,
        'My Documents',
        Icons.folder_special_outlined,
      ),
      (AppScreens.myWorkFlowScreen, 'My WorkFlow', Icons.work_outline),
      (
        AppScreens.fileRequestScreen,
        'File Request',
        Icons.request_page_outlined,
      ),
      (
        AppScreens.archivedDocumentsScreen,
        'Archived Documents',
        Icons.archive_outlined,
      ),
      (
        AppScreens.expiredDocumentsScreen,
        'Expired Documents',
        Icons.event_busy_outlined,
      ),
      (AppScreens.remindersScreen, 'Reminder', Icons.notifications_none),
      (AppScreens.clientsScreen, 'Clients', Icons.people_outline),
    ];

    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = items.indexWhere((i) => location.startsWith(i.$1));

    return Scaffold(
      key: controller.drawerScaffoldKey,
      drawer: Drawer(
        backgroundColor:
            Theme.of(context).drawerTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.red.withOpacity(0.12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1.2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/docuflow_logo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final active = i == selectedIndex;

                  return ListTile(
                    leading: Icon(
                      items[i].$3,
                      color: active
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      items[i].$2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: active
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      final selectedScreen = items[i].$1;

                      if (selectedScreen == AppScreens.myDocumentsScreen) {
                        router.push(AppScreens.allDocumentsScreen, extra: true);
                      } else if (selectedScreen == AppScreens.myWorkFlowScreen) {
                        router.push(AppScreens.myWorkFlowScreen);
                      } else if (selectedScreen ==
                          AppScreens.allDocumentsScreen) {
                        router.push(
                          AppScreens.allDocumentsScreen,
                          extra: false,
                        );
                      } else {
                        router.push(selectedScreen);
                      }

                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: child,
    );
  }
}
