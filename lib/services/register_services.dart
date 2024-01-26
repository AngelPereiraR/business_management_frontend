import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:requests/requests.dart';

class RegisterServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl =
      'https://business-management-api-angelpereira.koyeb.app';

  final storage = const FlutterSecureStorage();

  RegisterServices();

  postRegister(String email, String username, String password) async {
    var response = await Requests.post("$_baseUrl/register",
        body: {'email': email, 'username': username, 'password': password},
        bodyEncoding: RequestBodyEncoding.JSON);

    String resp = '';
    final Map<String, dynamic> register =
        json.decode(utf8.decode(response.bodyBytes));
    if (register.containsValue('ROLE_USER')) {
      register.forEach((key, value) {
        if (key == "token") {
          storage.write(key: 'token', value: value);
        }
        if (key == "id") {
          storage.write(key: 'id', value: value.toString());
        }
      });
    } else {
      String? error = '';

      error = 'Error to register. The email is already taken';

      resp = error;
    }
    return resp;
  }

  postRegisterCompany(String email, String username, String password) async {
    var response = await Requests.post("$_baseUrl/registerCompany",
        body: {'email': email, 'username': username, 'password': password},
        bodyEncoding: RequestBodyEncoding.JSON);

    String resp = '';
    final Map<String, dynamic> register =
        json.decode(utf8.decode(response.bodyBytes));
    if (register.containsValue('ROLE_COMPANY')) {
      register.forEach((key, value) {
        if (key == "token") {
          storage.write(key: 'token', value: value);
        }
        if (key == "id") {
          storage.write(key: 'id', value: value.toString());
        }
      });
    } else {
      String? error = '';

      error = 'Error to register. The email is already taken';

      resp = error;
    }
    return resp;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'id');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }
}
