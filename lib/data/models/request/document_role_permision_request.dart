class DocumentSharePermissionRequest {
  List<DocumentRolePermissions>? documentRolePermissions;
  List<DocumentUserPermissions>? documentUserPermissions;

  DocumentSharePermissionRequest({
    this.documentRolePermissions,
    this.documentUserPermissions,
  });

  Map<String, dynamic> toJson() => {
    if (documentRolePermissions != null)
      "documentRolePermissions":
      documentRolePermissions!.map((x) => x.toJson()).toList(),
    if (documentUserPermissions != null)
      "documentUserPermissions":
      documentUserPermissions!.map((x) => x.toJson()).toList(),
  };
}


class DocumentRolePermissions {
  String? id;
  String? documentId;
  String? roleId;
  bool isTimeBound;
  String? startDate;
  String? endDate;
  bool isAllowDownload;
  List<SelectedRole> selectedRoles;

  DocumentRolePermissions({
    this.id,
    this.documentId,
    this.roleId,
    required this.isTimeBound,
    this.startDate,
    this.endDate,
    required this.isAllowDownload,
    required this.selectedRoles,
  });

  Map<String, dynamic> toJson() => {
    "id": id ?? "",
    "documentId": documentId,
    "roleId": roleId,
    "isTimeBound": isTimeBound,
    "startDate": startDate,
    "endDate": endDate,
    "isAllowDownload": isAllowDownload,
    "selectedRoles": selectedRoles.map((x) => x.toJson()).toList(),
  };
}

class SelectedRole {
  String? id;
  String? name;

  SelectedRole({this.id, this.name});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
class DocumentUserPermissions {
  String? id;
  String? documentId;
  String? userId;
  bool isTimeBound;
  String? startDate;
  String? endDate;
  bool isAllowDownload;
  List<SelectedUser> selectedUsers;

  DocumentUserPermissions({
    this.id,
    this.documentId,
    this.userId,
    required this.isTimeBound,
    this.startDate,
    this.endDate,
    required this.isAllowDownload,
    required this.selectedUsers,
  });

  Map<String, dynamic> toJson() => {
    "id": id ?? "",
    "documentId": documentId,
    "userId": userId,
    "isTimeBound": isTimeBound,
    "startDate": startDate,
    "endDate": endDate,
    "isAllowDownload": isAllowDownload,
    "selectedUsers": selectedUsers.map((x) => x.toJson()).toList(),
  };
}
class SelectedUser {
  String? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;

  SelectedUser({
    this.id,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "userName": userName,
    "email": email,
  };
}
