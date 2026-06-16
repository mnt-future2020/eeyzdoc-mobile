class CommentModel {
  final String id;
  final String documentId;
  final String comment;
   String createdByName;
  final DateTime createdDate;

  CommentModel({
    required this.id,
    required this.documentId,
    required this.comment,
    required this.createdByName,
    required this.createdDate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      documentId: json['documentId'],
      comment: json['comment'] ?? '',
      createdByName: json['createdByName'] ?? 'Unknown',
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
