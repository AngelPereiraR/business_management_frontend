// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

class User {
  int id;
  String email;
  String username;
  String password;
  String role;
  bool enabled;
  dynamic token;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    required this.enabled,
    this.token,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        enabled: json["enabled"],
        token: json["token"],
      );
}
