class DocumentReminderResponse {
  final String? id;
  final String? subject;
  final String? message;
  final int? frequency;
  final String? documentId;
  final String? documentName;
  final DateTime? createdDate;
  final DateTime? startDate;
  final DateTime? endDate;

  DocumentReminderResponse({
    this.id,
    this.subject,
    this.message,
    this.frequency,
    this.documentId,
    this.documentName,
    this.createdDate,
    this.startDate,
    this.endDate,
  });

  factory DocumentReminderResponse.fromJson(Map<String, dynamic> json) {
    return DocumentReminderResponse(
      id: json['id'] as String?,
      subject: json['subject'] as String?,
      message: json['message'] as String?,
      frequency: json['frequency'] as int?,
      documentId: json['documentId'] as String?,
      documentName: json['documentName'] as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'frequency': frequency,
      'documentId': documentId,
      'documentName': documentName,
      'createdDate': createdDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
DocumentReminderResponse(
  id: $id,
  subject: $subject,
  message: $message,
  frequency: $frequency,
  documentId: $documentId,
  documentName: $documentName,
  createdDate: $createdDate,
  startDate: $startDate,
  endDate: $endDate
)''';
  }
}
