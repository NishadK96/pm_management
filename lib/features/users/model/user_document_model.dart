// lib/features/users/models/user_document_model.dart

class UserDocumentModel {
  final String id;
  final String documentUrl;
  final String fileName;
  final String documentNumber;
  final String issueDate;
  final String expiryDate;

  UserDocumentModel({
    required this.id,
    required this.documentUrl,
    required this.fileName,
    required this.documentNumber,
    required this.issueDate,
    required this.expiryDate,
  });

  factory UserDocumentModel.fromJson(Map<String, dynamic> json) {
    return UserDocumentModel(
      id: json['id'] as String,
      documentUrl: json['document'] as String,
      fileName: (json['file_name'] as String?) ?? '',
      documentNumber: (json['document_number'] as String?) ?? '',
      issueDate: (json['issue_date'] as String?) ?? '',
      expiryDate: (json['expiry_date'] as String?) ?? '',
    );
  }
}