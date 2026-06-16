import 'package:docuflow/data/models/response/dropdown_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';

class ShareDocumentRoleResponse {
  final String id;
  final String documentId;
  final String type;
  final bool isTimeBound;
  final bool isAllowDownload;
  final DateTime? startDate;
  final DateTime? endDate;

  // These two will be null depending on type
  final RoleDropdownResponse? role;
  final UserDropdownResponse? user;

  ShareDocumentRoleResponse({
    required this.id,
    required this.documentId,
    required this.type,
    required this.isTimeBound,
    required this.isAllowDownload,
    this.startDate,
    this.endDate,
    this.role,
    this.user,
  });

  factory ShareDocumentRoleResponse.fromJson(Map<String, dynamic> json) {
    return ShareDocumentRoleResponse(
      id: json['id'],
      documentId: json['documentId'],
      type: json['type'], // "Role" or "User"
      isTimeBound: json['isTimeBound'] == 1,
      isAllowDownload: json['isAllowDownload'] == 1,
      startDate: (json['startDate'] != null && json['startDate'] != "0000-00-00 00:00:00")
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: (json['endDate'] != null && json['endDate'] != "0000-00-00 00:00:00")
          ? DateTime.tryParse(json['endDate'])
          : null,
      role: json['type'] == "Role" && json['role'] != null
          ? RoleDropdownResponse.fromJson(json['role'])
          : null,
      user: json['type'] == "User" && json['user'] != null
          ? UserDropdownResponse.fromJson(json['user'])
          : null,
    );
  }

  String get name {
    if (type == "Role") return role?.name ?? "--";
    if (type == "User") return "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
    return "--";
  }

  String get email => (type == "User") ? (user?.email ?? "--") : "--";
}
