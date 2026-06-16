class DocumentAuditRequest {
  String? fields;
  String? orderBy;
  int? pageSize;
  int? pageNumber;
  int? skip;
  String? searchQuery;
  String? categoryId;
  String? operation;
  String? name;
  String? id;
  String? createdBy;
  String? documentId;

  DocumentAuditRequest({
    this.fields = "",
    this.orderBy = "createdDate desc",
    this.pageSize = 10,
    this.pageNumber = 1,
    this.skip = 0,
    this.searchQuery = "",
    this.categoryId = "",
    this.operation = "",
    this.name = "",
    this.id = "",
    this.createdBy = "",
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
      "categoryId": categoryId,
      "operation": operation,
      "name": name,
      "id": id,
      "createdBy": createdBy,
      "documentId": documentId,
    };
  }
}
