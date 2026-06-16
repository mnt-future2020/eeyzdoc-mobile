class DocumentAuditResponse {
  final String? id;
  final String? documentId;
  final String? operationName;
  final String? assignToUserId;
  final String? assignToRoleId;
  final String? createdBy;
  final String? modifiedBy;
  final String? deletedBy;
  final int? isDeleted;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final DateTime? deletedAt;
  final String? documentName;
  final String? categoryName;
  final String? permissionRole;
  final String? permissionUser;

  DocumentAuditResponse({
    this.id,
    this.documentId,
    this.operationName,
    this.assignToUserId,
    this.assignToRoleId,
    this.createdBy,
    this.modifiedBy,
    this.deletedBy,
    this.isDeleted,
    this.createdDate,
    this.modifiedDate,
    this.deletedAt,
    this.documentName,
    this.categoryName,
    this.permissionRole,
    this.permissionUser,
  });

  factory DocumentAuditResponse.fromJson(Map<String, dynamic> json) {
    return DocumentAuditResponse(
      id: json['id'] as String?,
      documentId: json['documentId'] as String?,
      operationName: json['operationName'] as String?,
      assignToUserId: json['assignToUserId'] as String?,
      assignToRoleId: json['assignToRoleId'] as String?,
      createdBy: json['createdBy'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      deletedBy: json['deletedBy'] as String?,
      isDeleted: json['isDeleted'] as int?,
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.tryParse(json['modifiedDate'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
      documentName: json['documentName'] as String?,
      categoryName: json['categoryName'] as String?,
      permissionRole: json['permissionRole'] as String?,
      permissionUser: json['permissionUser'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'operationName': operationName,
      'assignToUserId': assignToUserId,
      'assignToRoleId': assignToRoleId,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
      'deletedBy': deletedBy,
      'isDeleted': isDeleted,
      'createdDate': createdDate?.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'documentName': documentName,
      'categoryName': categoryName,
      'permissionRole': permissionRole,
      'permissionUser': permissionUser,
    };
  }

  @override
  String toString() {
    return 'DocumentAuditResponse{id: $id, documentId: $documentId, operationName: $operationName, '
        'assignToUserId: $assignToUserId, assignToRoleId: $assignToRoleId, createdBy: $createdBy, '
        'modifiedBy: $modifiedBy, deletedBy: $deletedBy, isDeleted: $isDeleted, '
        'createdDate: $createdDate, modifiedDate: $modifiedDate, deletedAt: $deletedAt, '
        'documentName: $documentName, categoryName: $categoryName, '
        'permissionRole: $permissionRole, permissionUser: $permissionUser}';
  }
}
