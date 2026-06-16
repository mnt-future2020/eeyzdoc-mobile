import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/reminder_details_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';

import '../../models/request/reminder_request.dart';

abstract class ReminderRemoteDatasource {
  Future<List<ReminderResponse?>?> getReminderList(
    ReminderRequestQuery request,
  );

  Future<ReminderDetailsResponse?> getReminderDetailsList(String reminderId);

  Future<SuccessResponse> addReminderApi(Map<String, dynamic> request);

  Future<SuccessResponse> deleteReminder(String reminderId);

}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDatasource {
  final ApiClient dioClient;

  ReminderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ReminderResponse?>?> getReminderList(
    ReminderRequestQuery request,
  ) async {

    try {
      final response = await dioClient.get(
        AppConstants.reminderList,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => ReminderResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> addReminderApi(Map<String, dynamic> request) async {
    var id=request['id'];
    final bool isEdit = id != null && id.isNotEmpty;
    final url = isEdit
        ? "${AppConstants.reminder}/$id"
        : AppConstants.reminder;

    try {
      Response response;

      if (isEdit) {
        response = await dioClient.put(
          url,
          data: request,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );
      } else {
        response = await dioClient.post(
          url,
          data: request,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: isEdit
              ? "Reminder Updated Successfully"
              : "Reminder Created Successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );

    } catch (e) {
      print("Reminder Request API Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }

  @override
  Future<ReminderDetailsResponse?> getReminderDetailsList(
    String reminderId,
  ) async {

    try {
      final response = await dioClient.get(
        "${AppConstants.reminder}/$reminderId",
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode == 200) {
        return ReminderDetailsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<SuccessResponse> deleteReminder(String reminderId) async{
    try {
      Response response = await dioClient.delete(
        "${AppConstants.reminder}/$reminderId",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return SuccessResponse(
          message: "Reminder Deleted Successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Reminder API Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }
}
