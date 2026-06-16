import 'dart:convert';
import 'dart:developer';

import 'package:docuflow/app/routes/router_controller.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/constants/globals.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/constants/app_screens.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/request/login_request.dart';
import '../../../domain/usecases/auth_usecase.dart';

class SplashController extends GetxController {
  RxString version = "Version:1.0".obs;
  final routerController = Get.find<RouterController>();
  final authController = Get.find<AuthController>();
  final AuthUseCase authUseCase;
  SplashController({required this.authUseCase});

  @override
  void onInit() {
    super.onInit();
    getLoginStatus();
  }

  void getLoginStatus()
  {
    Future.delayed(Duration(seconds: 2), () async {
      if (PreferenceUtils.getBool(AppConstants.IS_LOGIN))
      {
        login(email: PreferenceUtils.getString(AppConstants.USER_NAME), password: PreferenceUtils.getString(AppConstants.PASSWORD));
      }else {
        routerController.router.go(AppScreens.loginScreen);
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    try {
     // isLoading.value = true;

      var loginRequest = LoginRequest(email: email, password: password);
      final response = await authUseCase.login(loginRequest);

      if (response.status == "success" &&
          response.authorisation?.token != null) {
        PreferenceUtils.setString(
          AppConstants.AUTH_TOKEN,
          response.authorisation!.token!,
        );
        PreferenceUtils.setString(
            AppConstants.USER_NAME, email);
        PreferenceUtils.setString(
            AppConstants.PASSWORD, password);
        authController.loginResponseResponse.value=response;
        PreferenceUtils.setBool(
          AppConstants.IS_LOGIN,
          true,
        );
        routerController.router.go(AppScreens.dashboardScreen);

      } else {
        ScaffoldMessageShow.show(response.message ?? "Unauthorized");
      }
    } catch (e) {
      ScaffoldMessageShow.show("Unauthorized: ${e.toString()}");
    } finally {
     // isLoading.value = false;
    }
  }

  void sendToLogin(String token)
  {
    PreferenceUtils.setString(
      AppConstants.AUTH_TOKEN,
     token,
    );
    PreferenceUtils.setBool(
      AppConstants.IS_LOGIN,
      true,
    );
    routerController.router.go(AppScreens.dashboardScreen);
  }
  // void _getAppVersion() async {
  //   String appVersion = await AppUtils.getAppVersion();
  //   version.value = appVersion;
  // }
}
