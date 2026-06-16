import 'FileRequestDocumentResponse.dart';

class FileRequestResponse {
  String? id;
  String? subject;
  String? email;
  int? sizeInMb;
  int? maxDocument;
  int? fileRequestStatus;
  String? createdBy;
  String? allowExtension;
  DateTime? createdDate;
  DateTime? linkExpiryTime;
  bool? isMaxDocumentReached;
  bool? isLinkExpired;
  bool? hasPassword;
  String? password;
  List<FileRequestDocument>? fileRequestDocuments;

  FileRequestResponse({
    this.id,
    this.subject,
    this.email,
    this.sizeInMb,
    this.maxDocument,
    this.fileRequestStatus,
    this.createdBy,
    this.allowExtension,
    this.createdDate,
    this.linkExpiryTime,
    this.isMaxDocumentReached,
    this.isLinkExpired,
    this.hasPassword,
    this.password,
    this.fileRequestDocuments,
  });

  factory FileRequestResponse.fromJson(Map<String, dynamic> json) {
    return FileRequestResponse(
      id: json['id'],
      subject: json['subject'],
      email: json['email'],
      sizeInMb: json['sizeInMb'],
      maxDocument: json['maxDocument'],
      fileRequestStatus: json['fileRequestStatus'],
      createdBy: json['createdBy'],
      allowExtension: json['allowExtension'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      linkExpiryTime: json['linkExpiryTime'] != null
          ? DateTime.parse(json['linkExpiryTime'])
          : null,
      isMaxDocumentReached: json['isMaxDocumentReached'],
      isLinkExpired: json['isLinkExpired'],
      hasPassword: json['hasPassword'],
      password: json['password'],
      fileRequestDocuments: json['fileRequestDocuments'] != null
          ? (json['fileRequestDocuments'] as List)
          .map((e) => FileRequestDocument.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
      "email": email,
      "sizeInMb": sizeInMb,
      "maxDocument": maxDocument,
      "fileRequestStatus": fileRequestStatus,
      "createdBy": createdBy,
      "allowExtension": allowExtension,
      "createdDate": createdDate?.toIso8601String(),
      "linkExpiryTime": linkExpiryTime?.toIso8601String(),
      "isMaxDocumentReached": isMaxDocumentReached,
      "isLinkExpired": isLinkExpired,
      "hasPassword": hasPassword,
      "password": password,
      "fileRequestDocuments":
      fileRequestDocuments?.map((e) => e.toJson()).toList(),
    };
  }
}


