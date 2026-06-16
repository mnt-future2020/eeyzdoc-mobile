class DocumentWorkflowLogsRequest {
  String? fields;
  String? orderBy;
  int? pageSize;
  int? pageNumber;
  int? skip;
  String? searchQuery;
  String? documentName;
  String? workflowName;
  String? status;
  String? documentId;

  DocumentWorkflowLogsRequest({
    this.fields = "",
    this.orderBy = "createdDate desc",
    this.pageSize = 10,
    this.pageNumber = 1,
    this.skip = 0,
    this.searchQuery = "",
    this.documentName = "",
    this.workflowName = "",
    this.status = "",
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
      "documentName": documentName,
      "workflowName": workflowName,
      "status": status,
      "documentId": documentId,
    };
  }
}
