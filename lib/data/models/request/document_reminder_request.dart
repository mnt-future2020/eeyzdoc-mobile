class DocumentReminderRequest {
  String? fields;
  String? orderBy;
  int? pageSize;
  int? pageNumber;
  int? skip;
  String? searchQuery;
  String? subject;
  String? message;
  String? frequency;
  String? documentId;

  DocumentReminderRequest({
    this.fields = "",
    this.orderBy = "startDate desc",
    this.pageSize = 10,
    this.pageNumber = 1,
    this.skip = 0,
    this.searchQuery = "",
    this.subject = "",
    this.message = "",
    this.frequency = "",
    this.documentId = "",
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "fields": fields,
      "orderBy": orderBy,
      "pageSize": pageSize,
      "pageNumber": pageNumber,
      "skip": skip,
      "searchQuery": searchQuery,
      "subject": subject,
      "message": message,
      "frequency": frequency,
      "documentId": documentId,
    };
  }
}
