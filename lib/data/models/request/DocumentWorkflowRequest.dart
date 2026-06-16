class DocumentWorkflowRequest {
  String? fields;
  String? orderBy;
  int? pageSize;
  int? skip;
  String? searchQuery;
  String? documentName;
  String? workflowName;
  String? status;

  DocumentWorkflowRequest({
    this.fields = "",
    this.orderBy = "",
    this.pageSize = 10,
    this.skip = 0,
    this.searchQuery = "",
    this.documentName = "",
    this.workflowName = "",
    this.status = "",
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "fields": fields,
      "orderBy": orderBy,
      "pageSize": pageSize,
      "skip": skip,
      "searchQuery": searchQuery,
      "documentName": documentName,
      "workflowName": workflowName,
      "status": status,
    };
  }
}
