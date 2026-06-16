import 'dart:convert';

SuccessResponse successResponseFromJson(String str) => SuccessResponse.fromJson(json.decode(str));

String successResponseToJson(SuccessResponse data) => json.encode(data.toJson());

class SuccessResponse {
    String? message;
    String? status;

    SuccessResponse({
        this.message,
        this.status,
    });

    factory SuccessResponse.fromJson(Map<String, dynamic> json) => SuccessResponse(
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
    };
}
