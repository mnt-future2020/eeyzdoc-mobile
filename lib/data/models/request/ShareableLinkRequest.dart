class ShareableLinkRequest {
  String? id;
  String documentId;
  bool? isAllowDownload;
  String? password;
  String? linkExpiryTime;
  String? linkCode;
  String? message;

  ShareableLinkRequest({
    this.id,
    required this.documentId,
    this.isAllowDownload,
    this.password,
    this.linkExpiryTime,
    this.linkCode,
    this.message,
  });

  Map<String, dynamic> toJson() => {
    "id": id ?? "",
    "documentId": documentId,
    "isAllowDownload": isAllowDownload ?? false,
    "password": password ?? "",
    "linkExpiryTime": linkExpiryTime,
    "linkCode": linkCode ?? "",
  };

}
