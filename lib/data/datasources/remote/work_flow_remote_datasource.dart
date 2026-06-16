import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/request/workflow_comment_request.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';

import '../../models/request/DocumentWorkflowRequest.dart';
import '../../models/request/reminder_request.dart';
import '../../models/response/StartWorkflowResponse.dart';
import '../../models/response/work_flow_response.dart';

abstract class WorkFlowRemoteDatasource {
  Future<List<WorkFlowResponse?>?> getWorkFLowRequestApi(
    DocumentWorkflowRequest request,
  );

  Future<List<WorkFlowResponse?>?> getMyWorkFLowApi();

  Future<WorkFlowDetailsResponse> getWorkFLowDetailsRequestApi(
    String documentId,
  );


  Future<SuccessResponse> cancelWorkflow(String workflowId, String comment);
  Future<SuccessResponse> workflowCommentsApi(WorkflowCommentRequest workflowCommentRequest);
}

class WorkFlowRemoteDataSourceImpl implements WorkFlowRemoteDatasource {
  final ApiClient dioClient;

  WorkFlowRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<WorkFlowResponse?>?> getWorkFLowRequestApi(
    DocumentWorkflowRequest request,
  ) async {

    try {
      final response = await dioClient.get(
        AppConstants.workFLowList,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => WorkFlowResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<WorkFlowDetailsResponse> getWorkFLowDetailsRequestApi(
    String documentId,
  ) async {

    final response = await dioClient.get(
      "${AppConstants.workFLowList}/$documentId/visualWorkflow",
    );
    return WorkFlowDetailsResponse.fromJson(response.data);
  }
  @override
  Future<SuccessResponse> cancelWorkflow(String workflowId, String comment) async {

    try {
      final response = await dioClient.post(
        "${AppConstants.workFLowList}/$workflowId/cancel",
        data: {"comment": comment},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data == [] || response.data.isEmpty) {
          return SuccessResponse(
            status: "Success",
            message: "Workflow cancelled successfully",
          );
        } else {
          return SuccessResponse.fromJson(response.data);
        }
      } else {
        return SuccessResponse(
          message: "Failed to cancel workflow. Please try again.",
          status: "Failure",
        );
      }
    } catch (e) {
      return SuccessResponse(
        message: "An error occurred. Please try again later.",
        status: "Failure",
      );
    }
  }

  @override
  Future<List<WorkFlowResponse?>?> getMyWorkFLowApi() async{

    try {
      final response = await dioClient.get(
        AppConstants.myWorkFLowList,
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => WorkFlowResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> workflowCommentsApi(WorkflowCommentRequest workflowCommentRequest) async{
    try {
      final response = await dioClient.post(
        "${AppConstants.workFLowList}/performNextTransition",
        data: workflowCommentRequest.toJson(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse(
          status: "Success",
          message: "Perform Transition Comments Added successfully",
        );

      } else {
        return SuccessResponse(
          message: "Failed to cancel workflow. Please try again.",
          status: "Failure",
        );
      }
    } catch (e) {
      return SuccessResponse(
        message: "An error occurred. Please try again later.",
        status: "Failure",
      );
    }
  }
}
