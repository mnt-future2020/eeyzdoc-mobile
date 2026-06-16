// class DocumentDetailsResponse {
//   final String? id;
//   final String? name;
//   final String? url;
//   final DateTime? createdDate;
//   final DateTime? modifiedDate;
//   final String? description;
//   final bool? isIndexed;
//   final int? retentionPeriod;
//   final String? retentionAction;
//   final String? categoryId;
//   final String? categoryName;
//   final String? location;
//   final String? clientId;
//   final String? statusId;
//   final String? companyName;
//   final String? statusName;
//   final String? colorCode;
//   final String? createdByName;
//   final String? updatedByName;

//   DocumentDetailsResponse({
//     this.id,
//     this.name,
//     this.url,
//     this.createdDate,
//     this.modifiedDate,
//     this.description,
//     this.isIndexed,
//     this.retentionPeriod,
//     this.retentionAction,
//     this.categoryId,
//     this.categoryName,
//     this.location,
//     this.clientId,
//     this.statusId,
//     this.companyName,
//     this.statusName,
//     this.colorCode,
//     this.createdByName,
//     this.updatedByName,
//   });

//   factory DocumentDetailsResponse.fromJson(Map<String, dynamic> json) {
//     return DocumentDetailsResponse(
//       id: json['id'],
//       name: json['name'],
//       url: json['url'],
//       createdDate: json['createdDate'] != null
//           ? DateTime.tryParse(json['createdDate'])
//           : null,
//       modifiedDate: json['modifiedDate'] != null
//           ? DateTime.tryParse(json['modifiedDate'])
//           : null,
//       description: json['description'],
//       isIndexed: json['isIndexed'],
//       retentionPeriod: json['retentionPeriod'],
//       retentionAction: json['retentionAction'],
//       categoryId: json['categoryId'],
//       categoryName: json['categoryName'],
//       location: json['location'],
//       clientId: json['clientId'],
//       statusId: json['statusId'],
//       companyName: json['companyName'],
//       statusName: json['statusName'],
//       colorCode: json['colorCode'],
//       createdByName: json['createdByName'],
//       updatedByName: json['updatedByName'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'url': url,
//       'createdDate': createdDate?.toIso8601String(),
//       'modifiedDate': modifiedDate?.toIso8601String(),
//       'description': description,
//       'isIndexed': isIndexed,
//       'retentionPeriod': retentionPeriod,
//       'retentionAction': retentionAction,
//       'categoryId': categoryId,
//       'categoryName': categoryName,
//       'location': location,
//       'clientId': clientId,
//       'statusId': statusId,
//       'companyName': companyName,
//       'statusName': statusName,
//       'colorCode': colorCode,
//       'createdByName': createdByName,
//       'updatedByName': updatedByName,
//     };
//   }

//   @override
//   String toString() {
//     return '''
// DocumentDetailsResponse(
//   id: $id,
//   name: $name,
//   url: $url,
//   createdDate: $createdDate,
//   modifiedDate: $modifiedDate,
//   description: $description,
//   isIndexed: $isIndexed,
//   retentionPeriod: $retentionPeriod,
//   retentionAction: $retentionAction,
//   categoryId: $categoryId,
//   categoryName: $categoryName,
//   location: $location,
//   clientId: $clientId,
//   statusId: $statusId,
//   companyName: $companyName,
//   statusName: $statusName,
//   colorCode: $colorCode,
//   createdByName: $createdByName,
//   updatedByName: $updatedByName
// )''';
//   }
// }

class DocumentDetailsResponse {
  final String? id;
  final String? name;
  final String? url;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final String? description;
  final bool? isIndexed;
  final int? retentionPeriod;
  final int? retentionAction; // FIXED ✔
  final String? categoryId;
  final String? categoryName;
  final String? location;
  final String? clientId;
  final String? statusId;
  final String? companyName;
  final String? statusName;
  final String? colorCode;
  final String? createdByName;
  final String? updatedByName;

  DocumentDetailsResponse({
    this.id,
    this.name,
    this.url,
    this.createdDate,
    this.modifiedDate,
    this.description,
    this.isIndexed,
    this.retentionPeriod,
    this.retentionAction,
    this.categoryId,
    this.categoryName,
    this.location,
    this.clientId,
    this.statusId,
    this.companyName,
    this.statusName,
    this.colorCode,
    this.createdByName,
    this.updatedByName,
  });

  factory DocumentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentDetailsResponse(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.tryParse(json['modifiedDate'])
          : null,
      description: json['description'],
      isIndexed: json['isIndexed'],
      retentionPeriod: json['retentionPeriod'],
      retentionAction: json['retentionAction'], // FIXED ✔
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      location: json['location'],
      clientId: json['clientId'],
      statusId: json['statusId'],
      companyName: json['companyName'],
      statusName: json['statusName'],
      colorCode: json['colorCode'],
      createdByName: json['createdByName'],
      updatedByName: json['updatedByName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'createdDate': createdDate?.toIso8601String(),
      'modifiedDate': modifiedDate?.toIso8601String(),
      'description': description,
      'isIndexed': isIndexed,
      'retentionPeriod': retentionPeriod,
      'retentionAction': retentionAction, // FIXED ✔
      'categoryId': categoryId,
      'categoryName': categoryName,
      'location': location,
      'clientId': clientId,
      'statusId': statusId,
      'companyName': companyName,
      'statusName': statusName,
      'colorCode': colorCode,
      'createdByName': createdByName,
      'updatedByName': updatedByName,
    };
  }
}
