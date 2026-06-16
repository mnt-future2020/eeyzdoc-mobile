class WorkflowCommentRequest {
  String? comment;
  String? documentId;
  String? documentWorkflowId;
  String? transitionId;


  WorkflowCommentRequest({
    this.comment = "",
    this.documentId = "",
    this.documentWorkflowId = "",
    this.transitionId = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
      "documentId": documentId,
      "documentWorkflowId": documentWorkflowId,
      "transitionId": transitionId,
    };
  }
}
