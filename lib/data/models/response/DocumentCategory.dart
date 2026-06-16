class DocumentCategory {
  final String categoryName;
  final int documentCount;

  DocumentCategory(this.categoryName, this.documentCount);

  factory DocumentCategory.fromJson(Map<String, dynamic> json) {
    return DocumentCategory(
      json['categoryName'] ?? '',
      json['documentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'documentCount': documentCount,
  };
}
