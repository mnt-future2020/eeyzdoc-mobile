class NotificationResponse {
  final String? id;
  final String? userId;
  final String? message;
  final bool? isRead;
  final String? documentId;
  final String? createdDate;
  final String? modifiedDate;
  final int? notificationType;
  final String? documentWorkflowId;
  final String? fileRequestId;
  final String? documentName;
  final String? workflowName;
  final String? workflowDocumentName;
  final String? fileRequestSubject;

  NotificationResponse({
    this.id,
    this.userId,
    this.message,
    this.isRead,
    this.documentId,
    this.createdDate,
    this.modifiedDate,
    this.notificationType,
    this.documentWorkflowId,
    this.fileRequestId,
    this.documentName,
    this.workflowName,
    this.workflowDocumentName,
    this.fileRequestSubject,
  });

  String get title {
    if (notificationType == 0) {
      return documentName ?? "Document";
    }

    if (notificationType == 2) {
      return fileRequestSubject ?? "File Request Document";
    }

    if (notificationType == 3) {
      return workflowDocumentName ?? workflowName ?? "Workflow Document";
    }

    return documentName ?? message ?? "Notification";
  }

  String get subtitle {
    if (notificationType == 0) {
      return "Document Permission Granted to you.";
    }

    if (notificationType == 2) {
      return "File Request with subject  "
          "'$fileRequestSubject' has been updated";
    }
    if (notificationType == 3) {
      return "You've been assigned the new action for document "
          "'${workflowDocumentName ?? "document"}' "
          "as part of the '${workflowName ?? "workflow"}' workflow.";
    }

    return message ?? "";
  }

  String get timeStamp {
    if (createdDate == null) return "";

    final dateTime = DateTime.parse(createdDate!).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return "Just now";

    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";

    if (diff.inHours < 24) return "${diff.inHours} hours ago";

    final dd = dateTime.day.toString().padLeft(2, '0');
    final mm = dateTime.month.toString().padLeft(2, '0');
    final yyyy = dateTime.year;

    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    if (hour == 0) hour = 12;
    final hh = hour.toString().padLeft(2, '0');
    final min = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour >= 12 ? "PM" : "AM";

    return "$dd-$mm-$yyyy · $hh:$min $ampm";
  }

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      message: json['message'] as String?,
      isRead: json['isRead'] as bool?,
      documentId: json['documentId'] as String?,
      createdDate: json['createdDate'] as String?,
      modifiedDate: json['modifiedDate'] as String?,
      notificationType: json['notificationType'] as int?,
      documentWorkflowId: json['documentWorkflowId'] as String?,
      fileRequestId: json['fileRequestId'] as String?,
      documentName: json['documentName'] as String?,
      workflowName: json['workflowName'] as String?,
      workflowDocumentName: json['workflowDocumentName'] as String?,
      fileRequestSubject: json['fileRequestSubject'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'isRead': isRead,
      'documentId': documentId,
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
      'notificationType': notificationType,
      'documentWorkflowId': documentWorkflowId,
      'fileRequestId': fileRequestId,
      'documentName': documentName,
      'workflowName': workflowName,
      'workflowDocumentName': workflowDocumentName,
      'fileRequestSubject': fileRequestSubject,
    };
  }

  @override
  String toString() {
    return 'NotificationResponse{id: $id, userId: $userId, message: $message, '
        'isRead: $isRead, documentId: $documentId, createdDate: $createdDate, '
        'modifiedDate: $modifiedDate, notificationType: $notificationType, '
        'documentWorkflowId: $documentWorkflowId, fileRequestId: $fileRequestId, '
        'documentName: $documentName, workflowName: $workflowName, '
        'workflowDocumentName: $workflowDocumentName, fileRequestSubject: $fileRequestSubject}';
  }
}
