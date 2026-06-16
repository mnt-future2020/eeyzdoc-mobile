import 'package:docuflow/domain/usecases/dashboard_usecase.dart';
import 'package:docuflow/domain/usecases/reminder_usecase.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:docuflow/presentation/reminder/controllers/reminder_controller.dart';
import 'package:docuflow/presentation/workflow/controllers/work_flow_controller.dart';
import 'package:get/get.dart';

class WorkFlowBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WorkFlowController>()) {
      Get.lazyPut<WorkFlowController>(
        () =>
            WorkFlowController(workFlowUseCase: Get.find<WorkFlowUseCase>()),
      );
    }
  }
}
