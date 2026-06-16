// To parse this JSON data, do
//
//     final reminderResponse = reminderResponseFromJson(jsonString);


import 'package:docuflow/data/models/response/reminder_response.dart';
import 'package:docuflow/data/models/response/user_dropdown_response.dart';

import '../request/QuarterReminder.dart';

class ReminderDetailsResponse {
  String id;
  String subject;
  String message;
  int frequency;
  DateTime? startDate;
  DateTime? endDate;
  String? dayOfWeek;
  int isRepeated;
  int isEmailNotification;
  String? documentId;
  String createdBy;
  String modifiedBy;
  String? deletedBy;
  int isDeleted;
  DateTime createdDate;
  DateTime modifiedDate;
  DateTime? deletedAt;
  List<ReminderUser> reminderUsers;
  List<QuarterReminder> quarterlyReminders;
  List<QuarterReminder> halfYearlyReminders;
  List<DailyReminder> dailyReminders;

  ReminderDetailsResponse({
    required this.id,
    required this.subject,
    required this.message,
    required this.frequency,
    this.startDate,
    this.endDate,
    this.dayOfWeek,
    required this.isRepeated,
    required this.isEmailNotification,
    this.documentId,
    required this.createdBy,
    required this.modifiedBy,
    this.deletedBy,
    required this.isDeleted,
    required this.createdDate,
    required this.modifiedDate,
    this.deletedAt,
    required this.reminderUsers,
    required this.quarterlyReminders,
    required this.halfYearlyReminders,
    required this.dailyReminders,
  });

  factory ReminderDetailsResponse.fromJson(Map<String, dynamic> json) => ReminderDetailsResponse(
    id: json["id"] ?? "",
    subject: json["subject"] ?? "",
    message: json["message"] ?? "",
    frequency: json["frequency"] ?? 0,

    startDate: json["startDate"] != null ? DateTime.tryParse(json["startDate"]) : null,
    endDate: json["endDate"] != null ? DateTime.tryParse(json["endDate"]) : null,

    dayOfWeek: json["dayOfWeek"],

    isRepeated: json["isRepeated"] ?? 0,
    isEmailNotification: json["isEmailNotification"] ?? 0,

    documentId: json["documentId"],

    createdBy: json["createdBy"] ?? "",
    modifiedBy: json["modifiedBy"] ?? "",
    deletedBy: json["deletedBy"],

    isDeleted: json["isDeleted"] ?? 0,

    createdDate: DateTime.tryParse(json["createdDate"] ?? "") ?? DateTime.now(),
    modifiedDate: DateTime.tryParse(json["modifiedDate"] ?? "") ?? DateTime.now(),
    deletedAt: json["deletedAt"] != null ? DateTime.tryParse(json["deletedAt"]) : null,


    reminderUsers: (json["reminderUsers"] as List?)
        ?.map((x) => ReminderUser.fromJson(x))
        .toList()
        ?? [],

    quarterlyReminders: (json["quarterlyReminders"] as List?)
        ?.map((x) => QuarterReminder.fromJson(x))
        .toList()
        ?? [],

    halfYearlyReminders: (json["halfYearlyReminders"] as List?)
        ?.map((x) => QuarterReminder.fromJson(x))
        .toList()
        ?? [],

    dailyReminders: (json["dailyReminders"] as List?)
        ?.map((x) => DailyReminder.fromJson(x))
        .toList()
        ?? [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "message": message,
    "frequency": frequency,
    "startDate": startDate?.toUtc().toIso8601String(),
    "endDate": endDate?.toUtc().toIso8601String(),
    "dayOfWeek": dayOfWeek,
    "isRepeated": isRepeated,
    "isEmailNotification": isEmailNotification,
    "documentId": documentId,
    "createdBy": createdBy,
    "modifiedBy": modifiedBy,
    "deletedBy": deletedBy,
    "isDeleted": isDeleted,
    "createdDate": createdDate.toUtc().toIso8601String(),
    "modifiedDate": modifiedDate.toUtc().toIso8601String(),
    "deletedAt": deletedAt?.toUtc().toIso8601String(),
    "reminderUsers": List<dynamic>.from(reminderUsers.map((x) => x.toJson())),
    "quarterlyReminders": List<dynamic>.from(quarterlyReminders.map((x) => x.toJson())),
    "halfYearlyReminders": List<dynamic>.from(halfYearlyReminders.map((x) => x.toJson())),
    "dailyReminders": List<dynamic>.from(dailyReminders.map((x) => x.toJson())),
  };
}


class DailyReminder {
  String id;
  String reminderId;
  int dayOfWeek;
  bool isActive;

  DailyReminder({
    required this.id,
    required this.reminderId,
    required this.dayOfWeek,
    required this.isActive,
  });

  factory DailyReminder.fromJson(Map<String, dynamic> json) => DailyReminder(
    id: json["id"],
    reminderId: json["reminderId"],
    dayOfWeek: json["dayOfWeek"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reminderId": reminderId,
    "dayOfWeek": dayOfWeek,
    "isActive": isActive,
  };
}
class ReminderUser {
  String id;
  String reminderId;
  String userId;

  ReminderUser({
    required this.id,
    required this.reminderId,
    required this.userId,
  });

  factory ReminderUser.fromJson(Map<String, dynamic> json) {
    return ReminderUser(
      id: json['id'] ?? "",
      reminderId: json['reminderId'] ?? "",
      userId: json['userId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reminderId": reminderId,
      "userId": userId,
    };
  }
}

