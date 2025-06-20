class UserModel {
  final int id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? avatar;

  UserModel({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] as String?, // nullable
      email: json['email'] as String?, // nullable
      phone: json['phone'] as String?, // nullable
      avatar: json['avatar'] as String?, // nullable
    );
  }
}
