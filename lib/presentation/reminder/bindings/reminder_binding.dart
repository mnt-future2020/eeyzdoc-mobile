import 'package:docuflow/domain/usecases/dashboard_usecase.dart';
import 'package:docuflow/domain/usecases/reminder_usecase.dart';
import 'package:docuflow/presentation/main/controllers/dashboard_controller.dart';
import 'package:docuflow/presentation/reminder/controllers/reminder_controller.dart';
import 'package:get/get.dart';

class ReminderBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReminderController>()) {
      Get.lazyPut<ReminderController>(
        () =>
            ReminderController(reminderUseCase: Get.find<ReminderUseCase>()),
      );
    }
  }
}
