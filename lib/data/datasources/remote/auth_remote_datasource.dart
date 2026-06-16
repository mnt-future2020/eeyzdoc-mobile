import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);

  Future<SuccessResponse> changePasswordRequestApi(
    ChangePasswordRequest request,
  );

  Future<SuccessResponse> editProfileExecute(EditProfileRequest request);

  Future<SuccessResponse> forgotPasswordRequestExecute(String email);

  Future<bool> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      PreferenceUtils.setString(AppConstants.AUTH_TOKEN,"");
      final response = await dioClient.post(
        AppConstants.login,
        data: request.toJson(), // Map<String, dynamic>
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      if (response.data != null && response.data is Map<String, dynamic>) {
        try {
          return LoginResponse.fromJson(response.data);
        } catch (_) {}
      }

      if (response.statusCode == 401) {
        return LoginResponse(
          status: "Failure",
          message: "Invalid username or password",
        );
      }

      return LoginResponse(
        status: "Failure",
        message: "Login failed! Please try again.",
      );
    } catch (e) {
      return LoginResponse(
        status: "Failure",
        message: "Unexpected error, please try again.",
      );
    }
  }



  @override
  Future<bool> logout() async {
    try {
      await dioClient.post(AppConstants.logout);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<SuccessResponse> changePasswordRequestApi(
    ChangePasswordRequest request,
  ) async {

    try {
      final response = await dioClient.post(
        AppConstants.changePassword,
        data: request.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (response.statusCode == 200) {
        return SuccessResponse.fromJson(response.data);
      } else {
        return SuccessResponse(
          message: "Failed to send reset link. Please try again.",
          status: "Failure",
        );
      }
    } catch (e) {
      return SuccessResponse(
        message: "An error occurred. Please try again later.",
        status: "Failure",
      );
    }
  }

  @override
  Future<SuccessResponse> editProfileExecute(EditProfileRequest request) async {

    try {
      final response = await dioClient.put(
        AppConstants.editProfile,
        data: request.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse.fromJson(response.data);
      } else {
        return SuccessResponse(
          message: "Failed to update profile",
          status: "Failure",
        );
      }
    } catch (e) {
      print(e);
      return SuccessResponse(message: "An error occurred.", status: "Failure");
    }
  }
  @override
  Future<SuccessResponse> forgotPasswordRequestExecute(String email) async {
    final formData = FormData.fromMap({
      "email": email,
    });


    try {
      final response = await dioClient.post(
        AppConstants.forgotPassword, // Must match Postman URL
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        return SuccessResponse.fromJson(response.data);
      } else {
        return SuccessResponse(
          message: "Failed to process request",
          status: "Failure",
        );
      }
    } catch (e) {
      print("Forgot Password Error: $e");
      return SuccessResponse(
        message: "Something went wrong. Try again later.",
        status: "Failure",
      );
    }
  }

}
