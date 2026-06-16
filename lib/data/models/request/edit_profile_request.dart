class EditProfileRequest {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userName;
  final String email;

  EditProfileRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userName,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'userName': userName,
    'email': email,
  };

  @override
  String toString() =>
      'EditProfileRequest(id: $id, firstName: $firstName,lastName:$lastName, phoneNumber:$phoneNumber, userName:$userName, email:$email)';
}
