class FileRequestAdd {
  String? id;
  String subject;
  String email;
  List<int> fileExtension;
  int maxDocument;
  int sizeInMb;
  bool isPasswordRequired;
  String? password;
  bool isLinkExpired;
  DateTime? expiryDate;

  FileRequestAdd({
     this.id,
    required this.subject,
    required this.email,
    required this.fileExtension,
    required this.maxDocument,
    required this.sizeInMb,
    required this.isPasswordRequired,
    this.password,
    required this.isLinkExpired,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subject": subject,
      "email": email,
      "fileExtension": fileExtension,
      "maxDocument": maxDocument,
      "sizeInMb": sizeInMb,
      "isPasswordRequired": isPasswordRequired,
      "password": password,
      "isLinkExpired": isLinkExpired,
      "expiryDate": expiryDate?.toIso8601String(),
    };
  }
}
