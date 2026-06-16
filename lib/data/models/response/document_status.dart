class DocumentStatus {
  final String id;
  final String name;
  final String? description;
  final String colorCode;

  DocumentStatus({
    required this.id,
    required this.name,
    this.description,
    required this.colorCode,
  });

  factory DocumentStatus.fromJson(Map<String, dynamic> json) {
    return DocumentStatus(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      colorCode: json['colorCode'],
    );
  }
}
