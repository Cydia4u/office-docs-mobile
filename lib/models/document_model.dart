class DocumentModel {
  final int id;
  final String title;
  final String documentNumber;
  final String officeName;
  final String categoryName;
  final String fileType;
  final String uploadedBy;
  final String createdAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.documentNumber,
    required this.officeName,
    required this.categoryName,
    required this.fileType,
    required this.uploadedBy,
    required this.createdAt,
  });
}
