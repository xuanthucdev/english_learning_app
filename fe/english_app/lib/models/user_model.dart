// lib/models/user_model.dart
class UserModel {
  final String email;
  final String fullName;
  final String phone;
  final String avatar;

  UserModel({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      fullName: json['fullName'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }
}
