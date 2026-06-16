
class ShareDocumentRequest {
  final String? documentId;
  final String? userId;
  final bool? isAllowDownload;
  final bool? isTimeBound;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdBy;
  final String? modifiedBy;

  ShareDocumentRequest({
    this.documentId,
    this.userId,
    this.isAllowDownload,
    this.isTimeBound,
    this.startDate,
    this.endDate,
    this.createdBy,
    this.modifiedBy,
  });

  /// Create an instance from a JSON map
  factory ShareDocumentRequest.fromJson(Map<String, dynamic> json) {
    return ShareDocumentRequest(
      documentId: json['documentId'] as String?,
      userId: json['userId'] as String?,
      isAllowDownload: json['isAllowDownload'] as bool?,
      isTimeBound: json['isTimeBound'] as bool?,
      startDate: json['startDate'] as DateTime?,
      endDate: json['endDate'] as DateTime?,
      createdBy: json['createdBy'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
    );
  }

  /// Convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'userId': userId,
      'isAllowDownload': isAllowDownload,
      'isTimeBound': isTimeBound,
      'startDate': startDate?.toIso8601String,
      'endDate': endDate?.toIso8601String,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }
}

