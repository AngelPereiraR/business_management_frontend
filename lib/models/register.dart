// To parse this JSON data, do
//
//     final register = registerFromMap(jsonString);

import 'dart:convert';

class Register {
  Register({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.enabled,
    this.token,
  });

  int id;
  String username;
  String password;
  String role;
  bool enabled;
  dynamic token;

  factory Register.fromJson(String str) => Register.fromMap(json.decode(str));

  factory Register.fromMap(Map<String, dynamic> json) => Register(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        enabled: json["enabled"],
        token: json["token"],
      );
}
