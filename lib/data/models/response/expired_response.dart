class ExpiredResponse {
  String? id;
  String? name;
  String? url;
  String? description;
  String? location;
  DateTime? expiredDate;
  String? categoryId;
  String? categoryName;
  String? statusName;

  ExpiredResponse({
    this.id,
    this.name,
    this.url,
    this.description,
    this.location,
    this.expiredDate,
    this.categoryId,
    this.categoryName,
    this.statusName,
  });

  factory ExpiredResponse.fromJson(Map<String, dynamic> json) {
    return ExpiredResponse(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      description: json['description'],
      location: json['location'],
      expiredDate: json["expiredDate"] != null ? DateTime.parse(json["expiredDate"]) : null,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      statusName: json['statusName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'description': description,
      'location': location,
      'expiredDate': expiredDate,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'statusName': statusName,
    };
  }
}
