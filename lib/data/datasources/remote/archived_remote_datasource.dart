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
import '../../models/request/file_request_add.dart';
import '../../models/request/file_request_query.dart';
import '../../models/response/archived_response.dart';
import '../../models/response/file_request_response.dart';
import '../../models/response/work_flow_response.dart';

abstract class ArchivedRemoteDatasource {

  Future<List<ArchivedResponse?>?> getArchivedApi(
      ArchivedRequestQuery request,
      );
  Future<SuccessResponse> sendToRestoreApi(
      String documentId
      );
}

class ArchivedRemoteDatasourceImpl implements ArchivedRemoteDatasource {
  final ApiClient dioClient;

  ArchivedRemoteDatasourceImpl(this.dioClient);


  @override
  Future<List<ArchivedResponse?>?> getArchivedApi(ArchivedRequestQuery request) async{

    try {
      final response = await dioClient.get(
        AppConstants.archivedRequest,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => ArchivedResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> sendToRestoreApi(String documentId) async{

    try {
      final response = await dioClient.put(
        "${AppConstants.archivedRequest}/$documentId/restore",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "Document Restore successfully",
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
