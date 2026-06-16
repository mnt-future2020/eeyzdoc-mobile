import 'package:docuflow/data/datasources/remote/file_request_remote_datasource.dart';
import 'package:docuflow/data/models/request/file_request_query.dart';
import 'package:docuflow/data/models/response/FileRequestDocumentResponse.dart';
import 'package:docuflow/data/models/response/file_request_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/domain/repositories/file_request_repository.dart';


import '../models/request/file_request_add.dart';

class FileRequestRepositoryImpl implements FileRequestRepository {
  final FileRequestRemoteDatasource remoteDataSource;

  FileRequestRepositoryImpl(this.remoteDataSource);



  @override
  Future<SuccessResponse> addFileRequestApi(FileRequestAdd request) async{
    final response = await remoteDataSource.addFileRequestApi(request);
    return response;
  }


  @override
  Future<List<FileRequestResponse?>?> getFileRequestApi(FileRequestQuery request) async{
    final response = await remoteDataSource.getFileRequestApi(request);
    return response;
  }

  @override
  Future<SuccessResponse> copyFileRequestApi(String documentId) async{
    final response = await remoteDataSource.copyFileRequestApi(documentId);
    return response;
  }

  @override
  Future<FileRequestResponse?> fileDetailsRequestApi(String fileIdId) async{
    final response = await remoteDataSource.fileDetailsRequestApi(fileIdId);
    return response;
  }

  @override
  Future<SuccessResponse> deleteFileRequestApi(FileRequestResponse request) async{
    final response = await remoteDataSource.deleteFileRequestApi(request);
    return response;
  }

  @override
  Future<List<FileRequestDocument?>?> getFileDetailsApi(String fileId) async{
    final response = await remoteDataSource.getFileDetailsApi(fileId);
    return response;
  }
}
