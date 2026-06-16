
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/reminder_repository.dart';

import '../../data/models/request/reminder_request.dart';
import '../../data/models/request/reminder_request_query.dart';
import '../../data/models/response/reminder_details_response.dart';
import '../../data/models/response/reminder_response.dart';

class ReminderUseCase {
  final ReminderRepository repository;

  ReminderUseCase(this.repository);

  Future<List<ReminderResponse?>?> getReminderRequestApi(ReminderRequestQuery request) async {
    return await repository.getReminderRequestApi(request);
  }
  Future<ReminderDetailsResponse?> getReminderDetailsList(String reminderId) async {
    return await repository.getReminderDetailsList(reminderId);
  }
  Future<SuccessResponse?> addReminderApi(Map<String, dynamic> request) async {
    return await repository.addReminderApi(request);
  }

  Future<SuccessResponse?> deleteReminder(String reminderId) async {
    return await repository.deleteReminder(reminderId);
  }

}
