class QuarterReminder {
  String id;
  String reminderId;
  int quarter;
  String day;
  int month;
  String name;
  List<MonthValue> monthValues;

  QuarterReminder({
    this.id = "",
    this.reminderId = "",
    required this.quarter,
    this.day = "10",
    this.month = 1,
    required this.name,
    required this.monthValues,
  });
  factory QuarterReminder.fromJson(Map<String, dynamic> json) {
    return QuarterReminder(
      id: json["id"] ?? "",
      reminderId: json["reminderId"] ?? "",
      quarter: json["quarter"] ?? 1,

      // API sends int, model uses String → convert safely
      day: json["day"]?.toString() ?? "10",

      month: json["month"] ?? 1,
      name: json["name"] ?? "",

      monthValues: json["monthValues"] != null
          ? List<MonthValue>.from(
          json["monthValues"].map((x) => MonthValue.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "reminderId": reminderId,
    "quarter": quarter,
    "day": day,
    "month": month,
    "name": name,
    "monthValues": monthValues.map((x) => x.toJson()).toList(),
  };
}

class MonthValue {
  int id;
  String name;

  MonthValue({
    required this.id,
    required this.name,
  });

  factory MonthValue.fromJson(Map<String, dynamic> json) {
    return MonthValue(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
