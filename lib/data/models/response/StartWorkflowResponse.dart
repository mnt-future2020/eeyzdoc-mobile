import 'dart:convert';

List<StartWorkflowResponse> startWorkflowResponseFromJson(String str) =>
    List<StartWorkflowResponse>.from(
        json.decode(str).map((x) => StartWorkflowResponse.fromJson(x)));

String startWorkflowResponseToJson(List<StartWorkflowResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StartWorkflowResponse {
  String? id;
  String? name;
  String? description;
  String? createdBy;
  int? isWorkflowSetup;
  String? modifiedBy;
  String? deletedBy;
  int? isDeleted;
  String? createdDate;
  String? modifiedDate;
  dynamic deletedAt;
  List<WorkflowStep>? workflowSteps;
  List<Transition>? transitions;

  StartWorkflowResponse({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.isWorkflowSetup,
    this.modifiedBy,
    this.deletedBy,
    this.isDeleted,
    this.createdDate,
    this.modifiedDate,
    this.deletedAt,
    this.workflowSteps,
    this.transitions,
  });

  factory StartWorkflowResponse.fromJson(Map<String, dynamic> json) => StartWorkflowResponse(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdBy: json["createdBy"],
    isWorkflowSetup: json["isWorkflowSetup"],
    modifiedBy: json["modifiedBy"],
    deletedBy: json["deletedBy"],
    isDeleted: json["isDeleted"],
    createdDate: json["createdDate"],
    modifiedDate: json["modifiedDate"],
    deletedAt: json["deletedAt"],
    workflowSteps: json["workflowSteps"] == null
        ? []
        : List<WorkflowStep>.from(
        json["workflowSteps"].map((x) => WorkflowStep.fromJson(x))),
    transitions: json["transitions"] == null
        ? []
        : List<Transition>.from(
        json["transitions"].map((x) => Transition.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "createdBy": createdBy,
    "isWorkflowSetup": isWorkflowSetup,
    "modifiedBy": modifiedBy,
    "deletedBy": deletedBy,
    "isDeleted": isDeleted,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
    "deletedAt": deletedAt,
    "workflowSteps": workflowSteps == null
        ? []
        : List<dynamic>.from(workflowSteps!.map((x) => x.toJson())),
    "transitions": transitions == null
        ? []
        : List<dynamic>.from(transitions!.map((x) => x.toJson())),
  };
}

class WorkflowStep {
  String? id;
  String? workflowId;
  String? name;

  WorkflowStep({this.id, this.workflowId, this.name});

  factory WorkflowStep.fromJson(Map<String, dynamic> json) => WorkflowStep(
    id: json["id"],
    workflowId: json["workflowId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "workflowId": workflowId,
    "name": name,
  };
}

class Transition {
  String? id;
  String? workflowId;
  String? fromStepId;
  String? toStepId;
  String? name;
  String? color;
  int? orderNo;
  bool? isFirstTransaction;

  Transition({
    this.id,
    this.workflowId,
    this.fromStepId,
    this.toStepId,
    this.name,
    this.color,
    this.orderNo,
    this.isFirstTransaction,
  });

  factory Transition.fromJson(Map<String, dynamic> json) => Transition(
    id: json["id"],
    workflowId: json["workflowId"],
    fromStepId: json["fromStepId"],
    toStepId: json["toStepId"],
    name: json["name"],
    color: json["color"],
    orderNo: json["orderNo"],
    isFirstTransaction: json["isFirstTransaction"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "workflowId": workflowId,
    "fromStepId": fromStepId,
    "toStepId": toStepId,
    "name": name,
    "color": color,
    "orderNo": orderNo,
    "isFirstTransaction": isFirstTransaction,
  };
}
