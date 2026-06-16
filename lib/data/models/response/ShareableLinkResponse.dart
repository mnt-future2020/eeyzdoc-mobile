class ShareableLinkResponse {
  String? id;
  String? documentId;
  String? linkExpiryTime;
  String? password;
  String? linkCode;
  int? isAllowDownload;

  ShareableLinkResponse({
    this.id,
    this.documentId,
    this.linkExpiryTime,
    this.password,
    this.linkCode,
    this.isAllowDownload,
  });

  factory ShareableLinkResponse.fromJson(Map<String, dynamic> json) {
    return ShareableLinkResponse(
      id: json["id"],
      documentId: json["documentId"],
      linkExpiryTime: json["linkExpiryTime"],
      password: json["password"],
      linkCode: json["linkCode"],
      isAllowDownload: json['isAllowDownload'] ?? 0,
    );
  }
}
