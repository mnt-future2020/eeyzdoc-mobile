class DocumentWorkflowLogsResponse {
  final String? id;
  final String? workflowName;
  final String? documentWorkflowId;
  final DateTime? createdDate;
  final String? comment;
  final String? type;
  final String? transitionName;
  final String? fromStepName;
  final String? toStepName;
  final String? documentName;
  final String? documentId;
  final String? createdByName;

  DocumentWorkflowLogsResponse({
    this.id,
    this.workflowName,
    this.documentWorkflowId,
    this.createdDate,
    this.comment,
    this.type,
    this.transitionName,
    this.fromStepName,
    this.toStepName,
    this.documentName,
    this.documentId,
    this.createdByName,
  });

  factory DocumentWorkflowLogsResponse.fromJson(Map<String, dynamic> json) {
    return DocumentWorkflowLogsResponse(
      id: json['id'] as String?,
      workflowName: json['workflowName'] as String?,
      documentWorkflowId: json['documentWorkflowId'] as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      comment: json['comment'] as String?,
      type: json['type'] as String?,
      transitionName: json['transitionName'] as String?,
      fromStepName: json['fromStepName'] as String?,
      toStepName: json['toStepName'] as String?,
      documentName: json['documentName'] as String?,
      documentId: json['documentId'] as String?,
      createdByName: json['createdByName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workflowName': workflowName,
      'documentWorkflowId': documentWorkflowId,
      'createdDate': createdDate?.toIso8601String(),
      'comment': comment,
      'type': type,
      'transitionName': transitionName,
      'fromStepName': fromStepName,
      'toStepName': toStepName,
      'documentName': documentName,
      'documentId': documentId,
      'createdByName': createdByName,
    };
  }

  @override
  String toString() {
    return '''
DocumentWorkflowLogsResponse(
  id: $id,
  workflowName: $workflowName,
  documentWorkflowId: $documentWorkflowId,
  createdDate: $createdDate,
  comment: $comment,
  type: $type,
  transitionName: $transitionName,
  fromStepName: $fromStepName,
  toStepName: $toStepName,
  documentName: $documentName,
  documentId: $documentId,
  createdByName: $createdByName
)''';
  }
}
