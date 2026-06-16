import 'package:docuflow/domain/usecases/dashboard_usecase.dart';
import 'package:docuflow/domain/usecases/file_request_usecase.dart';
import 'package:docuflow/domain/usecases/reminder_usecase.dart';
import 'package:docuflow/domain/usecases/work_flow_usecase.dart';
import 'package:docuflow/presentation/filerequest/controllers/file_request_controller.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:docuflow/presentation/reminder/controllers/reminder_controller.dart';
import 'package:docuflow/presentation/workflow/controllers/work_flow_controller.dart';
import 'package:get/get.dart';

class FileRequestBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FileRequestController>()) {
      Get.lazyPut<FileRequestController>(
        () =>
            FileRequestController(fileRequestUseCase: Get.find<FileRequestUseCase>()),
      );
    }
  }
}
