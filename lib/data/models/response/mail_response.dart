class MailResponse {
  final String? documentId;
  final String? email;
  final String? subject;
  final String? message;
  final String? fromEmail;
  final bool? isSend;
  final String? createdBy;
  final String? modifiedBy;
  final String? id;
  final String? modifiedDate;
  final String? createdDate;

  MailResponse({
    this.documentId,
    this.email,
    this.subject,
    this.message,
    this.fromEmail,
    this.isSend = false,
    this.createdBy,
    this.modifiedBy,
    this.id,
    this.modifiedDate,
    this.createdDate,
  });

  factory MailResponse.fromJson(Map<String, dynamic> json) {
    return MailResponse(
      documentId: json['documentId'] as String?,
      email: json['email'] as String?,
      subject: json['subject'] as String?,
      message: json['message'] as String?,
      fromEmail: json['fromEmail'] as String?,
      isSend: json['isSend'] as bool?,
      createdBy: json['createdBy'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      id: json['id'] as String?,
      modifiedDate: json['modifiedDate'] as String?,
      createdDate: json['createdDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'email': email,
      'subject': subject,
      'message': message,
      'fromEmail': fromEmail,
      'isSend': isSend,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
      'id': id,
      'modifiedDate': modifiedDate,
      'createdDate': createdDate,
    };
  }

  @override
  String toString() {
    return 'MailResponse{documentId: $documentId, email: $email, subject: $subject, '
        'message: $message, fromEmail: $fromEmail, isSend: $isSend, createdBy: $createdBy, '
        'modifiedBy: $modifiedBy, id: $id, modifiedDate: $modifiedDate, createdDate: $createdDate}';
  }
}
