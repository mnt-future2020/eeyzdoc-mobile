import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final routerController = Get.find<RouterController>();

    return Obx(() {
      final router = routerController.router;

      return GetMaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'DocuFlow',
        theme: themeController.theme, // reactive
        darkTheme: themeController.darkTheme,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
