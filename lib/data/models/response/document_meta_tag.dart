class DocumentMetaTag {
  final String? id;
  final String? documentId;
  final String? metatag;

  DocumentMetaTag({
    this.id,
    this.documentId,
    this.metatag
  });

  factory DocumentMetaTag.fromJson(Map<String, dynamic> json) {
    return DocumentMetaTag(
      id: json['id'],
      documentId: json['documentId'],
      metatag: json['metatag']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'metatag': metatag
    };
  }
}
