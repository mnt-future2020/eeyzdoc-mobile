import 'package:device_preview/device_preview.dart';
import 'package:docuflow/app/app.dart';
import 'package:docuflow/app/app_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppBindings().dependencies();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
    ),
  );
/*  runApp(
    DevicePreview(
      enabled: true, // set false in release
      builder: (context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
      ),
    ),
  );*/
}



