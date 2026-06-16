import 'package:docuflow/domain/usecases/archived_usecase.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/presentation/archived/controllers/archived_controller.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:docuflow/presentation/expired/controllers/expired_controller.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/expired_usecase.dart';

class ExpiredBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpiredController>()) {
      Get.lazyPut<ExpiredController>(
        () => ExpiredController(
          expiredUseCase: Get.find<ExpiredUseCase>(),
          documentsUseCase: Get.find<DocumentsUseCase>(),
        ),
      );
    }
    if (!Get.isRegistered<DocumentsController>()) {
      Get.lazyPut<DocumentsController>(
        () =>
            DocumentsController(documentsUseCase: Get.find<DocumentsUseCase>()),
      );
    }
  }
}
