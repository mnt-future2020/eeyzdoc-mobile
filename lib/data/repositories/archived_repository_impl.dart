import 'package:docuflow/data/datasources/remote/file_request_remote_datasource.dart';
import 'package:docuflow/data/models/request/archived_request_query.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/response/archived_response.dart';
import 'package:docuflow/data/models/response/file_request_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/archived_repository.dart';
import 'package:docuflow/domain/repositories/file_request_repository.dart';


import '../datasources/remote/archived_remote_datasource.dart';
import '../models/request/file_request_add.dart';

class ArchivedRepositoryImpl implements ArchivedRepository {
  final ArchivedRemoteDatasource remoteDataSource;

  ArchivedRepositoryImpl(this.remoteDataSource);


  @override
  Future<List<ArchivedResponse?>?> getArchivedApi(ArchivedRequestQuery request) async{
    final response = await remoteDataSource.getArchivedApi(request);
    return response;
  }

  @override
  Future<SuccessResponse> sendToRestoreApi(String documentId) async{
    final response = await remoteDataSource.sendToRestoreApi(documentId);
    return response;
  }

}
