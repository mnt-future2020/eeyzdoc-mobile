class DocumentResponse {
  final String id;
  String name;
  final String url;
  final String createdDate;
  String? description;
  final String? location;
  String? clientId;
  String? statusId;
  final bool isIndexed;
  int? retentionPeriod;
  int? retentionAction;
  String categoryId;
  final String categoryName;
  final String? companyName;
  final String? statusName;
  final String? colorCode;
  final String? documentWorkflowId;
  final String? workflowName;
  final String? documentWorkflowStatus;
  final String? signByUserName;
  final String? signDate;
  final bool isWorkflowCompleted;
  final String createdByName;
  final int commentCount;
  final int versionCount;

  DocumentResponse({
    required this.id,
    required this.name,
    required this.url,
    required this.createdDate,
    this.description,
    this.location,
    this.clientId,
    this.statusId,
    required this.isIndexed,
    this.retentionPeriod,
    this.retentionAction,
    required this.categoryId,
    required this.categoryName,
    this.companyName,
    this.statusName,
    this.colorCode,
    this.documentWorkflowId,
    this.workflowName,
    this.documentWorkflowStatus,
    this.signByUserName,
    this.signDate,
    required this.isWorkflowCompleted,
    required this.createdByName,
    required this.commentCount,
    required this.versionCount,
  });

  factory DocumentResponse.fromJson(Map<String, dynamic> json) {
    return DocumentResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      createdDate: json['createdDate']?.toString() ?? '',
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      clientId: json['clientId']?.toString(),
      statusId: json['statusId']?.toString(),
      isIndexed: json['isIndexed'] as bool? ?? false,
      retentionPeriod: json['retentionPeriod']??0,
      retentionAction: json['retentionAction']??0,
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      companyName: json['companyName']?.toString(),
      statusName: json['statusName']?.toString(),
      colorCode: json['colorCode']?.toString(),
      documentWorkflowId: json['documentWorkflowId']?.toString(),
      workflowName: json['workflowName']?.toString(),
      documentWorkflowStatus: json['documentWorkflowStatus']?.toString(),
      signByUserName: json['signByUserName']?.toString(),
      signDate: json['signDate']?.toString(),
      isWorkflowCompleted: json['isWorkflowCompleted'] as bool? ?? false,
      createdByName: json['createdByName']?.toString() ?? '',
      commentCount: _parseInt(json['commentCount']) ?? 0,
      versionCount: _parseInt(json['versionCount']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'createdDate': createdDate,
    'description': description,
    'location': location,
    'clientId': clientId,
    'statusId': statusId,
    'isIndexed': isIndexed,
    'retentionPeriod': retentionPeriod,
    'retentionAction': retentionAction,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'companyName': companyName,
    'statusName': statusName,
    'colorCode': colorCode,
    'documentWorkflowId': documentWorkflowId,
    'workflowName': workflowName,
    'documentWorkflowStatus': documentWorkflowStatus,
    'signByUserName': signByUserName,
    'signDate': signDate,
    'isWorkflowCompleted': isWorkflowCompleted,
    'createdByName': createdByName,
    'commentCount': commentCount,
    'versionCount': versionCount,
  };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  @override
  String toString() {
    return 'DocumentResponse('
        'id: "$id", '
        'name: "$name", '
        'url: "${_obscureUrl(url)}", '
        'createdDate: "$createdDate", '
        'description: $description, '
        'location: $location, '
        'clientId: $clientId, '
        'statusId: $statusId, '
        'isIndexed: $isIndexed, '
        'retentionPeriod: $retentionPeriod, '
        'retentionAction: $retentionAction, '
        'categoryId: "$categoryId", '
        'categoryName: "$categoryName", '
        'companyName: $companyName, '
        'statusName: $statusName, '
        'colorCode: $colorCode, '
        'documentWorkflowId: $documentWorkflowId, '
        'workflowName: $workflowName, '
        'documentWorkflowStatus: $documentWorkflowStatus, '
        'signByUserName: $signByUserName, '
        'signDate: $signDate, '
        'isWorkflowCompleted: $isWorkflowCompleted, '
        'createdByName: "$createdByName", '
        'commentCount: $commentCount, '
        'versionCount: $versionCount)';
  }

  static String _obscureUrl(String url) {
    if (url.length <= 15) return '••••••••';
    return '••••${url.substring(url.length - 10)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          url == other.url &&
          createdDate == other.createdDate &&
          description == other.description &&
          location == other.location &&
          clientId == other.clientId &&
          statusId == other.statusId &&
          isIndexed == other.isIndexed &&
          retentionPeriod == other.retentionPeriod &&
          retentionAction == other.retentionAction &&
          categoryId == other.categoryId &&
          categoryName == other.categoryName &&
          companyName == other.companyName &&
          statusName == other.statusName &&
          colorCode == other.colorCode &&
          documentWorkflowId == other.documentWorkflowId &&
          workflowName == other.workflowName &&
          documentWorkflowStatus == other.documentWorkflowStatus &&
          signByUserName == other.signByUserName &&
          signDate == other.signDate &&
          isWorkflowCompleted == other.isWorkflowCompleted &&
          createdByName == other.createdByName &&
          commentCount == other.commentCount &&
          versionCount == other.versionCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      url.hashCode ^
      createdDate.hashCode ^
      description.hashCode ^
      location.hashCode ^
      clientId.hashCode ^
      statusId.hashCode ^
      isIndexed.hashCode ^
      retentionPeriod.hashCode ^
      retentionAction.hashCode ^
      categoryId.hashCode ^
      categoryName.hashCode ^
      companyName.hashCode ^
      statusName.hashCode ^
      colorCode.hashCode ^
      documentWorkflowId.hashCode ^
      workflowName.hashCode ^
      documentWorkflowStatus.hashCode ^
      signByUserName.hashCode ^
      signDate.hashCode ^
      isWorkflowCompleted.hashCode ^
      createdByName.hashCode ^
      commentCount.hashCode ^
      versionCount.hashCode;
}
