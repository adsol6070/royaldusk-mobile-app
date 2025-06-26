class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime joinedDate;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.joinedDate,
    this.isVerified = false,
  });
}
