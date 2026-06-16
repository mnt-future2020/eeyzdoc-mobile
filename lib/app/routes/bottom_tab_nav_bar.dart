import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/presentation/documents/bindings/documents_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/documents/controllers/documents_controller.dart';

class BottomNavBar extends StatelessWidget {
  final Widget child;

  const BottomNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = GoRouterState.of(context).uri.path;

    final tabs = [
      (AppScreens.dashboardScreen, 'Dashboard', Icons.folder),
      (AppScreens.workFlowsScreen, 'Work Flows', Icons.work_outline),
      (AppScreens.remindersScreen, 'Reminders', Icons.notifications_none),
      (AppScreens.fileRequestScreen, 'Requests', Icons.request_page_outlined),
    ];

    final currentIndex = tabs.indexWhere((t) => location.startsWith(t.$1));

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          DocumentsBinding().dependencies();
          final DocumentsController controller =
              Get.find<DocumentsController>();
          controller.clearData();
          router.push(AppScreens.addDocumentScreen, extra: null);
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 8.0,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, router, tabs[0], 0, currentIndex == 0),
              _navItem(context, router, tabs[1], 1, currentIndex == 1),
              _navItem(context, router, tabs[2], 1, currentIndex == 2),
              _navItem(context, router, tabs[3], 1, currentIndex == 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context,
      GoRouter router,
      (String, String, IconData) tab,
      int index,
      bool active,
      ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (tab.$1 == AppScreens.workFlowsScreen) {
          router.go(tab.$1, extra: false);
        } else {
          router.go(tab.$1);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tab.$3,
              size: 22,
              color: active
                  ? Colors.red // 🔴 active color
                  : theme.iconTheme.color, // 🌙 dark-safe
            ),
            const SizedBox(height: 4),
            Text(
              tab.$2,
              style: theme.textTheme.labelSmall!.copyWith(
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? Colors.red
                    : theme.textTheme.labelSmall!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
