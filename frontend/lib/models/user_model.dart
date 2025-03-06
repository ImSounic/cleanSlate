// frontend/lib/models/user_model.dart

class User {
  final String id;
  final String? email;
  final String? phone;
  final String? fullName;

  User({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
    };
  }
}
