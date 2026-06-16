import 'package:docuflow/data/models/request/DocumentWorkflowRequest.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/archived_response.dart';
import 'package:docuflow/data/models/response/file_request_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:docuflow/data/models/response/work_flow_response.dart';

import '../../data/models/request/archived_request_query.dart';
import '../../data/models/request/file_request_add.dart';

abstract class ArchivedRepository {
  Future<List<ArchivedResponse?>?> getArchivedApi(
      ArchivedRequestQuery request,
  );
  Future<SuccessResponse> sendToRestoreApi(
      String documentId
  );
}
