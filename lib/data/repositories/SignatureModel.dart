class SignatureModel {
  final DateTime? createdDate;
  final String? signatureBy;
  final String? base64;

  SignatureModel({
     this.createdDate,
     this.signatureBy,
     this.base64,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      createdDate: json["createdDate"] != null ? DateTime.parse(json["createdDate"]) : null,
      signatureBy: json['signatureBy'],
      base64: json['base64'],
    );
  }
}
