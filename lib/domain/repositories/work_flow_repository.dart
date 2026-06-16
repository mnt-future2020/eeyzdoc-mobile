import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/data/models/response/work_flow_response.dart';

import '../../data/models/request/workflow_comment_request.dart';
import '../../data/models/response/StartWorkflowResponse.dart';

abstract class WorkFlowRepository {
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
