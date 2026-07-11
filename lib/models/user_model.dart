class UserModel {
  final int id;
  final String fullName;
  final String username;
  final String role;
  final String? officeName;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.role,
    this.officeName,
  });
}
