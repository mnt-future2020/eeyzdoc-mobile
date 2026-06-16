import 'package:docuflow/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RouterController extends GetxController {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router;

  GlobalKey<ScaffoldState> get drawerScaffoldKey => drawerKey;
  GlobalKey<NavigatorState> get appNavigatorKey => navigatorKey;

  @override
  void onInit() {
    super.onInit();
    router = createRouter(this);
  }

  void closeOverlay() {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
  }

  void openDrawer() {
    if (drawerKey.currentState != null) {
      drawerKey.currentState!.openDrawer();
    }
  }

  void closeDrawer() {
    if (drawerKey.currentState != null) {
      Navigator.of(drawerKey.currentContext!).pop();
    }
  }

  void goBack() {
    print("Click");
    if (router.canPop()) {
      router.pop();
    }
  }
}
