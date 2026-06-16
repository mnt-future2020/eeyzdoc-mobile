// To parse this JSON data, do
//
//     final workFlowResponse = workFlowResponseFromJson(jsonString);

import 'dart:convert';

WorkFlowDetailsResponse workFlowResponseFromJson(String str) => WorkFlowDetailsResponse.fromJson(json.decode(str));

String workFlowResponseToJson(WorkFlowDetailsResponse data) => json.encode(data.toJson());

class WorkFlowDetailsResponse {
  String? workflowId;
  String? workflowName;
  String? workflowDescription;
  List<dynamic>? pendingWorkflowTransitions;
  List<CompletedWorkflowTransition>? completedWorkflowTransitions;
  List<Node>? nodes;
  List<Link>? links;
  List<CustomColor>? customColors;
  DateTime? createdDate;
  DateTime? initiatedDate;
  String? createdBy;
  String? initiatedBy;

  WorkFlowDetailsResponse({
    this.workflowId,
    this.workflowName,
    this.workflowDescription,
    this.pendingWorkflowTransitions,
    this.completedWorkflowTransitions,
    this.nodes,
    this.links,
    this.customColors,
    this.createdDate,
    this.initiatedDate,
    this.createdBy,
    this.initiatedBy,
  });

  factory WorkFlowDetailsResponse.fromJson(Map<String, dynamic> json) => WorkFlowDetailsResponse(
    workflowId: json["workflowId"],
    workflowName: json["workflowName"],
    workflowDescription: json["workflowDescription"],
    pendingWorkflowTransitions: json["pendingWorkflowTransitions"] == null ? [] : List<dynamic>.from(json["pendingWorkflowTransitions"]!.map((x) => x)),
    completedWorkflowTransitions: json["completedWorkflowTransitions"] == null ? [] : List<CompletedWorkflowTransition>.from(json["completedWorkflowTransitions"]!.map((x) => CompletedWorkflowTransition.fromJson(x))),
    nodes: json["nodes"] == null ? [] : List<Node>.from(json["nodes"]!.map((x) => Node.fromJson(x))),
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    customColors: json["customColors"] == null ? [] : List<CustomColor>.from(json["customColors"]!.map((x) => CustomColor.fromJson(x))),
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    initiatedDate: json["initiatedDate"] == null ? null : DateTime.parse(json["initiatedDate"]),
    createdBy: json["createdBy"],
    initiatedBy: json["initiatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "workflowId": workflowId,
    "workflowName": workflowName,
    "workflowDescription": workflowDescription,
    "pendingWorkflowTransitions": pendingWorkflowTransitions == null ? [] : List<dynamic>.from(pendingWorkflowTransitions!.map((x) => x)),
    "completedWorkflowTransitions": completedWorkflowTransitions == null ? [] : List<dynamic>.from(completedWorkflowTransitions!.map((x) => x.toJson())),
    "nodes": nodes == null ? [] : List<dynamic>.from(nodes!.map((x) => x.toJson())),
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "customColors": customColors == null ? [] : List<dynamic>.from(customColors!.map((x) => x.toJson())),
    "createdDate": createdDate?.toIso8601String(),
    "initiatedDate": initiatedDate?.toIso8601String(),
    "createdBy": createdBy,
    "initiatedBy": initiatedBy,
  };
}

class CompletedWorkflowTransition {
  String? id;
  String? transitionId;
  String? name;
  String? fromStepName;
  String? toStepName;
  String? comment;
  String? createdBy;
  DateTime? createdDate;

  CompletedWorkflowTransition({
    this.id,
    this.transitionId,
    this.name,
    this.fromStepName,
    this.toStepName,
    this.comment,
    this.createdBy,
    this.createdDate,
  });

  factory CompletedWorkflowTransition.fromJson(Map<String, dynamic> json) => CompletedWorkflowTransition(
    id: json["id"],
    transitionId: json["transitionId"],
    name: json["name"],
    fromStepName: json["fromStepName"],
    toStepName: json["toStepName"],
    comment: json["comment"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transitionId": transitionId,
    "name": name,
    "fromStepName": fromStepName,
    "toStepName": toStepName,
    "comment": comment,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
  };
}

class CustomColor {
  String? name;
  String? value;

  CustomColor({
    this.name,
    this.value,
  });

  factory CustomColor.fromJson(Map<String, dynamic> json) => CustomColor(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}

class Link {
  String? source;
  String? target;
  String? label;

  Link({
    this.source,
    this.target,
    this.label,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    source: json["source"],
    target: json["target"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "target": target,
    "label": label,
  };
}

class Node {
  String? id;
  String? label;

  Node({
    this.id,
    this.label,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
    id: json["id"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
  };
}
