import 'package:docuflow/domain/usecases/master_usecase.dart';
import 'package:docuflow/presentation/master/controllers/master_controller.dart';
import 'package:get/get.dart';

class MasterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MasterController>()) {
      Get.lazyPut<MasterController>(
        () => MasterController(masterUseCase: Get.find<MasterUseCase>()),
      );
    }
  }
}
