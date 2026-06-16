class ArchivedRequestQuery {
  final String? fields;
  final String? orderBy;
  final int pageSize;
  final int skip;
  final String? searchQuery;
  final String? categoryId;
  final String? statusId;
  final String? id;
  final String? name;
  final String? location;
  final String? metaTags;
  final String? deletedDateString;

  ArchivedRequestQuery({
    this.fields = "",
    this.orderBy = "",
    this.pageSize = 0,
    this.skip = 0,
    this.searchQuery = "",
    this.categoryId = "",
    this.statusId = "",
    this.id = "",
    this.name = "",
    this.location = "",
    this.metaTags = "",
    this.deletedDateString = "",
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "fields": fields ?? "",
      "orderBy": orderBy ?? "",
      "pageSize": pageSize.toString(),
      "skip": skip.toString(),
      "searchQuery": searchQuery ?? "",
      "categoryId": categoryId ?? "",
      "statusId": statusId ?? "",
      "id": id ?? "",
      "name": name ?? "",
      "location": location ?? "",
      "metaTags": metaTags ?? "",
      "deletedDateString": deletedDateString ?? "",
    };
  }
}
