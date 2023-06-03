// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../services/services.dart';

class InsertServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.212.68:8080';

  InsertServices();

  insertCategory(int? id, String name, String description) async {
    String? token = await LoginServices().readToken();
    var response = await Requests.post(
        "http://$_baseUrl/api/company/$id/categories",
        body: {'name': name, 'description': description},
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertCategory = json.decode(response.body);
    if (insertCategory.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT CATEGORY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  insertProduct(int? idCompany, int? idCategory, String name,
      String description, double price) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.post(
        "http://$_baseUrl/api/company/$idCompany/categories/$idCategory/product",
        body: {
          'name': name,
          'description': description,
          'price': price,
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertProduct =
        json.decode(utf8.decode(response.bodyBytes));
    if (insertProduct.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT PRODUCT. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  insertCompany(String? name, String? description) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.post("http://$_baseUrl/api/company/companies",
        body: {
          'name': name,
          'description': description,
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertCompany =
        json.decode(utf8.decode(response.bodyBytes));
    if (insertCompany.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT COMPANY. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  insertSuggestion(
      int? id, String? commentary, String state, String? username) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.post(
        "http://$_baseUrl/api/companies/$id/suggestions/$username",
        body: {
          'commentary': commentary,
          'state': state,
          'username': username,
        },
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertSuggestion =
        json.decode(utf8.decode(response.bodyBytes));
    if (insertSuggestion.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT SUGGESTION. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }

  insertOrder(double finalPrice, int? companyId, String? username) async {
    String? token = await LoginServices().readToken();

    var response = await Requests.post(
        "http://$_baseUrl/api/orders/$companyId/$username/$finalPrice",
        headers: {'Authorization': 'Bearer $token'},
        bodyEncoding: RequestBodyEncoding.JSON);

    var resp;
    final Map<String, dynamic> insertOrder =
        json.decode(utf8.decode(response.bodyBytes));
    if (insertOrder.containsKey("id")) {
      resp = 'OK';
    } else {
      String? error = '';

      error = 'ERROR TO INSERT ORDER. CHECK ATTRIBUTES';

      resp = error;
    }
    return resp;
  }
}
