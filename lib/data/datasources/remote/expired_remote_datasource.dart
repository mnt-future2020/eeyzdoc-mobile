import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';

import '../../models/request/DocumentWorkflowRequest.dart';
import '../../models/request/archived_request_query.dart';
import '../../models/request/expired_request_query.dart';
import '../../models/request/file_request_add.dart';
import '../../models/request/file_request_query.dart';
import '../../models/response/archived_response.dart';
import '../../models/response/expired_response.dart';
import '../../models/response/file_request_response.dart';
import '../../models/response/work_flow_response.dart';

abstract class ExpiredRemoteDatasource {

  Future<List<ExpiredResponse?>?> getExpiredApi(
      ExpiredRequestQuery request,
      );
  Future<SuccessResponse> sendToActiveApi(
      String documentId
      );
}

class ExpiredRemoteDatasourceImpl implements ExpiredRemoteDatasource {
  final ApiClient dioClient;

  ExpiredRemoteDatasourceImpl(this.dioClient);


  @override
  Future<List<ExpiredResponse?>?> getExpiredApi(ExpiredRequestQuery request) async{

    try {
      final response = await dioClient.get(
        AppConstants.expiredRequest,
        queryParameters: request.toJson(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => ExpiredResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> sendToActiveApi(String documentId) async{

    try {
      final response = await dioClient.put(
        "${AppConstants.expiredRequest}/$documentId/active",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "Document Active successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Update Error: $e");
      return SuccessResponse(message: "Error updating", status: "Failure");
    }
  }


}
