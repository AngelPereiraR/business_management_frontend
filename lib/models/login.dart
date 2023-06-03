// To parse this JSON data, do
//
//     final login = loginFromMap(jsonString);

import 'dart:convert';

class Login {
  Login({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.enabled,
    required this.token,
  });

  int id;
  String username;
  String password;
  String role;
  bool enabled;
  String token;

  factory Login.fromJson(String str) => Login.fromMap(json.decode(str));

  factory Login.fromMap(Map<String, dynamic> json) => Login(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        enabled: json["enabled"],
        token: json["token"],
      );
}
