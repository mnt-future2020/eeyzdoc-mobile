import 'dart:convert';

ReminderRequest reminderRequestFromJson(String str) =>
    ReminderRequest.fromJson(json.decode(str));

String reminderRequestToJson(ReminderRequest data) =>
    json.encode(data.toJson());

class ReminderRequest {
  String? id;
  String? subject;
  String? message;
  String? frequency;
  bool? isRepeated;
  bool? isEmailNotification;
  String? startDate;
  String? endDate;
  String? dayOfWeek;
  String? documentId;

  List<SelectedUser> selectedUsers;
  List<DailyReminder> dailyReminders;
  List<ReminderUser> reminderUsers;

  ReminderRequest({
    this.id,
    this.subject,
    this.message,
    this.frequency,
    this.isRepeated,
    this.isEmailNotification,
    this.startDate,
    this.endDate,
    this.dayOfWeek,
    this.documentId,
    required this.selectedUsers,
    required this.dailyReminders,
    required this.reminderUsers,
  });

  factory ReminderRequest.fromJson(Map<String, dynamic> json) =>
      ReminderRequest(
        id: json["id"],
        subject: json["subject"],
        message: json["message"],
        frequency: json["frequency"],
        isRepeated: json["isRepeated"],
        isEmailNotification: json["isEmailNotification"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        dayOfWeek: json["dayOfWeek"],
        documentId: json["documentId"],
        selectedUsers: List<SelectedUser>.from(
            json["selectedUsers"].map((x) => SelectedUser.fromJson(x))),
        dailyReminders: List<DailyReminder>.from(
            json["dailyReminders"].map((x) => DailyReminder.fromJson(x))),
        reminderUsers: List<ReminderUser>.from(
            json["reminderUsers"].map((x) => ReminderUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "message": message,
    "frequency": frequency,
    "isRepeated": isRepeated,
    "isEmailNotification": isEmailNotification,
    "startDate": startDate,
    "endDate": endDate,
    "dayOfWeek": dayOfWeek,
    "documentId": documentId,
    "selectedUsers":
    List<dynamic>.from(selectedUsers.map((x) => x.toJson())),
    "dailyReminders":
    List<dynamic>.from(dailyReminders.map((x) => x.toJson())),
    "reminderUsers":
    List<dynamic>.from(reminderUsers.map((x) => x.toJson())),
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

  factory SelectedUser.fromJson(Map<String, dynamic> json) => SelectedUser(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    userName: json["userName"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "userName": userName,
    "email": email,
  };
}

class DailyReminder {
  String? id;
  String? reminderId;
  int? dayOfWeek;
  bool? isActive;
  String? name;

  DailyReminder({
    this.id,
    this.reminderId,
    this.dayOfWeek,
    this.isActive,
    this.name,
  });

  factory DailyReminder.fromJson(Map<String, dynamic> json) => DailyReminder(
    id: json["id"],
    reminderId: json["reminderId"],
    dayOfWeek: json["dayOfWeek"],
    isActive: json["isActive"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reminderId": reminderId,
    "dayOfWeek": dayOfWeek,
    "isActive": isActive,
    "name": name,
  };
}

class ReminderUser {
  String? reminderId;
  String? userId;

  ReminderUser({
    this.reminderId,
    this.userId,
  });

  factory ReminderUser.fromJson(Map<String, dynamic> json) => ReminderUser(
    reminderId: json["reminderId"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "reminderId": reminderId,
    "userId": userId,
  };
}
