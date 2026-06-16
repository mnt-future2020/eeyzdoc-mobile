import 'package:docuflow/data/datasources/remote/expired_remote_datasource.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/expired_repository.dart';
import '../models/request/expired_request_query.dart';
import '../models/response/expired_response.dart';

class ExpiredRepositoryImpl implements ExpiredRepository {
  final ExpiredRemoteDatasource remoteDataSource;

  ExpiredRepositoryImpl(this.remoteDataSource);


  @override
  Future<List<ExpiredResponse?>?> getExpiredApi(ExpiredRequestQuery request) async{
    final response = await remoteDataSource.getExpiredApi(request);
    return response;
  }

  @override
  Future<SuccessResponse> sendToActiveApi(String documentId) async{
    final response = await remoteDataSource.sendToActiveApi(documentId);
    return response;
  }

}
