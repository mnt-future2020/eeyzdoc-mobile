import 'package:intl/intl.dart';

class DocumentVersionHistoryResponse {
  final bool? isCurrentVersion;
  final String? id;
  final String? url;
  final DateTime? modifiedDate;
  final String? createdByUser;
  final String? signedByUser;
  final DateTime? signDate;

  DocumentVersionHistoryResponse({
    this.isCurrentVersion,
    this.id,
    this.url,
    this.modifiedDate,
    this.createdByUser,
    this.signedByUser,
    this.signDate,
  });

  factory DocumentVersionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return DocumentVersionHistoryResponse(
      isCurrentVersion: json['isCurrentVersion'] as bool?,
      id: json['id'] as String?,
      url: json['url'] as String?,
      modifiedDate: _parseDate(json['modifiedDate']),
      createdByUser: json['createdByUser'] as String?,
      signedByUser: json['signedByUser'] as String?,
      signDate: json['signDate'] != null
          ? DateTime.tryParse(json['signDate'])
          : null,
    );
  }

  // ------------------------------
  // TO JSON
  // ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'isCurrentVersion': isCurrentVersion,
      'id': id,
      'url': url,
      'modifiedDate': modifiedDate?.toIso8601String(),
      'createdByUser': createdByUser,
      'signedByUser': signedByUser,
      'signDate': signDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
DocumentVersionHistoryResponse(
  isCurrentVersion: $isCurrentVersion,
  id: $id,
  url: $url,
  modifiedDate: $modifiedDate,
  createdByUser: $createdByUser,
  signedByUser: $signedByUser,
  signDate: $signDate
)''';
  }
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;

    if (date is DateTime) return date;

    if (date is String) {
      // 1. Try ISO
      try {
        return DateTime.parse(date);
      } catch (_) {}

      // 2. Try "yyyy-MM-dd HH:mm:ss UTC"
      try {
        final formatter = DateFormat("yyyy-MM-dd HH:mm:ss 'UTC'");
        return formatter.parseUtc(date);
      } catch (_) {}

      // 3. Try "yyyy-MM-dd HH:mm:ss"
      try {
        final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
        final parsed = formatter.parse(date);
        return parsed.toUtc();
      } catch (_) {}

      return null;
    }

    return null;
  }
}
