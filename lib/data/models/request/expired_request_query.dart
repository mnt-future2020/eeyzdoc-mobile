class ExpiredRequestQuery {
  String? fields;
  String? orderBy;
  int? pageSize;
  int? skip;
  String? searchQuery;
  String? categoryId;
  String? name;
  String? metaTags;
  String? id;
  String? location;
  String? statusId;
  String? deletedDateString;

  ExpiredRequestQuery({
    this.fields = "",
    this.orderBy = "expiredDate desc",
    this.pageSize = 10,
    this.skip = 0,
    this.searchQuery = "",
    this.categoryId = "",
    this.name = "",
    this.metaTags = "",
    this.id = "",
    this.location = "",
    this.statusId = "",
    this.deletedDateString = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "fields": fields,
      "orderBy": orderBy,
      "pageSize": pageSize,
      "skip": skip,
      "searchQuery": searchQuery,
      "categoryId": categoryId,
      "name": name,
      "metaTags": metaTags,
      "id": id,
      "location": location,
      "statusId": statusId,
      "deletedDateString": deletedDateString,
    };
  }
}
