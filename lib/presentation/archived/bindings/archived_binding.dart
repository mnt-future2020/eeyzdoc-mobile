import 'package:docuflow/domain/usecases/archived_usecase.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/presentation/archived/controllers/archived_controller.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:get/get.dart';

class ArchivedBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ArchivedController>()) {
      Get.lazyPut<ArchivedController>(
        () =>
            ArchivedController(archivedUseCase: Get.find<ArchivedUseCase>(),documentsUseCase: Get.find<DocumentsUseCase>()),
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
