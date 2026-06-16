import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docuflow/core/services/api_client_service.dart';
import 'package:docuflow/data/models/request/document_filter_request.dart';
import 'package:docuflow/data/models/request/document_request.dart';
import 'package:docuflow/data/models/response/StartWorkflowResponse.dart';
import 'package:docuflow/data/models/response/comment_model.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/document_status.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:flutter/material.dart';

import '../../../constants/PreferenceUtils.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/request/ShareableLinkRequest.dart';
import '../../models/request/document_role_permision_request.dart';
import '../../models/request/edit_document_request.dart';
import '../../models/request/share_document_request.dart';
import '../../models/response/CategoryDropDownResponse.dart';
import '../../models/response/ShareableLinkResponse.dart';
import '../../models/response/clientDropdownResponse.dart';
import '../../models/response/document_meta_tag.dart';
import '../../models/response/share_document_role_response.dart';
import '../../models/response/success_response.dart';
import '../../repositories/SignatureModel.dart';
import 'package:path/path.dart' as p;

abstract class DocumentsRemoteDataSource {
  Future<void> addDocument(DocumentRequest document);

  Future<SuccessResponse> editDocument(String documentId, String operationName);

  Future<SuccessResponse> deleteDocumentApi(
    String documentId,
    String documentType,
  );

  Future<SuccessResponse> deleteSharableLinkApi(String documentId);

  Future<SuccessResponse> updateDocument(
    EditDocumentRequest editDocumentRequest,
  );

  Future<List<StartWorkflowResponse?>?> starWorkFLowListApi();

  Future<List<SignatureModel?>?> getDocumentSignatureList(String documentId);

  Future<List<DocumentMetaTag?>?> getDocumentMetaTagList(String documentId);

  Future<List<ShareDocumentRoleResponse?>?> shareRolePermissionListApi(
    String documentId,
  );

  Future<SuccessResponse> shareDocumentPermissionDeleteApi(
    String documentId,
    String shareType,
  );

  Future<ShareableLinkResponse?> getShareableLink(String documentId);

  Future<SuccessResponse> createShareableLink(
    ShareableLinkRequest shareableLinkRequest,
  );

  Future<SuccessResponse> shareDocumentPermissionRequestApi(
    DocumentSharePermissionRequest documentRolePermissionRequest,
  );

  Future<SuccessResponse> shareDocumentRequestApi(
    ShareDocumentRequest shareDocumentRequest,
  );

  Future<DocumentResponse?> getDocument(int id);

  Future<List<DocumentResponse?>?> getDocuments(DocumentFilterRequest filter);

  Future<SuccessResponse> documentSignatureApi(
    String documentId,
    String signatureUrl,
  );

  Future<SuccessResponse> starWorkFLowApi(String name, String description);

  Future<SuccessResponse> starWorkFLowCreateApi(
    String documentId,
    String workflowId,
  );


  Future<SuccessResponse> operationNameApi(
    String documentId,
    String operationName,
  );

  Future<SuccessResponse> uploadNewVersionApi(
    String documentId,
    String location,
    File file,
  );

  Future<List<UserDropdownResponse?>?> getUsers();

  Future<List<RoleDropdownResponse?>?> getRoles();

  Future<List<ClientDropdownResponse?>?> getClients();

  Future<List<CategoryDropdownResponse?>?> getCategory();

  Future<List<DocumentStatus?>?> getDocumentStatus();


  Future<CommentModel> addComment(String documentId,String comments);
  Future<List<CommentModel?>?> getCommentList(String documentId);
  Future<SuccessResponse> deleteComment(String commentId);

}

class DocumentsRemoteDataSourceImpl implements DocumentsRemoteDataSource {
  final ApiClient dioClient;

  DocumentsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> addDocument(DocumentRequest document) async {
    final formData = FormData.fromMap({
      "name":
         document.name,
      "categoryId": document.categoryId,
      "categoryName": document.categoryName,
      "location": "local",
      "description": document.description,
      "statusId": document.statusId,
      "clientId": document.clientId,
      "retentionPeriod": document.retentionPeriod,
      "retentionAction": document.retentionAction,
      "isIndexed": true,
      "documentMetaDatas": document.documentMetaDatas.isEmpty
          ? "[]"
          : jsonEncode(document.documentMetaDatas),
      "documentRolePermissions": document.documentRolePermissions.isEmpty
          ? "[]"
          : jsonEncode(document.documentRolePermissions),
      "documentUserPermissions": document.documentUserPermissions.isEmpty
          ? "[]"
          : jsonEncode(document.documentUserPermissions),
      "html_content": "",
      "uploadFile": await MultipartFile.fromFile(
        document.uploadFile!.path,
        filename:
            p.basename(document.uploadFile!.path),
      ),
    });

    final response = await dioClient.post(
      '/api/document',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  @override
  Future<DocumentResponse?> getDocument(int id) {
    // TODO: implement getDocument
    throw UnimplementedError();
  }
  @override
  Future<List<DocumentResponse>> getDocuments(
      DocumentFilterRequest filter,
      ) async {
    final assigned = filter.assignedDocuments == true;

    final endpoint = assigned
        ? "/api/document/assignedDocuments"
        : "/api/documents";

    final response = await dioClient.get(
      endpoint,
      queryParameters: filter.toQuery(),
    );

    // ✅ If API success but empty → return empty list
    final List data = response.data ?? [];

    return data
        .map((item) => DocumentResponse.fromJson(item))
        .toList();
  }


  @override
  Future<void> deleteDocument(int id) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDocuments() {
    // TODO: implement deleteDocuments
    throw UnimplementedError();
  }

  @override
  Future<SuccessResponse> documentSignatureApi(
    String documentId,
    String signatureUrl,
  ) async {

    var data = {'documentId': documentId, 'signatureUrl': signatureUrl};

    try {
      final response = await dioClient.post(
        AppConstants.documentSignatureApi,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "Signature Save Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }

  @override
  Future<SuccessResponse> starWorkFLowApi(
    String name,
    String description,
  ) async {

    var data = {'name': name, 'description': description};

    try {
      final response = await dioClient.post(
        AppConstants.startWorkFLowApi,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "Start WorkFlow Saved Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }


  @override
  Future<SuccessResponse> operationNameApi(
    String documentId,
    String operationName,
  ) async {

    var data = {'documentId': documentId, 'operationName': operationName};

    try {
      final response = await dioClient.post(
        AppConstants.operationApi,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "$operationName File Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }

  @override
  Future<SuccessResponse> uploadNewVersionApi(
    String documentId,
    String location,
    File file,
  ) async {

    FormData formData = FormData.fromMap({
      "uploadFile": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      "documentId": documentId,
      "location": location,
    });

    try {
      final response = await dioClient.post(
        AppConstants.documentVersionApi,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "Upload New Version Saved Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }

  @override
  Future<List<UserDropdownResponse?>?> getUsers() async {
    final response = await dioClient.get('/api/user-dropdown');

    final List data = response.data;

    if (data.isNotEmpty) {
      return data.map((item) => UserDropdownResponse.fromJson(item)).toList();
    } else {
      throw Exception('Error: get user dropdown');
    }
  }

  @override
  Future<List<RoleDropdownResponse?>?> getRoles() async {
    final response = await dioClient.get('/api/role-dropdown');

    final List data = response.data;

    if (data.isNotEmpty) {
      return data.map((item) => RoleDropdownResponse.fromJson(item)).toList();
    } else {
      throw Exception('Error: get user dropdown');
    }
  }

  @override
  Future<SuccessResponse> editDocument(
    String documentId,
    String operationName,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.operationApi,
        queryParameters: {
          'documentId': documentId,
          'operationName': operationName,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "File Edit Successfully",
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
  Future<SuccessResponse> shareDocumentRequestApi(
    ShareDocumentRequest shareDocumentRequest,
  ) async {
    try {
      Response response = await dioClient.post(
        AppConstants.shareApi,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "Document Shared Successfully",
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
  Future<List<SignatureModel>?> getDocumentSignatureList(
    String documentId,
  ) async {

    try {
      final response = await dioClient.get(
        "${AppConstants.documentSignatureApi}/$documentId",
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => SignatureModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<ShareDocumentRoleResponse?>?> shareRolePermissionListApi(
    String documentId,
  ) async {

    try {
      final response = await dioClient.get(
        "${AppConstants.shareRoleListApi}/$documentId",
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data
            .map((item) => ShareDocumentRoleResponse.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> shareDocumentPermissionRequestApi(
    DocumentSharePermissionRequest documentRolePermissionRequest,
  ) async {
    try {
      Response response = await dioClient.post(
        documentRolePermissionRequest.documentRolePermissions == null
            ? AppConstants.shareDocumentUserPermissionApi
            : AppConstants.shareDocumentRolePermissionApi,
        data: documentRolePermissionRequest.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "Shared Document Permissions Successfully",
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
  Future<SuccessResponse> shareDocumentPermissionDeleteApi(
    String documentId,
    String shareType,
  ) async {
    try {
      Response response = await dioClient.delete(
        shareType == "Role"
            ? "${AppConstants.shareDocumentRolePermissionApi}/$documentId"
            : "${AppConstants.shareDocumentUserPermissionApi}/$documentId",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return SuccessResponse(
          message: "Share Role Deleted Successfully",
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
  Future<List<ClientDropdownResponse?>?> getClients() async {
    final response = await dioClient.get('/api/clients');

    final List data = response.data;

    if (data.isNotEmpty) {
      return data.map((item) => ClientDropdownResponse.fromJson(item)).toList();
    } else {
      throw Exception('Error: get user dropdown');
    }
  }

  @override
  Future<List<CategoryDropdownResponse?>?> getCategory() async {
    final response = await dioClient.get('/api/category/dropdown');

    final List data = response.data;

    if (data.isNotEmpty) {
      return data
          .map((item) => CategoryDropdownResponse.fromJson(item))
          .toList();
    } else {
      throw Exception('Error: get user dropdown');
    }
  }

  @override
  Future<SuccessResponse> updateDocument(
    EditDocumentRequest editDocumentRequest,
  ) async {
    final body = {
      "id": editDocumentRequest.id,
      "name": editDocumentRequest.name,
      "description": emptyToNull(editDocumentRequest.description),
      "categoryId": emptyToNull(editDocumentRequest.categoryId),
      "clientId": emptyToNull(editDocumentRequest.clientId),
      "statusId": editDocumentRequest.statusId,
      "retentionPeriod": editDocumentRequest.retentionPeriod,
      "retentionAction": editDocumentRequest.retentionAction,
      "documentMetaDatas": editDocumentRequest.documentMetaDatas
          .map((e) => e.toJson())
          .toList(),
    };


    log("Pay Load : $body");

    try {
      final response = await dioClient.put(
        "${AppConstants.documentApi}/${editDocumentRequest.id}",
        data: body,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      if (response.statusCode == 200) {
        return SuccessResponse(
          message: "Document updated successfully",
          status: "Success",
        );
      }

      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Update Error: $e");
      return SuccessResponse(message: "Error updating", status: "Failure");
    }
  }

  @override
  Future<SuccessResponse> deleteDocumentApi(
    String documentId,
    String documentType,
  ) async {
    try {
      Response response = await dioClient.delete(
        documentType == "Delete"
            ? "${AppConstants.documentApi}/$documentId"
            : "${AppConstants.documentApi}/$documentId/archive",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return SuccessResponse(
          message: "Document $documentType Successfully",
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
  Future<List<StartWorkflowResponse?>?> starWorkFLowListApi() async {
    final response = await dioClient.get(AppConstants.startWorkFLowApi);

    final List data = response.data;

    if (data.isNotEmpty) {
      return data.map((item) => StartWorkflowResponse.fromJson(item)).toList();
    } else {
      throw Exception('Error: get WorkflowResponse dropdown');
    }
  }

  @override
  Future<SuccessResponse> starWorkFLowCreateApi(
    String documentId,
    String workflowId,
  ) async {

    var data = {'documentId': documentId, 'workflowId': workflowId};

    try {
      final response = await dioClient.post(
        AppConstants.workFLowList,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "Start WorkFlow Saved Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }
  }

  @override
  Future<SuccessResponse> createShareableLink(
    ShareableLinkRequest request,
  ) async {


    try {
      final response = await dioClient.post(
        AppConstants.documentShareableLink,
        data: request.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SuccessResponse(
          message: "${request.message} Successfully",
          status: "Success",
        );
      }
      return SuccessResponse(
        message: "Server Error: ${response.statusCode}",
        status: "Failure",
      );
    } catch (e) {
      print("Error: $e");
      return SuccessResponse(
        message: "Error occurred. Please try again.",
        status: "Failure",
      );
    }

  }

  @override
  Future<ShareableLinkResponse?> getShareableLink(String documentId) async {

    try {
      final response = await dioClient.get(
        "${AppConstants.documentShareableLink}/$documentId",
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          // Failure case: []
          if (data.isEmpty) {
            print("❌ No shareable link found");
            return null;
          } else {
            print("⚠ Unexpected List response: $data");
            return null;
          }
        }

        if (data is Map<String, dynamic>) {
          print("✅ Shareable link found");
          return ShareableLinkResponse.fromJson(data);
        }

        print("⚠ Unknown response type: ${data.runtimeType}");
        return null;
      }

      print("⚠ Status code: ${response.statusCode}");
      return null;
    } catch (e, st) {
      print("getShareableLink Error: $e\n$st");
      return null;
    }
  }


  @override
  Future<List<DocumentStatus?>?> getDocumentStatus() async{
    final response = await dioClient.get('/api/document-status');

    final List data = response.data;

    if (data.isNotEmpty) {
      return data.map((item) => DocumentStatus.fromJson(item)).toList();
    } else {
      throw Exception('Error: get user dropdown');
    }
  }

  @override
  Future<List<DocumentMetaTag?>?> getDocumentMetaTagList(String documentId) async{

    try {
      final response = await dioClient.get(
        "${AppConstants.documentApi}/$documentId/getMetatag",
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => DocumentMetaTag.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<SuccessResponse> deleteSharableLinkApi(String documentId) async{
    try {
      Response response = await dioClient.delete(
       "${AppConstants.documentShareableLink}/$documentId",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201|| response.statusCode == 204) {
        return SuccessResponse(
          message: "Link deleted successfully",
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
  dynamic emptyToNull(dynamic value) {
    if (value is String && value.trim().isEmpty) {
      return null;
    }
    return value;
  }
  @override
  Future<CommentModel> addComment(
      String documentId,
      String comment,
      ) async {

    final data = {
      "documentId": documentId,
      "comment": comment,
    };

    try {
      final response = await dioClient.post(
        AppConstants.commentApi,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CommentModel.fromJson(response.data);
      }

      throw Exception("Server Error: ${response.statusCode}");
    } catch (e) {
      debugPrint("Add Comment Error: $e");
      rethrow;
    }
  }

  @override
  Future<SuccessResponse> deleteComment(String commentId) async{
    try {
      Response response = await dioClient.delete(
        "${AppConstants.commentApi}/$commentId",
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201|| response.statusCode == 204) {
        return SuccessResponse(
          message: "Comment deleted successfully",
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
  Future<List<CommentModel?>?> getCommentList(String documentId) async{

    try {
      final response = await dioClient.get(
        "${AppConstants.commentApi}/$documentId",
      );

      final List data = response.data;

      if (data.isNotEmpty) {
        return data.map((item) => CommentModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
