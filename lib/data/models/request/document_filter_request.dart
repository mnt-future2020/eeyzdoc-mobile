class DocumentFilterRequest {
  final String? fields;
  final String? orderBy;
  final String? createDateString;
  final int? pageSize;
  final int? skip;
  final String? searchQuery;
  final String? categoryId;
  final String? name;
  final String? metaTags;
  final String? id;
  final String? location;
  final String? clientId;
  final String? statusId;
  final bool? assignedDocuments;

  DocumentFilterRequest({
    this.fields,
    this.orderBy,
    this.createDateString,
    this.pageSize,
    this.skip,
    this.searchQuery,
    this.categoryId,
    this.name,
    this.metaTags,
    this.id,
    this.location,
    this.clientId,
    this.statusId,
    this.assignedDocuments,
  });

  Map<String, dynamic> toQuery() {
    return {
      'fields': fields ?? "",
      'orderBy': orderBy ?? "createdDate desc",
      'createDateString': createDateString ?? "",
      'pageSize': pageSize ?? 10,
      'skip': skip ?? 0,
      'searchQuery': searchQuery ?? "",
      'categoryId': categoryId ?? "",
      'name': name ?? "",
      'metaTags': metaTags ?? "",
      'id': id ?? "",
      'location': location ?? "",
      'clientId': clientId ?? "",
      'statusId': statusId ?? "",
    };
  }

  String toRawQuery() {
    return 'fields=${fields ?? ""}'
        '&orderBy=${orderBy ?? "createdDate desc"}'
        '&createDateString=${createDateString ?? ""}'
        '&pageSize=${pageSize ?? 10}'
        '&skip=${skip ?? 0}'
        '&searchQuery=${searchQuery ?? ""}'
        '&categoryId=${categoryId ?? ""}'
        '&name=${name ?? ""}'
        '&metaTags=${metaTags ?? ""}'
        '&id=${id ?? ""}'
        '&location=${location ?? ""}'
        '&clientId=${clientId ?? ""}'
        '&statusId=${statusId ?? ""}';
  }
}
