class ClientResponse {
  final String? id;
  final String? contactPerson;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? companyName;

  ClientResponse({
    this.id,
    this.contactPerson,
    this.email,
    this.phoneNumber,
    this.address,
    this.companyName,
  });

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      id: json['id'] as String?,
      contactPerson: json['contactPerson'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      companyName: json['companyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactPerson': contactPerson,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'companyName': companyName,
    };
  }

  @override
  String toString() {
    return 'ClientResponse{id: $id, contactPerson: $contactPerson, email: $email, '
        'phoneNumber: $phoneNumber, address: $address, companyName: $companyName}';
  }
}
