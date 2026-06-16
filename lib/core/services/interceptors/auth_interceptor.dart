import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/router_controller.dart';
import '../../constants/app_screens.dart';
class AuthInterceptor extends Interceptor {
  final Dio dio = Dio();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    // App key always
    options.headers['x-app-key'] = AppConstants.appKey;

    // Skip login API
    if (options.path.contains('/auth/login')) {
      handler.next(options);
      return;
    }

    final token = PreferenceUtils.getString(AppConstants.AUTH_TOKEN);

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode ?? 0;
    final requestOptions = err.requestOptions;

    if (requestOptions.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    // Skip retry for login API
    if (requestOptions.path.contains('/auth/login')) {
      handler.next(err);
      return;
    }

    if (statusCode == 401 || statusCode == 500) {
      try {
        requestOptions.extra['retried'] = true;

        // 🔐 Re-login using stored credentials (or refresh token)
        final loginResponse = await _silentLogin();

        if (loginResponse == true) {
          final newToken =
          PreferenceUtils.getString(AppConstants.AUTH_TOKEN);

          // Update header
          requestOptions.headers['Authorization'] =
          'Bearer $newToken';

          // Retry original request
          final response = await dio.fetch(requestOptions);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        _forceLogout();
      }
    }

    handler.next(err);
  }

  /// Silent login logic
  Future<bool> _silentLogin() async {
    try {
      final username =
      PreferenceUtils.getString(AppConstants.USER_NAME);
      final password =
      PreferenceUtils.getString(AppConstants.PASSWORD);

      if (username.isEmpty || password.isEmpty) return false;

      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.login}',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(headers: {
          'x-app-key': AppConstants.appKey,
        }),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await PreferenceUtils.setString(
            AppConstants.AUTH_TOKEN, token);
        return true;
      }
    } catch (_) {}

    return false;
  }

  void _forceLogout() {
    final RouterController routerController = Get.find<RouterController>();
    PreferenceUtils.setString(AppConstants.AUTH_TOKEN, "");
    routerController.router.go(AppScreens.loginScreen);
  }
}


