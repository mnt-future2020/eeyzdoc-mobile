class MailRequest {
  String documentId;
  String email;
  String subject;
  String message;

  MailRequest({
    required this.documentId,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "documentId": documentId,
      "email": email,
      "subject": subject,
      "message": message,
    };
  }
}
