import 'package:docuflow/data/datasources/remote/reminder_remote_datasource.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/reminder_details_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/reminder_repository.dart';

import '../models/request/reminder_request.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDatasource remoteDataSource;

  ReminderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReminderResponse?>?> getReminderRequestApi(ReminderRequestQuery request) async {
    final response = await remoteDataSource.getReminderList(request);
    return response;
  }

  @override
  Future<SuccessResponse> addReminderApi(Map<String, dynamic> request) async{
    final response = await remoteDataSource.addReminderApi(request);
    return response;
  }

  @override
  Future<ReminderDetailsResponse?> getReminderDetailsList(String reminderId) async{
    final response = await remoteDataSource.getReminderDetailsList(reminderId);
    return response;
  }

  @override
  Future<SuccessResponse> deleteReminder(String reminderId) async{
    final response = await remoteDataSource.deleteReminder(reminderId);
    return response;
  }
}
