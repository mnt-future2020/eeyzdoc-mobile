
import 'package:docuflow/data/models/response/success_response.dart';
import '../../data/models/request/archived_request_query.dart';
import '../../data/models/request/expired_request_query.dart';
import '../../data/models/request/file_request_add.dart';
import '../../data/models/request/file_request_query.dart';
import '../../data/models/response/archived_response.dart';
import '../../data/models/response/expired_response.dart';
import '../../data/models/response/file_request_response.dart';
import '../repositories/archived_repository.dart';
import '../repositories/expired_repository.dart';
import '../repositories/file_request_repository.dart';

class ExpiredUseCase {
  final ExpiredRepository repository;

  ExpiredUseCase(this.repository);

  Future<List<ExpiredResponse?>?> getExpiredApi(ExpiredRequestQuery request) async {
    return await repository.getExpiredApi(request);
  }

  Future<SuccessResponse> sendToActiveApi( String documentId) async {
    return await repository.sendToActiveApi(documentId);
  }

}
