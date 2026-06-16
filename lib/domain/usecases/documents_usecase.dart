import 'package:docuflow/data/models/request/document_filter_request.dart';
import 'package:docuflow/data/models/request/document_request.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/share_document_role_response.dart';
import 'dart:io';

import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:docuflow/domain/repositories/Documents_repository.dart';

import '../../data/models/request/ShareableLinkRequest.dart';
import '../../data/models/request/document_role_permision_request.dart';
import '../../data/models/request/edit_document_request.dart';
import '../../data/models/request/share_document_request.dart';
import '../../data/models/response/CategoryDropDownResponse.dart';
import '../../data/models/response/ShareableLinkResponse.dart';
import '../../data/models/response/StartWorkflowResponse.dart';
import '../../data/models/response/clientDropdownResponse.dart';
import '../../data/models/response/comment_model.dart';
import '../../data/models/response/document_meta_tag.dart';
import '../../data/models/response/document_status.dart';
import '../../data/repositories/SignatureModel.dart';

class DocumentsUseCase {
  final DocumentsRepository repository;

  DocumentsUseCase(this.repository);

  Future<void> addDocument(DocumentRequest request) async {
    await repository.addDocument(request);
  }

  Future<SuccessResponse> updateDocument(
    EditDocumentRequest editDocumentRequest,
  ) async {
    return await repository.updateDocument(editDocumentRequest);
  }

  Future<List<DocumentResponse?>?> getDocuments(
    DocumentFilterRequest filter,
  ) async {
    return await repository.getDocuments(filter);
  }

  Future<SuccessResponse> createShareableLink(
      ShareableLinkRequest shareableLinkRequest,
  ) async {
    return await repository.createShareableLink(shareableLinkRequest);
  }
  Future<ShareableLinkResponse?> getShareableLink(String documentId) async{
    return await repository.getShareableLink(documentId);
  }
  Future<SuccessResponse> deleteSharableLinkApi(String documentId) async{
    return await repository.deleteSharableLinkApi(documentId);
  }


  Future<SuccessResponse> shareDocumentRequestApi(
    ShareDocumentRequest shareDocumentRequest,
  ) async {
    return await repository.shareDocumentRequestApi(shareDocumentRequest);
  }

  Future<List<ShareDocumentRoleResponse?>?> shareRolePermissionListApi(
    String documentId,
  ) async {
    return await repository.shareRolePermissionListApi(documentId);
  }

  Future<SuccessResponse> documentSignatureApi(
    String documentId,
    String signatureUrl,
  ) async {
    return await repository.documentSignatureApi(documentId, signatureUrl);
  }

  Future<SuccessResponse> shareDocumentPermissionRequestApi(
    DocumentSharePermissionRequest documentRolePermissionRequest,
  ) async {
    return await repository.shareDocumentPermissionRequestApi(
      documentRolePermissionRequest,
    );
  }

  Future<SuccessResponse> shareDocumentPermissionDeleteApi(
    String documentId,
    String shareType,
  ) async {
    return await repository.shareDocumentPermissionDeleteApi(
      documentId,
      shareType,
    );
  }

  Future<SuccessResponse> starWorkFLowApi(
    String name,
    String description,
  ) async {
    return await repository.starWorkFLowApi(name, description);
  }

  Future<SuccessResponse> starWorkFLowCreateApi(
      String documentId, String workflowId
  ) async {
    return await repository.starWorkFLowCreateApi(documentId, workflowId);
  }

  Future<SuccessResponse> editDocumentApi(
    String documentId,
    String operationName,
  ) async {
    return await repository.editDocument(documentId, operationName);
  }

  Future<SuccessResponse> deleteDocumentApi(String documentId,String documentType) async {
    return await repository.deleteDocumentApi(documentId,documentType);
  }

  Future<List<SignatureModel?>?> getDocumentSignatureList(
    String documentId,
  ) async {
    return await repository.getDocumentSignatureList(documentId);
  }



  Future<SuccessResponse> operationNameApi(
    String documentId,
    String operationName,
  ) async {
    return await repository.operationNameApi(documentId, operationName);
  }

  Future<SuccessResponse> uploadNewVersionApi(
    String documentId,
    String location,
    File file,
  ) async {
    return await repository.uploadNewVersionApi(documentId, location, file);
  }

  Future<List<UserDropdownResponse?>?> getUsers() async {
    return await repository.getUsers();
  }

  Future<List<RoleDropdownResponse?>?> getRoles() async {
    return await repository.getRoles();
  }

  Future<List<ClientDropdownResponse?>?> getClients() async {
    return await repository.getClients();
  }

  Future<List<CategoryDropdownResponse?>?> getCategory() async {
    return await repository.getCategory();
  }
  Future<List<DocumentStatus?>?> getDocumentStatus() async {
    return await repository.getDocumentStatus();
  }
  Future<List<DocumentMetaTag?>?> getDocumentMetaTagList(String documentId) async {
    return await repository.getDocumentMetaTagList(documentId);
  }
  Future<List<StartWorkflowResponse?>?> starWorkFLowListApi() async {
    return await repository.starWorkFLowListApi();
  }

  Future<List<CommentModel?>?> getCommentList(String documentId) async {
    return await repository.getCommentList(documentId);
  }

  Future<SuccessResponse> deleteCommentApi(String commentId) async {
    return await repository.deleteCommentApi(commentId);
  }

  Future<CommentModel> addCommentApi(String documentId,String comments) async {
    return await repository.addCommentApi(documentId,comments);
  }

}
