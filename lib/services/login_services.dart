// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:requests/requests.dart';

class LoginServices extends ChangeNotifier {
  final String _baseUrl = '192.168.212.68:8080';

  final storage = const FlutterSecureStorage();

  LoginServices();

  postLogin(String user, String password) async {
    var response = await Requests.post("http://$_baseUrl/login",
        body: {'user': user, 'password': password});

    var type;
    String error = '';
    var resp;
    final Map<String, dynamic> login =
        json.decode(utf8.decode(response.bodyBytes));
    if (login.containsKey("id")) {
      login.forEach((key, value) {
        if (key == "token") {
          storage.write(key: 'token', value: value);
        }
        if (key == "id") {
          storage.write(key: 'id', value: value.toString());
        }
        if (key == "role") {
          type = value;
        }
        if (key == "enabled") {
          if (value == true) {
            resp = type;
          } else {
            error = 'THIS ACCOUNT IS NOT ACTIVED';

            resp = error;
          }
        }
      });
    } else {
      if (error.isEmpty) {
        error = 'ERROR TO LOGIN. CHECK EMAIL OR PASSWORD';

        resp = error;
      }
    }
    return resp;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<int> readId() async {
    String? i = await storage.read(key: 'id');
    return int.parse(i!);
  }
}
