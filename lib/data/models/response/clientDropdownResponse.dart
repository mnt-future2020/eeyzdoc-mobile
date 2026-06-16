class ClientDropdownResponse {
  final String id;
  final String companyName;
  final String? contactPerson;
  final String? email;
  final String? phoneNumber;
  final String? address;

  ClientDropdownResponse({
    required this.id,
    required this.companyName,
     this.contactPerson,
     this.email,
     this.phoneNumber,
     this.address,
  });

  factory ClientDropdownResponse.fromJson(Map<String, dynamic> json) {
    return ClientDropdownResponse(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
