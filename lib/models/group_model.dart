class GroupModel {
  final int id;
  final String nameKh;
  final String code;
  final String categoryName;
  final int categoryId;
  final bool status;

  const GroupModel({
    required this.id,
    required this.nameKh,
    required this.code,
    required this.categoryName,
    required this.categoryId,
    required this.status,
  });
}
