
import 'package:docuflow/data/datasources/remote/work_flow_remote_datasource.dart';
import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/request/workflow_comment_request.dart';
import 'package:docuflow/data/models/response/StartWorkflowResponse.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/data/models/response/work_flow_response.dart';
import 'package:docuflow/domain/repositories/work_flow_repository.dart';

class WorkflowRepositoryImpl implements WorkFlowRepository {
  final WorkFlowRemoteDatasource remoteDataSource;

  WorkflowRepositoryImpl(this.remoteDataSource);



  @override
  Future<List<WorkFlowResponse?>?> getWorkFLowRequestApi(DocumentWorkflowRequest request) async{
    final response = await remoteDataSource.getWorkFLowRequestApi(request);
    return response;
  }

  @override
  Future<WorkFlowDetailsResponse> getWorkFLowDetailsRequestApi(String documentId) async{
    final response = await remoteDataSource.getWorkFLowDetailsRequestApi(documentId);
    return response;
  }

  @override
  Future<SuccessResponse> cancelWorkflow(String workflowId, String comment) async{
    final response = await remoteDataSource.cancelWorkflow(workflowId,comment);
    return response;
  }

  @override
  Future<List<WorkFlowResponse?>?> getMyWorkFLowApi() async{
    final response = await remoteDataSource.getMyWorkFLowApi();
    return response;
  }

  @override
  Future<SuccessResponse> workflowCommentsApi(WorkflowCommentRequest workflowCommentRequest) async{
    final response = await remoteDataSource.workflowCommentsApi(workflowCommentRequest);
    return response;
  }

}
