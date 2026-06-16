import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/response/success_response.dart';

import '../../data/models/response/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<SuccessResponse> ChangePasswordRequestApi(
    ChangePasswordRequest request,
  );
  Future<SuccessResponse> editProfileExecute(EditProfileRequest request);
  Future<SuccessResponse> forgotPasswordRequestApi(
      String email,
      );
  Future<bool> logout();
}
