import 'dart:io';

import '../response/document_meta_tag.dart';


class DocumentRequest {
  // your existing fields…
  final String? id;
  final File? uploadFile;
  final String? name;
  final String? categoryId;
  final String? categoryName;
  final String? location;
  final String? description;
  final String? statusId;
  final String? clientId;
  final String? retentionPeriod;
  final String? retentionAction;
  final String? htmlContent;
  final List<DocumentMetaTag> documentMetaDatas;
  final List<Map<String, dynamic>> documentRolePermissions;
  final List<Map<String, dynamic>> documentUserPermissions;

  DocumentRequest({
    this.id,
    this.uploadFile,
    this.name,
    this.categoryId,
    this.categoryName,
    this.location,
    this.description,
    this.statusId,
    this.clientId,
    this.retentionPeriod,
    this.retentionAction,
    this.htmlContent,
    this.documentMetaDatas = const [],
    this.documentRolePermissions = const [],
    this.documentUserPermissions = const [],
  });
/*
  Future<FormData> toFormData() async {
    final formData = FormData();
    if (uploadFile != null) {
      final mimeType =
          lookupMimeType(uploadFile!.path) ?? 'application/octet-stream';

      formData.files.add(
        MapEntry(
          "uploadFile",
          await MultipartFile.fromFile(
            uploadFile!.path,
            filename: p.basename(uploadFile!.path),
            contentType: MediaType.parse(mimeType),
          ),
        ),
      );
    }

    void addField(String key, dynamic value) =>
        formData.fields.add(MapEntry(key, value?.toString() ?? ''));

    if (id != null) addField("id", id);

    addField("name", name);
    addField("categoryId", categoryId);
    addField("location", location);
    addField("description", description);
    addField("statusId", null); // valid ID
    addField("clientId", clientId);
    addField("retentionPeriod", retentionPeriod);
    addField("retentionAction", retentionAction);
    addField("html_content", htmlContent);

    formData.fields.add(MapEntry("documentMetaDatas", jsonEncode([])));
    formData.fields.add(MapEntry("documentRolePermissions", jsonEncode([])));
    formData.fields.add(MapEntry("documentUserPermissions", jsonEncode([])));

    return formData;
  }*/
}
