import 'package:dio/dio.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/change_password_request.dart';
import 'package:docuflow/data/models/request/edit_profile_request.dart';
import 'package:docuflow/data/models/request/login_request.dart';
import 'package:docuflow/data/models/request/reminder_request_query.dart';
import 'package:docuflow/data/models/response/login_response.dart';
import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/work_flow_details_response.dart';
import 'package:flutter/material.dart';

import '../../models/request/DocumentWorkflowRequest.dart';
import '../../models/request/file_request_add.dart';
import '../../models/request/file_request_query.dart';
import '../../models/response/FileRequestDocumentResponse.dart';
import '../../models/response/file_request_response.dart';
import '../../models/response/work_flow_response.dart';

abstract class FileRequestRemoteDatasource {

  Future<List<FileRequestResponse?>?> getFileRequestApi(
      FileRequestQuery request,
      );

  Future<List<FileRequestDocument?>?> getFileDetailsApi(String fileId);
  Future<SuccessResponse> addFileRequestApi(
      FileRequestAdd request,
  );
  Future<SuccessResponse> copyFileRequestApi(String documentId);

  Future<FileRequestResponse?> fileDetailsRequestApi(String fileIdId);
  Future<SuccessResponse> deleteFileRequestApi(FileRequestResponse request);
}

class FileRequestRemoteDatasourceImpl implements FileRequestRemoteDatasource {
  final ApiClient dioClient;

  FileRequestRemoteDatasourceImpl(this.dioClient);

  @override
  Future<SuccessResponse> addFileRequestApi(FileRequestAdd request) async {

    final bool isEdit = request.id != null && request.id!.isNotEmpty;
    final url = isEdit
        ? "${AppConstants.fileRequest}/${request.id}"
        : AppConstants.fileRequest;

    try {
      Response response;

      if (isEdit) {
        response = await dioClient.put(
          url,
          data: request.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );
      } else {
        response = await dioClient.post(
          url,
          data: request.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: isEdit
              ? "File Request Updated Successfully"
              : "File Request Created Successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );

    } catch (e) {
      print("File Request API Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }


  @override
  Future<List<FileRequestResponse?>?> getFileRequestApi(FileRequestQuery request) async{

    try {
      final response = await dioClient.get(
        AppConstants.fileRequest,
        queryParameters: request.toQueryParams(),
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => FileRequestResponse.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> copyFileRequestApi(String documentId) async{
    try {
      Response  response = await dioClient.get(
        "${AppConstants.fileRequest}/preview/$documentId",
      /*  options: Options(
          contentType: Headers.jsonContentType,
        ),*/
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "File Copied Successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );

    } catch (e) {
      print("File Request API Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }

  }

  @override
  Future<SuccessResponse> deleteFileRequestApi(FileRequestResponse request) async{
    try {
      Response  response = await dioClient.delete(
          "${AppConstants.fileRequest}/${request.id}",
          data: request.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );

      if (response.statusCode == 200 || response.statusCode == 201|| response.statusCode == 204) {
        return SuccessResponse(
          message: "File Deleted Successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );

    } catch (e) {
      print("File Request API Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }
  @override
  Future<List<FileRequestDocument>> getFileDetailsApi(String fileId) async {

    try {
      final response = await dioClient.get(
        "${AppConstants.fileRequestDocument}/$fileId",
      );

      final List data = response.data;

      return data
          .map((item) => FileRequestDocument.fromJson(item))
          .toList();
    } catch (e, stack) {
      debugPrint("getFileDetailsApi error: $e");
      debugPrintStack(stackTrace: stack);
      return <FileRequestDocument>[];
    }
  }

  @override
  Future<FileRequestResponse?> fileDetailsRequestApi(String fileIdId) async{
    try {
      final response = await dioClient.get(
        "${AppConstants.fileRequest}/$fileIdId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is List) {
          // Failure case: []
          if (data.isEmpty) {
            print("❌ No Data found");
            return null;
          } else {
            print("⚠ Unexpected Data response: $data");
            return null;
          }
        }

        if (data is Map<String, dynamic>) {
          print("✅ Shareable link found");
          return FileRequestResponse.fromJson(data);
        }

        print("⚠ Unknown response type: ${data.runtimeType}");
        return null;
      }

      print("⚠ Status code: ${response.statusCode}");
      return null;
    } catch (e, st) {
      print("getFileDetails List Error: $e\n$st");
      return null;
    }
  }

}
