import 'package:docuflow/domain/usecases/auth_usecase.dart';
import 'package:docuflow/presentation/user/controllers/auth_controller.dart';
import 'package:docuflow/presentation/user/controllers/splash_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(
          authUseCase: Get.find<AuthUseCase>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<SplashController>()) {
      Get.lazyPut<SplashController>(
        () => SplashController(
          authUseCase: Get.find<AuthUseCase>(),
        ),
        fenix: true,
      );
    }
  }
}
