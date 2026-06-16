import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/file_request_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/data/models/response/work_flow_response.dart';

import '../../data/models/request/file_request_add.dart';
import '../../data/models/response/FileRequestDocumentResponse.dart';

abstract class FileRequestRepository {
  Future<List<FileRequestResponse?>?> getFileRequestApi(
    FileRequestQuery request,
  );

  Future<List<FileRequestDocument?>?> getFileDetailsApi(String fileId);

  Future<SuccessResponse> addFileRequestApi(FileRequestAdd request);

  Future<SuccessResponse> copyFileRequestApi(String documentId);

  Future<FileRequestResponse?> fileDetailsRequestApi(String fileIdId);

  Future<SuccessResponse> deleteFileRequestApi(FileRequestResponse request);
}
