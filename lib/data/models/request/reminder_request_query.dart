class ReminderRequestQuery {
  final String? fields;
  final String? orderBy;
  final String? startDate;
  final int? pageSize;
  final int? skip;
  final String? searchQuery;
  final String? subject;
  final String? message;
  final String? frequency;
  final String? documentId;

  ReminderRequestQuery({
    this.fields,
    this.orderBy,
    this.startDate,
    this.pageSize,
    this.skip,
    this.searchQuery,
    this.subject,
    this.message,
    this.frequency,
    this.documentId,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "fields": fields ?? "",
      "orderBy": orderBy ?? "",
      "startDate": startDate ?? "",
      "pageSize": pageSize?.toString() ?? "10",
      "skip": skip?.toString() ?? "0",
      "searchQuery": searchQuery ?? "",
      "subject": subject ?? "",
      "message": message ?? "",
      "frequency": frequency ?? "",
      "documentId": documentId ?? "",
    };
  }
}
