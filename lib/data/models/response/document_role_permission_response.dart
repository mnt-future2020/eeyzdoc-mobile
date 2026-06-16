class DocumentRolePermissionResponse {
  final String? id;
  final String? documentId;
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isTimeBound;
  final int? isAllowDownload;
  final String? createdBy;
  final String? modifiedBy;
  final String? deletedBy;
  final int? isDeleted;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final DateTime? deletedAt;
  final String? type;
  final PermissionUser? user;

  DocumentRolePermissionResponse({
    this.id,
    this.documentId,
    this.userId,
    this.startDate,
    this.endDate,
    this.isTimeBound,
    this.isAllowDownload,
    this.createdBy,
    this.modifiedBy,
    this.deletedBy,
    this.isDeleted,
    this.createdDate,
    this.modifiedDate,
    this.deletedAt,
    this.type,
    this.user,
  });

  static DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty || date.startsWith("0000-00-00")) {
      return null;
    }
    return DateTime.tryParse(date);
  }

  factory DocumentRolePermissionResponse.fromJson(Map<String, dynamic> json) {
    return DocumentRolePermissionResponse(
      id: json['id'],
      documentId: json['documentId'],
      userId: json['userId'],
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      isTimeBound: json['isTimeBound'],
      isAllowDownload: json['isAllowDownload'],
      createdBy: json['createdBy'],
      modifiedBy: json['modifiedBy'],
      deletedBy: json['deletedBy'],
      isDeleted: json['isDeleted'],
      createdDate: _parseDate(json['createdDate']),
      modifiedDate: _parseDate(json['modifiedDate']),
      deletedAt: _parseDate(json['deletedAt']),
      type: json['type'],
      user: json['user'] != null ? PermissionUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'userId': userId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isTimeBound': isTimeBound,
      'isAllowDownload': isAllowDownload,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
      'deletedBy': deletedBy,
      'isDeleted': isDeleted,
      'createdDate': createdDate?.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'type': type,
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return '''
DocumentRolePermissionResponse(
  id: $id,
  documentId: $documentId,
  userId: $userId,
  startDate: $startDate,
  endDate: $endDate,
  isTimeBound: $isTimeBound,
  isAllowDownload: $isAllowDownload,
  createdBy: $createdBy,
  modifiedBy: $modifiedBy,
  deletedBy: $deletedBy,
  isDeleted: $isDeleted,
  createdDate: $createdDate,
  modifiedDate: $modifiedDate,
  deletedAt: $deletedAt,
  type: $type,
  user: $user
)''';
  }
}

class PermissionUser {
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;

  PermissionUser({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory PermissionUser.fromJson(Map<String, dynamic> json) {
    return PermissionUser(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'PermissionUser(id: $id, username: $username, firstName: $firstName, lastName: $lastName, email: $email)';
  }
}
