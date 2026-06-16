import 'dart:async';

import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/constants/globals.dart';
import 'package:docuflow/presentation/user/bindings/auth_binding.dart';
import 'package:docuflow/presentation/user/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    PreferenceUtils.init();

    // controller.sendNextPage();
  }

  @override
  void dispose() {
   // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthBinding().dependencies();
    SplashController controller = Get.put(Get.find<SplashController>());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/docuflow_logo.jpg',
                  height: 90,
                  width: 90,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to DocuFlow',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(
                () => Text(
                  controller.version.value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
