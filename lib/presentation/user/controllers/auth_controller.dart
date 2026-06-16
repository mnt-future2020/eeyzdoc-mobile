import 'dart:convert';
import 'dart:developer';

import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/constants/globals.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/router_controller.dart';
import '../../../core/constants/app_screens.dart';
import '../../../core/utils/scaffold_message.dart';
import '../../../data/models/response/login_response.dart';

class AuthController extends GetxController {
  final AuthUseCase authUseCase;
  final routerController = Get.find<RouterController>();
  final Rxn<LoginResponse> loginResponseResponse = Rxn<LoginResponse>();

  AuthController({required this.authUseCase});

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

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
        PreferenceUtils.setBool(
          AppConstants.IS_LOGIN,
          true,
        );
        var encodeLoginData = jsonEncode(response);
        final loginResponse = loginResponseFromJson(encodeLoginData.toString());
        log("Data Response : ${jsonEncode(loginResponse)}");
        loginResponseResponse.value=response;
        routerController.router.go(AppScreens.dashboardScreen);
      } else {
        ScaffoldMessageShow.show(response.message ?? "Unauthorized");
      }
    } catch (e) {
      ScaffoldMessageShow.show("Unauthorized: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /*
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;

    try {
      final request = LoginRequest(email: email, password: password);
      final userEntity = await authUseCase.login(request);
      log("Data Response : ${jsonEncode(userEntity.toString())}");

    //  await userUseCase.setUser(userEntity, rememberMe: rememberMe.value);
      user.value = userEntity;
      PreferenceUtils.setString(
        AppConstants.AUTH_TOKEN,
        user.value!.token.value,
      );
    } catch (e, st) {
      print("Login error: $e, StackTrace: $st");
    } finally {
      isLoading.value = false;
    }
  }
*/

  Future<SuccessResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;

    try {
      final request = ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      final response = await authUseCase.changePasswordExecute(request);
      return response;
    } catch (e, st) {
      return SuccessResponse(
        message: "Change Password error: $e",
        status: "Failure",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<SuccessResponse> editProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    isLoading.value = true;

    try {
      var editProfileRequest = EditProfileRequest(
        id: PreferenceUtils.getString(AppConstants.USER_ID),
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        userName: email,
        email: email,
      );

      final response = await authUseCase.editProfileExecute(editProfileRequest);
      return response;
    } catch (e, st) {
      return SuccessResponse(
        message: "Edit Profile error: $e",
        status: "Failure",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<SuccessResponse> forgotPasswordApi({required String email}) async {
    isLoading.value = true;
    try {
      final response = await authUseCase.forgotPasswordExecute(email);
      return response;
    } catch (e, st) {
      return SuccessResponse(
        message: "Edit Profile error: $e",
        status: "Failure",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setRememberMe(bool value) {
    rememberMe.value = value;
  }

}
