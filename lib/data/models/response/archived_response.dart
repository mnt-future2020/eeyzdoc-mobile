class ArchivedResponse {
  final String id;
  final String name;
  final String? url;
  final String? description;
  final String? location;
  final String? deletedBy;
  final DateTime? deletedAt;
  final String? categoryId;
  final String? categoryName;
  final String? statusName;
  final String? colorCode;
  final String? deletedByName;

  ArchivedResponse({
    required this.id,
    required this.name,
    this.url,
    this.description,
    this.location,
    this.deletedBy,
    this.deletedAt,
    this.categoryId,
    this.categoryName,
    this.statusName,
    this.colorCode,
    this.deletedByName,
  });

  factory ArchivedResponse.fromJson(Map<String, dynamic> json) {
    return ArchivedResponse(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      url: json["url"],
      description: json["description"],
      location: json["location"],
      deletedBy: json["deletedBy"],
      deletedAt: json["deletedAt"] != null ? DateTime.parse(json["deletedAt"]) : null,
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      statusName: json["statusName"],
      colorCode: json["colorCode"],
      deletedByName: json["deletedByName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "description": description,
      "location": location,
      "deletedBy": deletedBy,
      "deletedAt": deletedAt?.toIso8601String(),
      "categoryId": categoryId,
      "categoryName": categoryName,
      "statusName": statusName,
      "colorCode": colorCode,
      "deletedByName": deletedByName,
    };
  }
}
