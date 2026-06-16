// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? status;
  String? message;
  List<String>? claims;
  User? user;
  Authorisation? authorisation;

  LoginResponse({
    this.status,
    this.message,
    this.claims,
    this.user,
    this.authorisation,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    claims: json["claims"] == null ? [] : List<String>.from(json["claims"]!.map((x) => x)),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    authorisation: json["authorisation"] == null ? null : Authorisation.fromJson(json["authorisation"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "claims": claims == null ? [] : List<dynamic>.from(claims!.map((x) => x)),
    "user": user?.toJson(),
    "authorisation": authorisation?.toJson(),
  };
}

class Authorisation {
  String? token;
  String? type;

  Authorisation({
    this.token,
    this.type,
  });

  factory Authorisation.fromJson(Map<String, dynamic> json) => Authorisation(
    token: json["token"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "type": type,
  };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? userName;
  String? phoneNumber;
  dynamic documentMaxSize;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userName,
    this.phoneNumber,
    this.documentMaxSize,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    userName: json["userName"],
    phoneNumber: json["phoneNumber"],
    documentMaxSize: json["documentMaxSize"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "userName": userName,
    "phoneNumber": phoneNumber,
    "documentMaxSize": documentMaxSize,
  };
}
