
import 'package:docuflow/data/models/response/FileRequestDocumentResponse.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import '../../data/models/request/file_request_add.dart';
import '../../data/models/request/file_request_query.dart';
import '../../data/models/response/file_request_response.dart';
import '../repositories/file_request_repository.dart';

class FileRequestUseCase {
  final FileRequestRepository repository;

  FileRequestUseCase(this.repository);

  Future<List<FileRequestResponse?>?> getFileRequestApi(FileRequestQuery request) async {
    return await repository.getFileRequestApi(request);
  }

  Future<List<FileRequestDocument?>?> getFileDetailsApi(String fileId) async {
    return await repository.getFileDetailsApi(fileId);
  }

  Future<SuccessResponse?> addFileRequestApi(FileRequestAdd request) async {
    return await repository.addFileRequestApi(request);
  }

  Future<FileRequestResponse?> fileDetailsRequestApi(String fileIdId) async{
    return await repository.fileDetailsRequestApi(fileIdId);
  }

  Future<SuccessResponse?> copyFileRequestApi(String documentId) async {
    return await repository.copyFileRequestApi(documentId);
  }


  Future<SuccessResponse?> deleteFileRequestApi(FileRequestResponse request) async {
    return await repository.deleteFileRequestApi(request);
  }



}
