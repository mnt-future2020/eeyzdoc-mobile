// To parse this JSON data, do
//
//     final workFlowResponse = workFlowResponseFromJson(jsonString);

import 'dart:convert';

List<WorkFlowResponse> workFlowResponseFromJson(String str) => List<WorkFlowResponse>.from(json.decode(str).map((x) => WorkFlowResponse.fromJson(x)));

String workFlowResponseToJson(List<WorkFlowResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkFlowResponse {
  String? id;
  String? documentWorkflowId;
  String? documentName;
  String? workflowName;
  String? status;
  DateTime? createdDate;
  String? createdByName;
  String? initiatedBy;
  DateTime? modifiedDate;
  String? modifiedUserName;
  String? documentId;
  TTransition? lastTransition;
  List<TTransition>? nextTransitions;

  WorkFlowResponse({
    this.id,
    this.documentWorkflowId,
    this.documentName,
    this.workflowName,
    this.status,
    this.createdDate,
    this.createdByName,
    this.initiatedBy,
    this.modifiedDate,
    this.modifiedUserName,
    this.documentId,
    this.lastTransition,
    this.nextTransitions,
  });

  factory WorkFlowResponse.fromJson(Map<String, dynamic> json) => WorkFlowResponse(
    id: json["id"],
    documentWorkflowId: json["documentWorkflowId"],
    documentName: json["documentName"],
    workflowName: json["workflowName"],
    status: json["status"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdByName: json["createdByName"],
    initiatedBy: json["initiatedBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    modifiedUserName: json["modifiedUserName"],
    documentId: json["documentId"],
    lastTransition: json["lastTransition"] == null ? null : TTransition.fromJson(json["lastTransition"]),
    nextTransitions: json["nextTransitions"] == null ? [] : List<TTransition>.from(json["nextTransitions"]!.map((x) => TTransition.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "documentWorkflowId": documentWorkflowId,
    "documentName": documentName,
    "workflowName": workflowName,
    "status": status,
    "createdDate": createdDate?.toIso8601String(),
    "createdByName": createdByName,
    "initiatedBy": initiatedBy,
    "modifiedDate": modifiedDate?.toIso8601String(),
    "modifiedUserName": modifiedUserName,
    "documentId": documentId,
    "lastTransition": lastTransition?.toJson(),
    "nextTransitions": nextTransitions == null ? [] : List<dynamic>.from(nextTransitions!.map((x) => x.toJson())),
  };
}

class TTransition {
  String? id;
  String? name;
  String? fromStepId;
  String? fromStepName;
  String? toStepId;
  String? toStepName;
  String? fromToStepName;
  DateTime? performedAt;
  String? color;

  TTransition({
    this.id,
    this.name,
    this.fromStepId,
    this.fromStepName,
    this.toStepId,
    this.toStepName,
    this.fromToStepName,
    this.performedAt,
    this.color,
  });

  factory TTransition.fromJson(Map<String, dynamic> json) => TTransition(
    id: json["id"],
    name: json["name"],
    fromStepId: json["fromStepId"],
    fromStepName: json["fromStepName"],
    toStepId: json["toStepId"],
    toStepName: json["toStepName"],
    fromToStepName: json["fromToStepName"],
    performedAt: json["performedAt"] == null ? null : DateTime.parse(json["performedAt"]),
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fromStepId": fromStepId,
    "fromStepName": fromStepName,
    "toStepId": toStepId,
    "toStepName": toStepName,
    "fromToStepName": fromToStepName,
    "performedAt": performedAt?.toIso8601String(),
    "color": color,
  };
}
