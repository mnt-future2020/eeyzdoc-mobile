class CategoryDropdownResponse {
  final String id;
  final String name;
  final String? parentId;
  List<CategoryDropdownResponse> children;

  CategoryDropdownResponse({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
  });

  factory CategoryDropdownResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDropdownResponse(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      children: json['children'] != null
          ? (json['children'] as List)
          .map((child) => CategoryDropdownResponse.fromJson(child))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "parentId": parentId,
      "children": children.map((e) => e.toJson()).toList(),
    };
  }
}
