import 'package:docuflow/domain/usecases/document_details_usecase.dart';
import 'package:docuflow/domain/usecases/documents_usecase.dart';
import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:get/get.dart';

import '../controllers/DocumentFilterController.dart';
import '../controllers/ShareableLinkController.dart';

class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DocumentsController>()) {
      Get.lazyPut<DocumentsController>(
        () =>
            DocumentsController(documentsUseCase: Get.find<DocumentsUseCase>()),
      );
      if (!Get.isRegistered<ShareableLinkController>()) {
        Get.lazyPut(() => ShareableLinkController(), fenix: true);
      }

      if (!Get.isRegistered<DocumentFilterController>()) {
        Get.lazyPut(() => DocumentFilterController(), fenix: true);
      }
    }
  }
}

class DocumentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DocumentDetailsController>()) {
      Get.lazyPut<DocumentDetailsController>(
        () => DocumentDetailsController(
          documentDetailsUseCase: Get.find<DocumentDetailsUseCase>(),
        ),
      );
    }
  }
}
