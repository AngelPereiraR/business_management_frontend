// To parse this JSON data, do
//
//     final suggestion = suggestionFromMap(jsonString);

import 'dart:convert';

class Suggestion {
  int id;
  String commentary;
  String state;
  String username;
  List<Favorite>? favorite;

  Suggestion({
    required this.id,
    required this.commentary,
    required this.state,
    required this.username,
    this.favorite,
  });

  factory Suggestion.fromJson(String str) =>
      Suggestion.fromMap(json.decode(str));

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        commentary: json["commentary"],
        state: json["state"],
        username: json["username"],
        favorite: List<Favorite>.from(
            json["favorite"].map((x) => Favorite.fromMap(x))),
      );
}

class Favorite {
  int id;
  List<UserLike> userLikes;
  List<UserLike> userDislikes;

  Favorite({
    required this.id,
    required this.userLikes,
    required this.userDislikes,
  });

  factory Favorite.fromJson(String str) => Favorite.fromMap(json.decode(str));

  factory Favorite.fromMap(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        userLikes: List<UserLike>.from(
            json["userLikes"].map((x) => UserLike.fromMap(x))),
        userDislikes: List<UserLike>.from(
            json["userDislikes"].map((x) => UserLike.fromMap(x))),
      );
}

class UserLike {
  int id;
  String email;
  String username;
  String password;
  String role;
  bool enabled;
  dynamic token;

  UserLike({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    required this.enabled,
    this.token,
  });

  factory UserLike.fromJson(String str) => UserLike.fromMap(json.decode(str));

  factory UserLike.fromMap(Map<String, dynamic> json) => UserLike(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        enabled: json["enabled"],
        token: json["token"],
      );
}
