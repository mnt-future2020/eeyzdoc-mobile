// To parse this JSON data, do
//
//     final editDocumentRequest = editDocumentRequestFromJson(jsonString);

import 'dart:convert';

import '../response/document_meta_tag.dart';

class EditDocumentRequest {
  String? id;
  String? categoryId;
  String? clientId;
  String? statusId;
  String? retentionPeriod;
  String? retentionAction;
  String? description;
  String? name;
  List<DocumentMetaTag> documentMetaDatas;

  EditDocumentRequest({
    this.id,
    this.categoryId,
    this.clientId,
    this.statusId,
    this.retentionPeriod,
    this.retentionAction,
    this.description,
    this.name,
    this.documentMetaDatas = const [],
  });


}
