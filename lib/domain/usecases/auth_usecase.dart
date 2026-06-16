import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<LoginResponse> login(LoginRequest request) async {
    return await repository.login(request);
  }

  Future<SuccessResponse> changePasswordExecute(
    ChangePasswordRequest request,
  ) async {
    return await repository.ChangePasswordRequestApi(request);
  }

  Future<SuccessResponse> editProfileExecute(EditProfileRequest request) async {
    return await repository.editProfileExecute(request);
  }

  Future<SuccessResponse> forgotPasswordExecute(String email) async {
    return await repository.forgotPasswordRequestApi(email);
  }

  Future<bool> logout() async {
    return await repository.logout();
  }
}
