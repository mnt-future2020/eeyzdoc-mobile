import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';

import '../../data/models/request/reminder_request.dart';
import '../../data/models/response/reminder_details_response.dart';

abstract class ReminderRepository {
  Future<List<ReminderResponse?>?> getReminderRequestApi(
    ReminderRequestQuery request,
  );
  Future<SuccessResponse> addReminderApi(
      Map<String, dynamic> request,
  );
  Future<ReminderDetailsResponse?> getReminderDetailsList(String reminderId);
  Future<SuccessResponse> deleteReminder(String reminderId);

}
