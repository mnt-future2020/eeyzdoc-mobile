
import 'package:docuflow/data/models/response/success_response.dart';
import '../../data/models/request/archived_request_query.dart';
import '../../data/models/request/file_request_add.dart';
import '../../data/models/request/file_request_query.dart';
import '../../data/models/response/archived_response.dart';
import '../../data/models/response/file_request_response.dart';
import '../repositories/archived_repository.dart';
import '../repositories/file_request_repository.dart';

class ArchivedUseCase {
  final ArchivedRepository repository;

  ArchivedUseCase(this.repository);

  Future<List<ArchivedResponse?>?> getArchivedApi(ArchivedRequestQuery request) async {
    return await repository.getArchivedApi(request);
  }

  Future<SuccessResponse> sendToRestoreApi( String documentId) async {
    return await repository.sendToRestoreApi(documentId);
  }

}
