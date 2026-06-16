import 'dart:io';

import 'package:docuflow/data/models/request/document_filter_request.dart';
import 'package:docuflow/data/models/request/document_request.dart';
import 'package:docuflow/data/models/response/CategoryDropDownResponse.dart';
import 'package:docuflow/data/models/response/clientDropdownResponse.dart';
import 'package:docuflow/data/models/response/document_response.dart';
import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/share_document_role_response.dart';
import 'package:docuflow/data/models/response/success_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';
import 'package:docuflow/data/repositories/SignatureModel.dart';

import '../../data/models/request/ShareableLinkRequest.dart';
import '../../data/models/request/document_role_permision_request.dart';
import '../../data/models/request/edit_document_request.dart';
import '../../data/models/request/share_document_request.dart';
import '../../data/models/response/ShareableLinkResponse.dart';
import '../../data/models/response/StartWorkflowResponse.dart';
import '../../data/models/response/comment_model.dart';
import '../../data/models/response/document_meta_tag.dart';
import '../../data/models/response/document_status.dart';

abstract class DocumentsRepository {
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

  Future<List<SignatureModel?>?> getDocumentSignatureList(String documentId);

  Future<SuccessResponse> shareDocumentRequestApi(
    ShareDocumentRequest shareDocumentRequest,
  );

  Future<SuccessResponse> createShareableLink(
    ShareableLinkRequest shareableLinkRequest,
  );

  Future<ShareableLinkResponse?> getShareableLink(String documentId);


  Future<SuccessResponse> shareDocumentPermissionRequestApi(
    DocumentSharePermissionRequest documentRolePermissionRequest,
  );

  Future<SuccessResponse> shareDocumentPermissionDeleteApi(
    String documentId,
    String shareType,
  );

  Future<List<ShareDocumentRoleResponse?>?> shareRolePermissionListApi(
    String documentId,
  );

  Future<List<DocumentResponse?>?> getDocuments(DocumentFilterRequest filter);

  Future<SuccessResponse> documentSignatureApi(
    String documentId,
    String signatureUrl,
  );

  Future<List<StartWorkflowResponse?>?> starWorkFLowListApi();

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
    File fil,
  );
  Future<List<DocumentMetaTag?>?> getDocumentMetaTagList(String documentId);

  Future<List<UserDropdownResponse?>?> getUsers();

  Future<List<RoleDropdownResponse?>?> getRoles();

  Future<List<ClientDropdownResponse?>?> getClients();

  Future<List<CategoryDropdownResponse?>?> getCategory();

  Future<List<DocumentStatus?>?> getDocumentStatus();

  Future<CommentModel> addCommentApi(String documentId,String comments);

  Future<List<CommentModel?>?> getCommentList(String documentId);

  Future<SuccessResponse> deleteCommentApi(String commentId);

}
