
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';

import 'package:docuflow/domain/repositories/work_flow_repository.dart';

import '../../data/models/request/DocumentWorkflowRequest.dart';
import '../../data/models/request/reminder_request_query.dart';
import '../../data/models/request/workflow_comment_request.dart';
import '../../data/models/response/StartWorkflowResponse.dart';
import '../../data/models/response/work_flow_response.dart';

class WorkFlowUseCase {
  final WorkFlowRepository repository;

  WorkFlowUseCase(this.repository);

  Future<List<WorkFlowResponse?>?> getWorkFLowRequestApi(DocumentWorkflowRequest request) async {
    return await repository.getWorkFLowRequestApi(request);
  }
  Future<List<WorkFlowResponse?>?> getMyWorkFLowApi() async {
    return await repository.getMyWorkFLowApi();
  }

  Future<WorkFlowDetailsResponse> getWorkFLowDetailsRequestApi(String documentId) async {
    return await repository.getWorkFLowDetailsRequestApi(documentId);
  }


  Future<SuccessResponse?> cancelWorkflow(String workflowId, String comment) async {
    return await repository.cancelWorkflow(workflowId,comment);
  }

  Future<SuccessResponse?> workflowCommentsApi(WorkflowCommentRequest workflowCommentRequest) async {
    return await repository.workflowCommentsApi(workflowCommentRequest);
  }

}
