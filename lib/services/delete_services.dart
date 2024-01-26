// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../services/services.dart';

class DeleteServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl =
      'https://business-management-api-angelpereira.koyeb.app';

  DeleteServices();

  deleteCategory(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("$_baseUrl/api/company/categories/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }

  deleteProduct(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("$_baseUrl/api/company/products/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }

  deleteCompany(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("$_baseUrl/api/company/companies/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }

  deleteUser(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("$_baseUrl/api/users/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }

  deleteSuggestion(int id) async {
    String? token = await LoginServices().readToken();
    Requests.delete("$_baseUrl/api/suggestions/$id",
        headers: {'Authorization': 'Bearer $token'});

    var resp = 'OK';
    return resp;
  }
}
