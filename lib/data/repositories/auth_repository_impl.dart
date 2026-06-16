import 'package:docuflow/data/datasources/remote/auth_remote_datasource.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/auth_repository.dart';

import '../models/response/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await remoteDataSource.login(request);
    return response;
  }

  @override
  Future<bool> logout() async {
    final response = await remoteDataSource.logout();
    return response;
  }

  @override
  Future<SuccessResponse> ChangePasswordRequestApi(
    ChangePasswordRequest request,
  ) async {
    final response = await remoteDataSource.changePasswordRequestApi(request);
    return response;
  }

  @override
  Future<SuccessResponse> editProfileExecute(EditProfileRequest request) async {
    final response = await remoteDataSource.editProfileExecute(request);
    return response;
  }

  @override
  Future<SuccessResponse> forgotPasswordRequestApi(String email) async{
    final response = await remoteDataSource.forgotPasswordRequestExecute(email);
    return response;
  }
}
