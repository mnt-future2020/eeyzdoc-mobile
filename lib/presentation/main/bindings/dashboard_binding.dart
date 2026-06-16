import 'package:docuflow/domain/usecases/dashboard_usecase.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/document_details_usecase.dart';
import '../../../domain/usecases/documents_usecase.dart';
import '../../../domain/usecases/work_flow_usecase.dart';
import '../../documents/controllers/document_details_controller.dart';
import '../../documents/controllers/documents_controller.dart';
import '../../workflow/controllers/work_flow_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<DashboardController>(
          () => DashboardController(
        dashboardUseCase: Get.find<DashboardUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DocumentsController>(
          () =>
          DocumentsController(documentsUseCase: Get.find<DocumentsUseCase>()),fenix: true,
    );
    Get.lazyPut<WorkFlowController>(
          () => WorkFlowController(
        workFlowUseCase: Get.find<WorkFlowUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DocumentDetailsController>(
          () => DocumentDetailsController(
        documentDetailsUseCase: Get.find<DocumentDetailsUseCase>(),
      ),
      fenix: true,
    );
  }
}
