class FileRequestQuery {
  final String? fields;
  final String? orderBy;
  final int pageSize;
  final int skip;
  final String? search;
  final String? id;
  final String? email;
  final String? subject;

  FileRequestQuery({
    this.fields = "",
    this.orderBy = "",
    this.pageSize = 0,
    this.skip = 0,
    this.search = "",
    this.id,
    this.email,
    this.subject,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "fields": fields,
      "orderBy": orderBy,
      "pageSize": pageSize.toString(),
      "skip": skip.toString(),
      "searchQuery": search ?? "",
      "id": id ?? "",
      "email": email ?? "",
      "subject": subject ?? "",
    };
  }
}
