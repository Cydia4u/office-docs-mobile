class DocumentModel {
  final int id;
  final String title;
  final String description;
  final String documentNumber;
  final String officeName;
  final String categoryName;
  final String groupName;
  final String fileType;
  final String fileUrl;
  final String uploadedBy;
  final String createdAt;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.documentNumber,
    required this.officeName,
    required this.categoryName,
    required this.groupName,
    required this.fileType,
    required this.fileUrl,
    required this.uploadedBy,
    required this.createdAt,
  });
}
