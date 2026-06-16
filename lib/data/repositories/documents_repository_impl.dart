import 'dart:io';

import 'package:docuflow/data/datasources/remote/Documents_remote_datasource.dart';
import 'package:docuflow/data/models/request/document_filter_request.dart';
import 'package:docuflow/data/models/request/document_request.dart';
import 'package:docuflow/data/models/request/share_document_request.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:docuflow/domain/repositories/Documents_repository.dart';

import '../models/request/ShareableLinkRequest.dart';
import '../models/request/document_role_permision_request.dart';
import '../models/request/edit_document_request.dart';
import '../models/response/CategoryDropDownResponse.dart';
import '../models/response/ShareableLinkResponse.dart';
import '../models/response/StartWorkflowResponse.dart';
import '../models/response/clientDropdownResponse.dart';
import '../models/response/comment_model.dart';
import '../models/response/document_meta_tag.dart';
import '../models/response/document_status.dart';
import '../models/response/share_document_role_response.dart';
import 'SignatureModel.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsRemoteDataSource remoteDataSource;

  DocumentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addDocument(DocumentRequest document) async {
    await remoteDataSource.addDocument(document);
  }

  @override
  Future<List<DocumentResponse?>?> getDocuments(
    DocumentFilterRequest filter,
  ) async {
    final responseList = await remoteDataSource.getDocuments(filter);
    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<DocumentResponse>().toList();
    return cleanedList;
  }

  @override
  Future<SuccessResponse> documentSignatureApi(
    String documentId,
    String signatureUrl,
  ) async {
    final response = await remoteDataSource.documentSignatureApi(
      documentId,
      signatureUrl,
    );
    return response;
  }



  @override
  Future<SuccessResponse> operationNameApi(
    String documentId,
    String operationName,
  ) async {
    final response = await remoteDataSource.operationNameApi(
      documentId,
      operationName,
    );
    return response;
  }

  @override
  Future<SuccessResponse> uploadNewVersionApi(
    String documentId,
    String location,
    File file,
  ) async {
    final response = await remoteDataSource.uploadNewVersionApi(
      documentId,
      location,
      file,
    );
    return response;
  }

  @override
  Future<void> deleteAllDocuments() {
    // TODO: implement deleteAllDocuments
    throw UnimplementedError();
  }


  @override
  Future<SuccessResponse> starWorkFLowApi(
    String name,
    String description,
  ) async {
    final response = await remoteDataSource.starWorkFLowApi(name, description);
    return response;
  }

  @override
  Future<List<UserDropdownResponse>?> getUsers() async {
    final responseList = await remoteDataSource.getUsers();

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<UserDropdownResponse>().toList();
    return cleanedList;
  }


  @override
  Future<List<ClientDropdownResponse>?> getClients() async {
    final responseList = await remoteDataSource.getClients();

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<ClientDropdownResponse>().toList();
    return cleanedList;
  }

  @override
  Future<List<CategoryDropdownResponse>?> getCategory() async {
    final responseList = await remoteDataSource.getCategory();

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<CategoryDropdownResponse>().toList();
    return cleanedList;
  }

  @override
  Future<List<RoleDropdownResponse>?> getRoles() async {
    final responseList = await remoteDataSource.getRoles();
    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<RoleDropdownResponse>().toList();
    return cleanedList;
  }

  @override
  Future<SuccessResponse> editDocument(String documentId, String operationName) async{
    final response = await remoteDataSource.editDocument(documentId, operationName);
    return response;
  }

  @override
  Future<SuccessResponse> shareDocumentRequestApi(ShareDocumentRequest shareDocumentRequest) async{
    final response = await remoteDataSource.shareDocumentRequestApi(shareDocumentRequest);
    return response;
  }

  @override
  Future<List<SignatureModel?>?> getDocumentSignatureList(String documentId) async{
    final response = await remoteDataSource.getDocumentSignatureList(documentId);
    return response;
  }

  @override
  Future<List<ShareDocumentRoleResponse?>?> shareRolePermissionListApi(String documentId) async{
    final response = await remoteDataSource.shareRolePermissionListApi(documentId);
    return response;
  }

  @override
  Future<SuccessResponse> shareDocumentPermissionRequestApi(DocumentSharePermissionRequest documentRolePermissionRequest) async{
    final response = await remoteDataSource.shareDocumentPermissionRequestApi(documentRolePermissionRequest);
    return response;
  }

  @override
  Future<SuccessResponse> shareDocumentPermissionDeleteApi(String documentId,String shareType) async{
    final response = await remoteDataSource.shareDocumentPermissionDeleteApi(documentId,shareType);
    return response;
  }

  @override
  Future<SuccessResponse> updateDocument(EditDocumentRequest editDocumentRequest) async{
    final response = await remoteDataSource.updateDocument(editDocumentRequest);
    return response;
  }

  @override
  Future<SuccessResponse> deleteDocumentApi(String documentId,String documentType) async{
    final response = await remoteDataSource.deleteDocumentApi(documentId,documentType);
    return response;
  }
  @override
  Future<List<StartWorkflowResponse?>?> starWorkFLowListApi() async{
    final response = await remoteDataSource.starWorkFLowListApi();
    return response;
  }
  @override
  Future<SuccessResponse> starWorkFLowCreateApi(
      String documentId,
      String workflowId,
      ) async {
    final response = await remoteDataSource.starWorkFLowCreateApi(documentId, workflowId);
    return response;
  }

  @override
  Future<SuccessResponse> createShareableLink(ShareableLinkRequest shareableLinkRequest) async{
    final response = await remoteDataSource.createShareableLink(shareableLinkRequest);
    return response;
  }


  @override
  Future<ShareableLinkResponse?> getShareableLink(String documentId) async{
    final response = await remoteDataSource.getShareableLink(documentId);
    return response;
  }

  @override
  Future<SuccessResponse> deleteSharableLinkApi(String documentId) async{
    final response = await remoteDataSource.deleteSharableLinkApi(documentId);
    return response;
  }

  @override
  Future<List<DocumentStatus>?> getDocumentStatus() async {
    final responseList = await remoteDataSource.getDocumentStatus();

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<DocumentStatus>().toList();
    return cleanedList;
  }

  @override
  Future<List<DocumentMetaTag?>?> getDocumentMetaTagList(String documentId) async {
    final responseList = await remoteDataSource.getDocumentMetaTagList(documentId);

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<DocumentMetaTag>().toList();
    return cleanedList;
  }


  @override
  Future<List<CommentModel?>?> getCommentList(String documentId) async {
    final responseList = await remoteDataSource.getCommentList(documentId);

    if (responseList == null || responseList.isEmpty) {
      return [];
    }
    final cleanedList = responseList.whereType<CommentModel>().toList();
    return cleanedList;
  }

  @override
  Future<SuccessResponse> deleteCommentApi(String commentId) async{
    final response = await remoteDataSource.deleteComment(commentId);
    return response;
  }

  @override
  Future<CommentModel> addCommentApi(String documentId,String comments) async{
    final response = await remoteDataSource.addComment(documentId,comments);
    return response;
  }

}
