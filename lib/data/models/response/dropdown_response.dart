class RoleDropdownResponse {
  final String id;
  final String name;

  const RoleDropdownResponse({required this.id, required this.name});

  factory RoleDropdownResponse.fromJson(Map<String, dynamic> json) {
    return RoleDropdownResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  String toString() => 'RoleDropdownResponse(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleDropdownResponse && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
