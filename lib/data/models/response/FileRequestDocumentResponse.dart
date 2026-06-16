class FileRequestDocument {
  final String id;
  final String name;
  final String url;
  final String fileRequestId;
  final int fileRequestDocumentStatus;
  final DateTime? approvedRejectedDate;
  final String? approvalOrRejectedById;
  final String? reason;
  final DateTime? linkExpiryTime;
  final DateTime createdDate;

  FileRequestDocument({
    required this.id,
    required this.name,
    required this.url,
    required this.fileRequestId,
    required this.fileRequestDocumentStatus,
    this.approvedRejectedDate,
    this.approvalOrRejectedById,
    this.reason,
    this.linkExpiryTime,
    required this.createdDate,
  });

  /// JSON → Model
  factory FileRequestDocument.fromJson(Map<String, dynamic> json) {
    return FileRequestDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      fileRequestId: json['fileRequestId'] as String,
      fileRequestDocumentStatus: json['fileRequestDocumentStatus'] as int,

      approvedRejectedDate: json['approvedRejectedDate'] != null
          ? DateTime.parse(json['approvedRejectedDate'])
          : null,

      approvalOrRejectedById: json['approvalOrRejectedById'] as String?,
      reason: json['reason'] as String?,
      linkExpiryTime: json['linkExpiryTime'] != null
          ? DateTime.parse(json['linkExpiryTime'])
          : null,
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'fileRequestId': fileRequestId,
      'fileRequestDocumentStatus': fileRequestDocumentStatus,
      'approvedRejectedDate': approvedRejectedDate?.toIso8601String(),
      'approvalOrRejectedById': approvalOrRejectedById,
      'reason': reason,
      'linkExpiryTime': linkExpiryTime?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
