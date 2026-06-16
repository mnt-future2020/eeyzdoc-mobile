class ClientRequest {
  String? id;
  String? contactPerson;
  String? email;
  String? phoneNumber;
  String? address;
  String? companyName;

  ClientRequest({
    this.id = "",
    this.contactPerson = "",
    this.email = "",
    this.phoneNumber = "",
    this.address = "",
    this.companyName = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "contactPerson": contactPerson,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
      "companyName": companyName,
    };
  }
}
